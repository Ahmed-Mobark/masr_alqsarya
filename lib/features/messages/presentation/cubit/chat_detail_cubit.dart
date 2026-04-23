import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/config/app_end_points.dart';
import 'package:masr_al_qsariya/core/methods/covert_datetime_to_string.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/core/network/reverb/reverb_service.dart';
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
    this._reverb,
    this.chatId,
  ) : super(const ChatDetailState());

  final GetChatMessagesUseCase _getMessages;
  final SendChatMessageUseCase _sendMessage;
  final DownloadChatAttachmentUseCase _downloadAttachment;
  final WorkspaceIdStorage _workspaceIdStorage;
  final Storage _storage;
  final ReverbService _reverb;
  final int chatId;

  bool _soketiSubscribed = false;
  int _optimisticId = -1;

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
        messageId: m.id,
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

  Future<void> _ensureSoketiSubscription() async {
    if (_soketiSubscribed) return;
    _soketiSubscribed = true;
    try {
      final workspaceId = _workspaceIdStorage.get();
      if (workspaceId == null) {
        _soketiSubscribed = false;
        return;
      }
      await _reverb.subscribePrivateChat(
        workspaceId: workspaceId,
        chatId: chatId,
        onEvent: _handleRealtimeEvent,
      );
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
      // No polling fallback: rely on realtime only (per product requirement).
    }
  }

  void _handleRealtimeEvent(String eventName, Map<String, dynamic> data) {
    if (eventName == 'message.sent') {
      final incoming = _parseMessageSent(data);
      if (incoming == null) return;

      final myUserId = _storage.getUser()?.id;
      if (myUserId != null && incoming.senderUserId == myUserId) {
        // We already show an optimistic bubble; avoid a duplicate refresh.
        return;
      }

      final already = state.messages.any((m) => m.messageId == incoming.id);
      if (already) return;

      final updated = List<ChatBubbleRow>.from(state.messages)
        ..add(
          ChatBubbleRow(
            messageId: incoming.id,
            text: incoming.body,
            time: _formatTime(incoming.createdAtIso),
            isSent: false,
            attachments: incoming.attachments,
          ),
        );
      emit(state.copyWith(messages: updated));
      return;
    }

    // For other events (e.g. messages.read), safest is a silent refresh.
    unawaited(loadMessages(silentRefresh: true));
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

    final optimistic = ChatBubbleRow(
      messageId: _optimisticId--,
      text: text,
      time: _formatTime(DateTime.now().toIso8601String()),
      isSent: true,
      attachments: const [],
    );
    emit(state.copyWith(
      messages: List<ChatBubbleRow>.from(state.messages)..add(optimistic),
    ));

    final result = await _sendMessage(
      SendChatMessageParams(
        workspaceId: workspaceId,
        chatId: chatId,
        body: text,
      ),
    );

    final failure = result.fold<Failure?>((f) => f, (_) => null);
    if (failure != null) {
      // Remove optimistic bubble on failure.
      final updated = List<ChatBubbleRow>.from(state.messages)
        ..removeWhere((m) => m.messageId == optimistic.messageId);
      emit(state.copyWith(
        isSending: false,
        sendError: failure.message,
        messages: updated,
      ));
      return;
    }

    emit(state.copyWith(isSending: false));
  }

  _IncomingMessage? _parseMessageSent(Map<String, dynamic> data) {
    final id = data['id'];
    final body = data['body'];
    final createdAt = data['created_at'];
    if (id is! int || body is! String) return null;
    final sender = data['sender'];
    int? senderUserId;
    if (sender is Map) {
      final su = sender['user_id'];
      if (su is int) senderUserId = su;
    }

    final attachmentsRaw = data['attachments'];
    final attachments = <ChatAttachment>[];
    if (attachmentsRaw is List) {
      for (final a in attachmentsRaw) {
        if (a is ChatAttachment) {
          attachments.add(a);
        }
      }
    }
    return _IncomingMessage(
      id: id,
      body: body,
      createdAtIso: createdAt is String ? createdAt : null,
      senderUserId: senderUserId,
      attachments: attachments,
    );
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
    final ws = _workspaceIdStorage.get();
    if (ws != null) {
      _reverb.unsubscribe(
        AppEndpoints.privateChatChannelName(workspaceId: ws, chatId: chatId),
      );
    }
    return super.close();
  }
}

class _IncomingMessage {
  const _IncomingMessage({
    required this.id,
    required this.body,
    required this.senderUserId,
    required this.attachments,
    required this.createdAtIso,
  });

  final int id;
  final String body;
  final int? senderUserId;
  final List<ChatAttachment> attachments;
  final String? createdAtIso;
}
