import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/config/app_end_points.dart';
import 'package:masr_al_qsariya/core/methods/covert_datetime_to_string.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/core/network/reverb/reverb_service.dart';
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
    this._reverb,
    this.chatId,
  ) : super(const ChatDetailState());

  final GetChatMessagesUseCase _getMessages;
  final SendChatMessageUseCase _sendMessage;
  final DownloadChatAttachmentUseCase _downloadAttachment;
  final WorkspaceIdStorage _workspaceIdStorage;
  final Storage _storage;
  final RealtimeService _realtime;
  final ReverbService _reverb;
  final int chatId;

  bool _soketiSubscribed = false;
  bool _reverbSubscribed = false;

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
        id: m.id,
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

  void _applyRealtimeMessage(Map<String, dynamic> data) {
    // Try common shapes:
    // - { message: {...} }
    // - { data: { message: {...} } }
    // - { ...message fields... }
    Map<String, dynamic>? msg;
    final direct = data['message'];
    if (direct is Map) msg = Map<String, dynamic>.from(direct);
    final nestedData = data['data'];
    if (msg == null && nestedData is Map) {
      final nestedMsg = nestedData['message'];
      if (nestedMsg is Map) msg = Map<String, dynamic>.from(nestedMsg);
    }
    msg ??= data;

    final body = (msg['body'] ?? msg['message'] ?? '').toString().trim();
    if (body.isEmpty) return;

    final createdAtIso = (msg['created_at'] ??
            msg['createdAt'] ??
            msg['created_at_iso'] ??
            '')
        .toString();
    final time = _formatTime(createdAtIso);
    final myId = _storage.getUser()?.id;
    final senderMap = msg['sender'];
    final senderUserId = senderMap is Map ? senderMap['user_id'] : null;
    final senderIdRaw = senderUserId ??
        msg['sender_id'] ??
        msg['senderId'] ??
        msg['user_id'] ??
        msg['userId'];
    final senderId = senderIdRaw is num ? senderIdRaw.toInt() : int.tryParse('$senderIdRaw');
    final isMine = senderId != null && myId != null && senderId == myId;

    final idRaw = msg['id'];
    final id = idRaw is num ? idRaw.toInt() : int.tryParse('$idRaw') ?? -1;
    if (id != -1 && state.messages.any((m) => m.id == id)) return;

    final next = ChatBubbleRow(id: id, text: body, time: time, isSent: isMine);
    final current = state.messages;
    emit(state.copyWith(messages: [...current, next]));
  }

  Future<void> _ensureSoketiSubscription() async {
    if (_soketiSubscribed) return;
    _soketiSubscribed = true;
    try {
      // Prefer Reverb (native Laravel Reverb / Pusher protocol).
      if (!_reverbSubscribed) {
        final workspaceId = _workspaceIdStorage.get();
        if (workspaceId == null) {
          throw StateError('workspace_missing');
        }
        await _reverb.subscribePrivateChat(
          chatId: chatId,
          workspaceId: workspaceId,
          onEvent: (eventName, data) {
            // Prefer applying realtime payloads instead of polling/HTTP refresh.
            if (isClosed) return;
            // Backend spec: message events are `message.sent`.
            if (eventName == 'message.sent') {
              _applyRealtimeMessage(data);
              return;
            }
            // For other events (e.g. read receipts), fall back to a silent refresh.
            unawaited(loadMessages(silentRefresh: true));
          },
        );
        _reverbSubscribed = true;
        return;
      }

      // Fallback to Soketi (legacy) if needed.
      final ws = _workspaceIdStorage.get();
      await _realtime.subscribePrivateChat(
        workspaceId: ws ?? 0,
        chatId: chatId,
        onNewActivity: () => loadMessages(silentRefresh: true),
      );
    } catch (e, st) {
      _soketiSubscribed = false;
      _reverbSubscribed = false;
      if (kDebugMode) {
        developer.log(
          'Realtime (Soketi/Pusher) subscribe failed — check WebSocket host/port '
          'and Laravel /broadcasting/auth with auth:sanctum + JSON {"auth":"..."}',
          name: 'ChatDetailCubit',
          error: e,
          stackTrace: st,
        );
      }
      // No polling fallback: rely on realtime only (per product requirement).
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
    unawaited(_realtime.unsubscribeChat(chatId));
    final ws = _workspaceIdStorage.get();
    if (ws != null) {
      _reverb.unsubscribe(
        AppEndpoints.privateChatChannelName(workspaceId: ws, chatId: chatId),
      );
    }
    return super.close();
  }
}
