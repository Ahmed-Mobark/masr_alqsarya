import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/methods/covert_datetime_to_string.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/core/realtime/realtime_service.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';
import 'package:masr_al_qsariya/core/storage/workspace_id_storage.dart';
import 'package:masr_al_qsariya/features/messages/domain/entities/chat_attachment.dart';
import 'package:masr_al_qsariya/features/messages/domain/entities/chat_message.dart';
import 'package:masr_al_qsariya/features/messages/domain/usecases/download_chat_attachment_usecase.dart';
import 'package:masr_al_qsariya/features/messages/domain/usecases/get_chat_messages_usecase.dart';
import 'package:masr_al_qsariya/features/messages/domain/usecases/send_chat_message_usecase.dart';
import 'package:masr_al_qsariya/features/messages/presentation/cubit/chat_detail_state.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ChatDetailCubit extends Cubit<ChatDetailState> {
  ChatDetailCubit(
    this._getMessages,
    this._sendMessage,
    this._downloadAttachment,
    this._workspaceIdStorage,
    this._storage,
    this._realtime,
    this.chatId,
  ) : super(const ChatDetailState());

  final GetChatMessagesUseCase _getMessages;
  final SendChatMessageUseCase _sendMessage;
  final DownloadChatAttachmentUseCase _downloadAttachment;
  final WorkspaceIdStorage _workspaceIdStorage;
  final Storage _storage;
  final RealtimeService _realtime;
  final int chatId;

  bool _soketiSubscribed = false;
  Timer? _pollTimer;

  static const _pollInterval = Duration(seconds: 8);

  void clearSendError() {
    emit(state.copyWith(clearSendError: true));
  }

  void clearAttachmentFeedback() {
    emit(state.copyWith(clearAttachmentFeedback: true));
  }

  Future<void> downloadAttachment(ChatAttachment attachment) async {
    final workspaceId = _workspaceIdStorage.get();
    if (workspaceId == null) {
      emit(state.copyWith(
        clearAttachmentFeedback: true,
        attachmentFeedback: '__workspace_missing__',
      ));
      return;
    }

    emit(state.copyWith(
      clearAttachmentFeedback: true,
      attachmentFeedback: null,
      downloadingAttachmentId: attachment.id,
    ));

    final result = await _downloadAttachment(
      DownloadChatAttachmentParams(
        workspaceId: workspaceId,
        chatId: chatId,
        attachmentId: attachment.id,
      ),
    );

    final failure = result.fold<Failure?>((f) => f, (_) => null);
    if (failure != null) {
      emit(state.copyWith(
        clearDownloadingAttachment: true,
        clearAttachmentFeedback: true,
        attachmentFeedback: '__download_fail__',
      ));
      return;
    }

    final bytes = result.fold<Uint8List>((_) => Uint8List(0), (b) => b);
    final label = await _saveAttachmentFile(bytes, attachment.displayName);
    if (label == null) {
      emit(state.copyWith(
        clearDownloadingAttachment: true,
        clearAttachmentFeedback: true,
        attachmentFeedback: '__download_fail__',
      ));
      return;
    }

    emit(state.copyWith(
      clearDownloadingAttachment: true,
      clearAttachmentFeedback: true,
      attachmentFeedback: '__download_ok__',
      attachmentSavedLabel: label,
    ));
  }

  Future<String?> _saveAttachmentFile(Uint8List bytes, String rawName) async {
    try {
      var base = rawName.trim();
      if (base.isEmpty) {
        base = 'attachment';
      }
      base = p.basename(base);
      base = base.replaceAll(RegExp(r'[^\w.\- ]'), '_');
      if (base.isEmpty) base = 'attachment';
      final dir = await getTemporaryDirectory();
      final filePath = p.join(
        dir.path,
        '${DateTime.now().millisecondsSinceEpoch}_$base',
      );
      await File(filePath).writeAsBytes(bytes, flush: true);
      return p.basename(filePath);
    } catch (_) {
      return null;
    }
  }

  /// [silentRefresh]: no loading shimmer; failures keep the last successful list
  /// (used for push refreshes and HTTP polling when realtime is unavailable).
  Future<void> loadMessages({bool silentRefresh = false}) async {
    if (!silentRefresh) {
      emit(state.copyWith(status: ChatDetailStatus.loading, clearError: true));
    }

    final workspaceId = _workspaceIdStorage.get();
    if (workspaceId == null) {
      if (!silentRefresh) {
        emit(state.copyWith(
          status: ChatDetailStatus.failure,
          workspaceMissing: true,
        ));
      }
      return;
    }

    final result = await _getMessages(workspaceId, chatId);
    final failure = result.fold<Failure?>((f) => f, (_) => null);
    if (failure != null) {
      if (!silentRefresh) {
        emit(state.copyWith(
          status: ChatDetailStatus.failure,
          errorMessage: failure.message,
        ));
      }
      return;
    }

    final items = result.fold<List<ChatMessage>>(
      (_) => [],
      (list) => list,
    );

    final sorted = List<ChatMessage>.from(items)
      ..sort((a, b) {
        final da = DateTime.tryParse(a.createdAtIso ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0);
        final db = DateTime.tryParse(b.createdAtIso ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0);
        return da.compareTo(db);
      });

    final myId = _storage.getUser()?.id;
    final rows = sorted.map((m) {
      final isMine = m.senderId != null && myId != null && m.senderId == myId;
      final time = _formatTime(m.createdAtIso);
      return ChatBubbleRow(
        text: m.body,
        time: time,
        isSent: isMine,
        attachments: m.attachments,
      );
    }).toList();

    emit(state.copyWith(
      status: ChatDetailStatus.success,
      messages: rows,
    ));

    if (!silentRefresh) {
      unawaited(_ensureSoketiSubscription());
    }
  }

  void _startPollFallback() {
    if (_pollTimer != null) return;
    if (kDebugMode) {
      developer.log(
        'Using HTTP polling ($_pollInterval) for chat $chatId — '
        'fix /broadcasting/auth to return {"auth":"..."} for live updates',
        name: 'ChatDetailCubit',
      );
    }
    _pollTimer = Timer.periodic(_pollInterval, (_) {
      if (!isClosed) unawaited(loadMessages(silentRefresh: true));
    });
  }

  Future<void> _ensureSoketiSubscription() async {
    if (_soketiSubscribed) return;
    _soketiSubscribed = true;
    try {
      await _realtime.subscribePrivateChat(
        chatId: chatId,
        onNewActivity: () => loadMessages(silentRefresh: true),
      );
      _pollTimer?.cancel();
      _pollTimer = null;
    } catch (e, st) {
      _soketiSubscribed = false;
      if (kDebugMode) {
        developer.log(
          'Realtime (Soketi/Pusher) subscribe failed — check WebSocket host/port '
          'and Laravel /broadcasting/auth with auth:sanctum + JSON {"auth":"..."}',
          name: 'ChatDetailCubit',
          error: e,
          stackTrace: st,
        );
      }
      _startPollFallback();
    }
  }

  Future<void> sendMessage(String rawText) async {
    final text = rawText.trim();
    if (text.isEmpty) return;

    final workspaceId = _workspaceIdStorage.get();
    if (workspaceId == null) {
      emit(state.copyWith(sendError: '__workspace_missing__'));
      return;
    }

    emit(state.copyWith(isSending: true, clearSendError: true));

    final result = await _sendMessage(
      SendChatMessageParams(
        workspaceId: workspaceId,
        chatId: chatId,
        body: text,
      ),
    );

    final failure = result.fold<Failure?>((f) => f, (_) => null);
    if (failure != null) {
      emit(state.copyWith(isSending: false, sendError: failure.message));
      return;
    }

    emit(state.copyWith(isSending: false));
    await loadMessages();
  }

  String _formatTime(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso);
      return ConvertDateTime.convertDateTimeToTime(date: dt);
    } catch (_) {
      return '';
    }
  }

  @override
  Future<void> close() {
    _pollTimer?.cancel();
    unawaited(_realtime.unsubscribeChat(chatId));
    return super.close();
  }
}
