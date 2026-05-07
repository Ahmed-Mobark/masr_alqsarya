import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/schedule/domain/repositories/calls_repository.dart';

class CallRescheduleParams extends Equatable {
  const CallRescheduleParams({
    required this.workspaceId,
    required this.callId,
    required this.scheduledStartsAt,
  });

  final int workspaceId;
  final int callId;
  final String scheduledStartsAt;

  @override
  List<Object?> get props => [workspaceId, callId, scheduledStartsAt];
}

class CallRescheduleUseCase {
  const CallRescheduleUseCase(this._repo);

  final CallsRepository _repo;

  Future<Either<Failure, void>> call(CallRescheduleParams params) {
    return _repo.rescheduleCall(
      workspaceId: params.workspaceId,
      callId: params.callId,
      scheduledStartsAt: params.scheduledStartsAt,
    );
  }
}
