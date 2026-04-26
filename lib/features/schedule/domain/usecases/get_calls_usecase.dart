import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/schedule/domain/entities/call.dart';
import 'package:masr_al_qsariya/features/schedule/domain/repositories/calls_repository.dart';

class GetCallsParams extends Equatable {
  const GetCallsParams({
    required this.workspaceId,
    required this.startsFrom,
    required this.endsTo,
  });

  final int workspaceId;
  final DateTime startsFrom;
  final DateTime endsTo;

  @override
  List<Object?> get props => [workspaceId, startsFrom, endsTo];
}

class GetCallsUseCase {
  const GetCallsUseCase(this._repo);

  final CallsRepository _repo;

  Future<Either<Failure, List<CallEntity>>> call(GetCallsParams params) {
    return _repo.getCalls(
      workspaceId: params.workspaceId,
      startsFrom: params.startsFrom,
      endsTo: params.endsTo,
    );
  }
}

