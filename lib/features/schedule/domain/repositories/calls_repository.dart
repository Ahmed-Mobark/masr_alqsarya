import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/schedule/domain/entities/call.dart';
import 'package:masr_al_qsariya/features/schedule/domain/entities/call_join.dart';

abstract class CallsRepository {
  Future<Either<Failure, CallEntity>> createCall({
    required int workspaceId,
    required String mode,
    required String scheduledStartsAt,
  });

  Future<Either<Failure, List<CallEntity>>> getCalls({
    required int workspaceId,
  });

  Future<Either<Failure, CallJoinEntity>> joinCall({
    required int workspaceId,
    required int callId,
  });
}

