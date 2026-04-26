import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/schedule/domain/repositories/calls_repository.dart';

class CallRecordingStartParams extends Equatable {
  const CallRecordingStartParams({
    required this.workspaceId,
    required this.callId,
  });

  final int workspaceId;
  final int callId;

  @override
  List<Object?> get props => [workspaceId, callId];
}

class CallRecordingStartUseCase {
  const CallRecordingStartUseCase(this._repo);

  final CallsRepository _repo;

  Future<Either<Failure, void>> call(CallRecordingStartParams params) {
    return _repo.startCallRecording(
      workspaceId: params.workspaceId,
      callId: params.callId,
    );
  }
}

