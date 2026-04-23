import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/core/network/network_service/repository_helper.dart';
import 'package:masr_al_qsariya/features/schedule/data/datasources/calls_remote_data_source.dart';
import 'package:masr_al_qsariya/features/schedule/domain/repositories/calls_repository.dart';
import 'package:masr_al_qsariya/features/schedule/domain/entities/call.dart';
import 'package:masr_al_qsariya/features/schedule/domain/entities/call_join.dart';

class CallsRepositoryImpl with RepositoryHelper implements CallsRepository {
  const CallsRepositoryImpl(this._remote);

  final CallsRemoteDataSource _remote;

  @override
  Future<Either<Failure, CallEntity>> createCall({
    required int workspaceId,
    required String mode,
    required String scheduledStartsAt,
  }) {
    return handleEither(() async {
      final model = await _remote.createCall(
        workspaceId: workspaceId,
        mode: mode,
        scheduledStartsAt: scheduledStartsAt,
      );
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, List<CallEntity>>> getCalls({required int workspaceId}) {
    return handleEither(() async {
      final models = await _remote.getCalls(workspaceId: workspaceId);
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, CallJoinEntity>> joinCall({
    required int workspaceId,
    required int callId,
  }) {
    return handleEither(() async {
      final model = await _remote.joinCall(workspaceId: workspaceId, callId: callId);
      return model.toEntity();
    });
  }
}
