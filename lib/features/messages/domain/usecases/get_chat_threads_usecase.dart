import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/messages/domain/entities/chat_thread.dart';
import 'package:masr_al_qsariya/features/messages/domain/repositories/messages_repository.dart';

class GetChatThreadsUseCase {
  const GetChatThreadsUseCase(this._repo);

  final MessagesRepository _repo;

  Future<Either<Failure, List<ChatThread>>> call(int workspaceId) {
    return _repo.getChatThreads(workspaceId);
  }
}
