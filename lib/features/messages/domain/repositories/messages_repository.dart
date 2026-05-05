import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/messages/domain/entities/chat_audit_log_entry.dart';
import 'package:masr_al_qsariya/features/messages/domain/entities/chat_message.dart';
import 'package:masr_al_qsariya/features/messages/domain/entities/chat_thread.dart';
import 'package:masr_al_qsariya/features/messages/domain/entities/chat_tone_insights.dart';

abstract class MessagesRepository {
  Future<Either<Failure, List<ChatThread>>> getChatThreads(int workspaceId);

  Future<Either<Failure, List<ChatMessage>>> getChatMessages(
    int workspaceId,
    int chatId,
  );

  Future<Either<Failure, int?>> sendChatMessage(
    int workspaceId,
    int chatId,
    String? body,
    List<String> attachmentPaths,
  );

  Future<Either<Failure, void>> logChatModerationDecision({
    required int workspaceId,
    required int chatId,
    required int workspaceChatMessageId,
    required bool suggestionAccepted,
    required String originalMessage,
    String? aiSuggestion,
  });

  Future<Either<Failure, Uint8List>> downloadChatAttachment(
    int workspaceId,
    int chatId,
    int attachmentId,
  );

  Future<Either<Failure, ChatToneInsights>> getChatToneInsights(
    int workspaceId,
    int chatId,
  );

  Future<Either<Failure, List<ChatAuditLogEntry>>> getChatAuditLogs(
    int workspaceId,
    int chatId,
  );
}
