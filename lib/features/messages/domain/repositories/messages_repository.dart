import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/messages/domain/entities/chat_message.dart';
import 'package:masr_al_qsariya/features/messages/domain/entities/chat_thread.dart';

abstract class MessagesRepository {
  Future<Either<Failure, List<ChatThread>>> getChatThreads(int workspaceId);

  Future<Either<Failure, List<ChatMessage>>> getChatMessages(
    int workspaceId,
    int chatId,
  );

  Future<Either<Failure, void>> sendChatMessage(
    int workspaceId,
    int chatId,
    String? body,
    List<String> attachmentPaths,
  );

  Future<Either<Failure, Uint8List>> downloadChatAttachment(
    int workspaceId,
    int chatId,
    int attachmentId,
  );
}
