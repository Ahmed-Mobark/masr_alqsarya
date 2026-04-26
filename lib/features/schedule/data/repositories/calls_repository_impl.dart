import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/core/network/network_service/repository_helper.dart';
import 'package:masr_al_qsariya/features/schedule/data/datasources/calls_remote_data_source.dart';
import 'package:masr_al_qsariya/features/schedule/domain/repositories/calls_repository.dart';
import 'package:masr_al_qsariya/features/schedule/domain/entities/call.dart';
import 'package:masr_al_qsariya/features/schedule/domain/entities/call_join.dart';
import 'package:masr_al_qsariya/features/schedule/domain/entities/calendar_item_type.dart';

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
  Future<Either<Failure, List<CallEntity>>> getCalls({
    required int workspaceId,
    required DateTime startsFrom,
    required DateTime endsTo,
  }) {
    return handleEither(() async {
      final models = await _remote.getCalls(
        workspaceId: workspaceId,
        startsFrom: startsFrom,
        endsTo: endsTo,
      );
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

  @override
  Future<Either<Failure, List<CalendarItemTypeEntity>>> getCalendarItemTypes({
    required int workspaceId,
  }) {
    return handleEither(() async {
      final models = await _remote.getCalendarItemTypes(workspaceId: workspaceId);
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, void>> createCalendarItem({
    required int workspaceId,
    required String type,
    required String startsAt,
    String? endsAt,
    String? note,
    int? categoryId,
    int? childWorkspaceMemberId,
  }) {
    return handleEither(() async {
      await _remote.createCalendarItem(
        workspaceId: workspaceId,
        type: type,
        startsAt: startsAt,
        endsAt: endsAt,
        note: note,
        categoryId: categoryId,
        childWorkspaceMemberId: childWorkspaceMemberId,
      );
      return;
    });
  }

  @override
  Future<Either<Failure, void>> startCallRecording({
    required int workspaceId,
    required int callId,
  }) {
    return handleEither(() async {
      await _remote.startCallRecording(workspaceId: workspaceId, callId: callId);
      return;
    });
  }

  @override
  Future<Either<Failure, void>> endCall({
    required int workspaceId,
    required int callId,
  }) {
    return handleEither(() async {
      await _remote.endCall(workspaceId: workspaceId, callId: callId);
      return;
    });
  }

  @override
  Future<Either<Failure, void>> cancelCall({
    required int workspaceId,
    required int callId,
  }) {
    return handleEither(() async {
      await _remote.cancelCall(workspaceId: workspaceId, callId: callId);
      return;
    });
  }

  @override
  Future<Either<Failure, void>> callRecordingConsent({
    required int workspaceId,
    required int callId,
    required bool approved,
  }) {
    return handleEither(() async {
      await _remote.callRecordingConsent(
        workspaceId: workspaceId,
        callId: callId,
        approved: approved,
      );
      return;
    });
  }
}
