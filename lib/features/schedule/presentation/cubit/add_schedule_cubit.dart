import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:masr_al_qsariya/core/storage/workspace_id_storage.dart';
import 'package:masr_al_qsariya/features/schedule/domain/usecases/create_calendar_item_usecase.dart';
import 'package:masr_al_qsariya/features/schedule/domain/usecases/get_calendar_item_types_usecase.dart';
import 'package:masr_al_qsariya/features/schedule/presentation/cubit/add_schedule_state.dart';

class AddScheduleCubit extends Cubit<AddScheduleState> {
  AddScheduleCubit({
    required CreateCalendarItemUseCase createCalendarItem,
    required GetCalendarItemTypesUseCase getCalendarItemTypes,
    required WorkspaceIdStorage workspaceIdStorage,
  })  : _createCalendarItem = createCalendarItem,
        _getCalendarItemTypes = getCalendarItemTypes,
        _workspaceIdStorage = workspaceIdStorage,
        super(AddScheduleState.initial());

  final CreateCalendarItemUseCase _createCalendarItem;
  final GetCalendarItemTypesUseCase _getCalendarItemTypes;
  final WorkspaceIdStorage _workspaceIdStorage;

  Future<void> loadTypes() async {
    final workspaceId = _workspaceIdStorage.get();
    if (workspaceId == null) return;

    final result = await _getCalendarItemTypes(
      GetCalendarItemTypesParams(workspaceId: workspaceId),
    );
    result.fold(
      (_) {},
      (types) => emit(state.copyWith(eventTypes: types)),
    );
  }

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
    if (value == null || value.isEmpty) {
      emit(state.copyWith(clearSelectedEventType: true));
      return;
    }

    final matched = state.eventTypes.where((e) => e.value == value).toList();
    final categoryId = matched.isNotEmpty ? matched.first.categoryId : null;
    final next = state.copyWith(
      selectedEventType: value,
      selectedCategoryId: categoryId,
      clearNote: true,
    );
    if (value == 'audio_call') {
      emit(
        next.copyWith(
          selectedCallMode: 'audio',
          clearSelectedChild: true,
          clearSelectedCategoryId: true,
        ),
      );
      return;
    }
    if (value == 'video_call') {
      emit(
        next.copyWith(
          selectedCallMode: 'video',
          clearSelectedChild: true,
          clearSelectedCategoryId: true,
        ),
      );
      return;
    }

    emit(next);
  }

  void setChild(String? value) => emit(state.copyWith(selectedChild: value));

  void setDate(DateTime? value) => emit(state.copyWith(selectedDate: value));

  void setTime(TimeOfDay? value) => emit(state.copyWith(selectedTime: value));

  void setEndDate(DateTime? value) => emit(state.copyWith(selectedEndDate: value));

  void setEndTime(TimeOfDay? value) => emit(state.copyWith(selectedEndTime: value));

  void setNote(String? value) => emit(state.copyWith(note: value));

  void setCallMode(String? value) {
    final v = value;
    if (v == null || (v != 'audio' && v != 'video')) return;
    emit(state.copyWith(selectedCallMode: v));
  }

  DateTime? scheduledStartsAt() {
    final baseDate = state.selectedDate;
    if (baseDate == null) return null;
    final t = state.selectedTime;
    if (t == null) {
      return DateTime(baseDate.year, baseDate.month, baseDate.day);
    }
    return DateTime(baseDate.year, baseDate.month, baseDate.day, t.hour, t.minute);
  }

  DateTime? scheduledEndsAt() {
    final baseDate = state.selectedEndDate;
    if (baseDate == null) return null;
    final t = state.selectedEndTime;
    if (t == null) {
      return DateTime(baseDate.year, baseDate.month, baseDate.day);
    }
    return DateTime(baseDate.year, baseDate.month, baseDate.day, t.hour, t.minute);
  }

  Map<String, dynamic>? buildCallPayload() {
    if (!state.isCall) return null;
    final scheduled = scheduledStartsAt();
    if (scheduled == null) return null;
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
    if (state.selectedDate == null) {
      emit(state.copyWith(status: AddScheduleStatus.failure, error: 'missing_start_date'));
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

    final startsAt = DateFormat("M/d/yyyy'T'HH:mm:ss").format(
      scheduledStartsAt()!,
    );
    final endsDt = scheduledEndsAt();
    final endsAt = endsDt != null
        ? DateFormat("M/d/yyyy'T'HH:mm:ss").format(endsDt)
        : null;

    final result = await _createCalendarItem(
      CreateCalendarItemParams(
        workspaceId: workspaceId,
        type: state.selectedEventType!,
        startsAt: startsAt,
        endsAt: endsAt,
        note: state.note,
        categoryId: state.isSimpleEvent ? state.selectedCategoryId : null,
        childWorkspaceMemberId: null,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AddScheduleStatus.failure,
          error: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: AddScheduleStatus.success)),
    );
  }
}

