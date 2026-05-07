import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/storage/workspace_id_storage.dart';
import 'package:masr_al_qsariya/features/home/presentation/cubit/home_awaiting_call_action_state.dart';
import 'package:masr_al_qsariya/features/schedule/domain/usecases/call_confirm_usecase.dart';
import 'package:masr_al_qsariya/features/schedule/domain/usecases/call_reschedule_usecase.dart';

class HomeAwaitingCallActionCubit extends Cubit<HomeAwaitingCallActionState> {
  HomeAwaitingCallActionCubit(
    this._workspaceIdStorage,
    this._confirmUseCase,
    this._rescheduleUseCase,
  ) : super(const HomeAwaitingCallActionState());

  final WorkspaceIdStorage _workspaceIdStorage;
  final CallConfirmUseCase _confirmUseCase;
  final CallRescheduleUseCase _rescheduleUseCase;

  void reset() => emit(const HomeAwaitingCallActionState());

  String _errorMessageFromFailure(dynamic failure) {
    final errors = failure.errors;
    if (errors is Map && errors.isNotEmpty) {
      for (final entry in errors.entries) {
        final value = entry.value;
        if (value is List && value.isNotEmpty) {
          return value.map((e) => e.toString()).join('\n');
        }
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }
    }
    final msg = failure.message?.toString();
    return (msg == null || msg.trim().isEmpty) ? 'unknown_error' : msg;
  }

  Future<void> confirm(int callId) async {
    final workspaceId = _workspaceIdStorage.get();
    if (workspaceId == null) {
      emit(
        state.copyWith(
          status: HomeAwaitingCallActionStatus.failure,
          actionType: HomeAwaitingCallActionType.confirm,
          callId: callId,
          error: 'workspace_missing',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: HomeAwaitingCallActionStatus.loading,
        actionType: HomeAwaitingCallActionType.confirm,
        callId: callId,
        clearError: true,
      ),
    );

    final result = await _confirmUseCase(
      CallConfirmParams(workspaceId: workspaceId, callId: callId),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: HomeAwaitingCallActionStatus.failure,
          actionType: HomeAwaitingCallActionType.confirm,
          callId: callId,
          error: _errorMessageFromFailure(failure),
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: HomeAwaitingCallActionStatus.success,
          actionType: HomeAwaitingCallActionType.confirm,
          callId: callId,
        ),
      ),
    );
  }

  Future<void> reschedule({
    required int callId,
    required String scheduledStartsAt,
  }) async {
    final workspaceId = _workspaceIdStorage.get();
    if (workspaceId == null) {
      emit(
        state.copyWith(
          status: HomeAwaitingCallActionStatus.failure,
          actionType: HomeAwaitingCallActionType.reschedule,
          callId: callId,
          error: 'workspace_missing',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: HomeAwaitingCallActionStatus.loading,
        actionType: HomeAwaitingCallActionType.reschedule,
        callId: callId,
        clearError: true,
      ),
    );

    final result = await _rescheduleUseCase(
      CallRescheduleParams(
        workspaceId: workspaceId,
        callId: callId,
        scheduledStartsAt: scheduledStartsAt,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: HomeAwaitingCallActionStatus.failure,
          actionType: HomeAwaitingCallActionType.reschedule,
          callId: callId,
          error: _errorMessageFromFailure(failure),
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: HomeAwaitingCallActionStatus.success,
          actionType: HomeAwaitingCallActionType.reschedule,
          callId: callId,
        ),
      ),
    );
  }
}
