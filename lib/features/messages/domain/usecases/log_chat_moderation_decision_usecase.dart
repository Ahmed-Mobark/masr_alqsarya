import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/messages/domain/repositories/messages_repository.dart';

class LogChatModerationDecisionParams {
  const LogChatModerationDecisionParams({
    required this.workspaceId,
    required this.chatId,
    required this.workspaceChatMessageId,
    required this.suggestionAccepted,
    required this.originalMessage,
    this.aiSuggestion,
  });

  final int workspaceId;
  final int chatId;
  final int workspaceChatMessageId;
  final bool suggestionAccepted;
  final String originalMessage;
  final String? aiSuggestion;
}

class LogChatModerationDecisionUseCase {
  const LogChatModerationDecisionUseCase(this._repo);

  final MessagesRepository _repo;

  Future<Either<Failure, void>> call(
    LogChatModerationDecisionParams params,
  ) {
    return _repo.logChatModerationDecision(
      workspaceId: params.workspaceId,
      chatId: params.chatId,
      workspaceChatMessageId: params.workspaceChatMessageId,
      suggestionAccepted: params.suggestionAccepted,
      originalMessage: params.originalMessage,
      aiSuggestion: params.aiSuggestion,
    );
  }
}
