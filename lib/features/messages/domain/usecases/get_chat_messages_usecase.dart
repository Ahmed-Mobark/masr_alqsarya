import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/messages/domain/entities/chat_message.dart';
import 'package:masr_al_qsariya/features/messages/domain/repositories/messages_repository.dart';

class GetChatMessagesUseCase {
  const GetChatMessagesUseCase(this._repo);

  final MessagesRepository _repo;

  Future<Either<Failure, List<ChatMessage>>> call(
    int workspaceId,
    int chatId,
  ) {
    return _repo.getChatMessages(workspaceId, chatId);
  }
}
