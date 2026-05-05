import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/messages/domain/repositories/messages_repository.dart';

class SendChatMessageParams {
  const SendChatMessageParams({
    required this.workspaceId,
    required this.chatId,
    this.body,
    this.attachmentPaths = const [],
  });

  final int workspaceId;
  final int chatId;
  final String? body;
  final List<String> attachmentPaths;
}

class SendChatMessageUseCase {
  const SendChatMessageUseCase(this._repo);

  final MessagesRepository _repo;

  Future<Either<Failure, int?>> call(SendChatMessageParams params) {
    return _repo.sendChatMessage(
      params.workspaceId,
      params.chatId,
      params.body,
      params.attachmentPaths,
    );
  }
}
