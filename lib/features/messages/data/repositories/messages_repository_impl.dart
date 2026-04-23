import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/core/network/network_service/repository_helper.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';
import 'package:masr_al_qsariya/features/messages/data/datasources/messages_remote_data_source.dart';
import 'package:masr_al_qsariya/features/messages/data/models/chat_thread_model.dart';
import 'package:masr_al_qsariya/features/messages/domain/entities/chat_message.dart';
import 'package:masr_al_qsariya/features/messages/domain/entities/chat_thread.dart';
import 'package:masr_al_qsariya/features/messages/domain/repositories/messages_repository.dart';

class MessagesRepositoryImpl with RepositoryHelper implements MessagesRepository {
  const MessagesRepositoryImpl(this._remote, this._storage);

  final MessagesRemoteDataSource _remote;
  final Storage _storage;

  @override
  Future<Either<Failure, List<ChatThread>>> getChatThreads(int workspaceId) {
    return handleEither(() async {
      final rows = await _remote.fetchChatThreads(workspaceId);
      final viewerId = _storage.getUser()?.id;
      return rows
          .map(
            (m) => ChatThreadModel.fromMap(
              m,
              viewerUserId: viewerId,
            ).toEntity(),
          )
          .toList();
    });
  }

  @override
  Future<Either<Failure, List<ChatMessage>>> getChatMessages(
    int workspaceId,
    int chatId,
  ) {
    return handleEither(() async {
      final models = await _remote.fetchChatMessages(workspaceId, chatId);
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, void>> sendChatMessage(
    int workspaceId,
    int chatId,
    String? body,
    List<String> attachmentPaths,
  ) {
    return handleEither(() async {
      await _remote.sendChatMessage(
        workspaceId,
        chatId,
        body,
        attachmentPaths,
      );
    });
  }

  @override
  Future<Either<Failure, Uint8List>> downloadChatAttachment(
    int workspaceId,
    int chatId,
    int attachmentId,
  ) {
    return handleEither(() async {
      return _remote.downloadChatAttachment(
        workspaceId,
        chatId,
        attachmentId,
      );
    });
  }
}
