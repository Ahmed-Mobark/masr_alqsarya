import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/messages/domain/entities/chat_audit_log_entry.dart';
import 'package:masr_al_qsariya/features/messages/domain/repositories/messages_repository.dart';

class GetChatAuditLogsUseCase {
  const GetChatAuditLogsUseCase(this._repo);

  final MessagesRepository _repo;

  Future<Either<Failure, List<ChatAuditLogEntry>>> call(
    int workspaceId,
    int chatId,
  ) {
    return _repo.getChatAuditLogs(workspaceId, chatId);
  }
}
