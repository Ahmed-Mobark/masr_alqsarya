import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:masr_al_qsariya/core/storage/workspace_id_storage.dart';
import 'package:masr_al_qsariya/features/schedule/domain/usecases/create_call_usecase.dart';
import 'package:masr_al_qsariya/features/schedule/presentation/cubit/add_schedule_state.dart';

class AddScheduleCubit extends Cubit<AddScheduleState> {
  AddScheduleCubit({
    required CreateCallUseCase createCall,
    required WorkspaceIdStorage workspaceIdStorage,
  })  : _createCall = createCall,
        _workspaceIdStorage = workspaceIdStorage,
        super(AddScheduleState.initial());

  final CreateCallUseCase _createCall;
  final WorkspaceIdStorage _workspaceIdStorage;

  void changeMonth(int delta) {
    emit(
      state.copyWith(
        focusedMonth: DateTime(state.focusedMonth.year, state.focusedMonth.month + delta),
      ),
    );
  }

  void selectDay(DateTime day) {
    emit(
      state.copyWith(
        selectedDay: day,
        selectedDate: day,
      ),
    );
  }

  void setEventType(String? value) {
    final next = state.copyWith(selectedEventType: value);

    if (value == 'Call') {
      emit(
        next.copyWith(
          clearSelectedChild: true,
          clearSelectedTime: true,
        ),
      );
      return;
    }

    emit(next);
  }

  void setChild(String? value) => emit(state.copyWith(selectedChild: value));

  void setDate(DateTime? value) => emit(state.copyWith(selectedDate: value));

  void setTime(TimeOfDay? value) => emit(state.copyWith(selectedTime: value));

  void setCallMode(String? value) {
    final v = value;
    if (v == null || (v != 'audio' && v != 'video')) return;
    emit(state.copyWith(selectedCallMode: v));
  }

  DateTime scheduledStartsAt() {
    final baseDate = state.selectedDate ?? state.selectedDay;
    final t = state.selectedTime;
    if (t == null) {
      return DateTime(baseDate.year, baseDate.month, baseDate.day);
    }
    return DateTime(baseDate.year, baseDate.month, baseDate.day, t.hour, t.minute);
  }

  Map<String, dynamic>? buildCallPayload() {
    if (!state.isCall) return null;
    final scheduled = scheduledStartsAt();
    return <String, dynamic>{
      'mode': state.selectedCallMode,
      'scheduled_starts_at':
          DateFormat("M/d/yyyy'T'HH:mm:ss").format(scheduled),
    };
  }

  Future<void> submit() async {
    if (state.status == AddScheduleStatus.submitting) return;

    if (state.selectedEventType == null) {
      emit(state.copyWith(status: AddScheduleStatus.failure, error: 'missing_type'));
      return;
    }

    if (!state.isCall) {
      return;
    }

    final workspaceId = _workspaceIdStorage.get();
    if (workspaceId == null) {
      emit(
        state.copyWith(
          status: AddScheduleStatus.failure,
          error: 'workspace_missing',
        ),
      );
      return;
    }

    emit(state.copyWith(
      status: AddScheduleStatus.submitting,
      clearError: true,
      clearCreatedCall: true,
    ));

    final scheduled = DateFormat("M/d/yyyy'T'HH:mm:ss").format(
      scheduledStartsAt(),
    );
    final result = await _createCall(
      CreateCallParams(
        workspaceId: workspaceId,
        mode: state.selectedCallMode,
        scheduledStartsAt: scheduled,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AddScheduleStatus.failure,
          error: failure.message,
        ),
      ),
      (call) => emit(
        state.copyWith(
          status: AddScheduleStatus.success,
          createdCall: call,
        ),
      ),
    );
  }
}

