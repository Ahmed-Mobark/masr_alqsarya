import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/messages/domain/entities/chat_tone_insights.dart';
import 'package:masr_al_qsariya/features/messages/domain/repositories/messages_repository.dart';

class GetChatToneInsightsUseCase {
  const GetChatToneInsightsUseCase(this._repo);

  final MessagesRepository _repo;

  Future<Either<Failure, ChatToneInsights>> call(
    int workspaceId,
    int chatId,
  ) {
    return _repo.getChatToneInsights(workspaceId, chatId);
  }
}
