import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/schedule/domain/entities/call.dart';
import 'package:masr_al_qsariya/features/schedule/domain/entities/call_join.dart';
import 'package:masr_al_qsariya/features/schedule/domain/entities/calendar_item_type.dart';

abstract class CallsRepository {
  Future<Either<Failure, CallEntity>> createCall({
    required int workspaceId,
    required String mode,
    required String scheduledStartsAt,
  });

  Future<Either<Failure, List<CallEntity>>> getCalls({
    required int workspaceId,
    required DateTime startsFrom,
    required DateTime endsTo,
  });

  Future<Either<Failure, CallJoinEntity>> joinCall({
    required int workspaceId,
    required int callId,
  });

  Future<Either<Failure, List<CalendarItemTypeEntity>>> getCalendarItemTypes({
    required int workspaceId,
  });

  Future<Either<Failure, void>> createCalendarItem({
    required int workspaceId,
    required String type,
    required String startsAt,
    String? endsAt,
    String? note,
    int? categoryId,
    int? childWorkspaceMemberId,
  });

  Future<Either<Failure, void>> startCallRecording({
    required int workspaceId,
    required int callId,
  });

  Future<Either<Failure, void>> endCall({
    required int workspaceId,
    required int callId,
  });

  Future<Either<Failure, void>> cancelCall({
    required int workspaceId,
    required int callId,
  });

  Future<Either<Failure, void>> callRecordingConsent({
    required int workspaceId,
    required int callId,
    required bool approved,
  });
}

