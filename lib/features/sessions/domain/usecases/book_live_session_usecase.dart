import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/sessions/domain/repositories/live_sessions_repository.dart';

class BookLiveSessionUseCase {
  const BookLiveSessionUseCase(this._repo);
  final LiveSessionsRepository _repo;

  Future<Either<Failure, Unit>> call(BookLiveSessionParams params) {
    return _repo.bookLiveSession(
      workspaceId: params.workspaceId,
      liveSessionId: params.liveSessionId,
    );
  }
}

class BookLiveSessionParams extends Equatable {
  const BookLiveSessionParams({
    required this.workspaceId,
    required this.liveSessionId,
  });

  final int workspaceId;
  final int liveSessionId;

  @override
  List<Object?> get props => [workspaceId, liveSessionId];
}
