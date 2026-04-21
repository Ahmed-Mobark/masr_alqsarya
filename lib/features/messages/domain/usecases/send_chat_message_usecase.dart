import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/messages/domain/repositories/messages_repository.dart';

class SendChatMessageParams {
  const SendChatMessageParams({
    required this.workspaceId,
    required this.chatId,
    required this.body,
  });

  final int workspaceId;
  final int chatId;
  final String body;
}

class SendChatMessageUseCase {
  const SendChatMessageUseCase(this._repo);

  final MessagesRepository _repo;

  Future<Either<Failure, void>> call(SendChatMessageParams params) {
    return _repo.sendChatMessage(
      params.workspaceId,
      params.chatId,
      params.body,
    );
  }
}
