import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/sessions/domain/entities/live_session_lobby.dart';
import 'package:masr_al_qsariya/features/sessions/domain/repositories/live_sessions_repository.dart';

class GetLiveSessionDetailUseCase {
  const GetLiveSessionDetailUseCase(this._repo);
  final LiveSessionsRepository _repo;

  Future<Either<Failure, LiveSessionLobby>> call(int liveSessionId) {
    return _repo.getLiveSessionDetail(liveSessionId: liveSessionId);
  }
}
