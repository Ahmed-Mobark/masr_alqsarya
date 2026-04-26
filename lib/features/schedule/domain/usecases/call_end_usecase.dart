import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/schedule/domain/repositories/calls_repository.dart';

class CallEndParams extends Equatable {
  const CallEndParams({
    required this.workspaceId,
    required this.callId,
  });

  final int workspaceId;
  final int callId;

  @override
  List<Object?> get props => [workspaceId, callId];
}

class CallEndUseCase {
  const CallEndUseCase(this._repo);

  final CallsRepository _repo;

  Future<Either<Failure, void>> call(CallEndParams params) {
    return _repo.endCall(
      workspaceId: params.workspaceId,
      callId: params.callId,
    );
  }
}

