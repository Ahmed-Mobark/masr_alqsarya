import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/schedule/domain/entities/call_join.dart';
import 'package:masr_al_qsariya/features/schedule/domain/repositories/calls_repository.dart';

class JoinCallParams extends Equatable {
  const JoinCallParams({
    required this.workspaceId,
    required this.callId,
  });

  final int workspaceId;
  final int callId;

  @override
  List<Object?> get props => [workspaceId, callId];
}

class JoinCallUseCase {
  const JoinCallUseCase(this._repo);

  final CallsRepository _repo;

  Future<Either<Failure, CallJoinEntity>> call(JoinCallParams params) {
    return _repo.joinCall(
      workspaceId: params.workspaceId,
      callId: params.callId,
    );
  }
}

