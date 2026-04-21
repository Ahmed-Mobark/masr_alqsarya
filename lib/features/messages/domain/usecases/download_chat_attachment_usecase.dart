import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/messages/domain/repositories/messages_repository.dart';

class DownloadChatAttachmentParams {
  const DownloadChatAttachmentParams({
    required this.workspaceId,
    required this.chatId,
    required this.attachmentId,
  });

  final int workspaceId;
  final int chatId;
  final int attachmentId;
}

class DownloadChatAttachmentUseCase {
  const DownloadChatAttachmentUseCase(this._repo);

  final MessagesRepository _repo;

  Future<Either<Failure, Uint8List>> call(DownloadChatAttachmentParams params) {
    return _repo.downloadChatAttachment(
      params.workspaceId,
      params.chatId,
      params.attachmentId,
    );
  }
}
