import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/storage/workspace_id_storage.dart';
import 'package:masr_al_qsariya/features/schedule/domain/usecases/create_calendar_item_usecase.dart';
import 'package:masr_al_qsariya/features/schedule/domain/usecases/get_calendar_item_types_usecase.dart';
import 'package:masr_al_qsariya/features/schedule/presentation/cubit/add_schedule_state.dart';

class AddScheduleCubit extends Cubit<AddScheduleState> {
  AddScheduleCubit({
    required CreateCalendarItemUseCase createCalendarItem,
    required GetCalendarItemTypesUseCase getCalendarItemTypes,
    required WorkspaceIdStorage workspaceIdStorage,
  }) : _createCalendarItem = createCalendarItem,
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
    result.fold((_) {}, (types) => emit(state.copyWith(eventTypes: types)));
  }

  static DateTime _todayCalendar() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Wall-clock on the device → UTC instant for APIs that store `...Z`.
  ///
  /// Avoids sending `M/d/yyyy'T'HH:mm:ss` without offset; servers often treat
  /// that as UTC so 9:00 local becomes `09:00Z` and displays as noon in +3.
  static String _calendarInstantUtcIso(DateTime localWallClock) =>
      localWallClock.toUtc().toIso8601String();

  void changeMonth(int delta) {
    final today = _todayCalendar();
    var next = DateTime(
      state.focusedMonth.year,
      state.focusedMonth.month + delta,
      1,
    );
    final minMonthStart = DateTime(today.year, today.month, 1);
    if (next.isBefore(minMonthStart)) {
      next = minMonthStart;
      if (next.year == state.focusedMonth.year &&
          next.month == state.focusedMonth.month) {
        return;
      }
    }
    emit(state.copyWith(focusedMonth: next));
  }

  void selectDay(DateTime day) {
    final dayOnly = _dateOnly(day);
    if (dayOnly.isBefore(_todayCalendar())) return;
    emit(state.copyWith(selectedDay: dayOnly, selectedDate: dayOnly));
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

  void setDate(DateTime? value) {
    if (value == null) return;
    final dayOnly = _dateOnly(value);
    if (dayOnly.isBefore(_todayCalendar())) return;
    emit(state.copyWith(selectedDate: dayOnly, selectedDay: dayOnly));
  }

  static int _timeMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

  static bool _endStrictlyAfterStart(TimeOfDay start, TimeOfDay end) =>
      _timeMinutes(end) > _timeMinutes(start);

  void setTime(TimeOfDay? value) {
    if (value == null) {
      emit(state.copyWith(clearSelectedTime: true));
      return;
    }
    final end = state.selectedEndTime;
    if (end != null && !_endStrictlyAfterStart(value, end)) {
      emit(state.copyWith(selectedTime: value, clearSelectedEndTime: true));
      return;
    }
    emit(state.copyWith(selectedTime: value));
  }

  /// Returns `false` if end is not strictly after the current start time.
  bool setEndTime(TimeOfDay? value) {
    if (value == null) {
      emit(state.copyWith(clearSelectedEndTime: true));
      return true;
    }
    final start = state.selectedTime;
    if (start != null && !_endStrictlyAfterStart(start, value)) {
      return false;
    }
    emit(state.copyWith(selectedEndTime: value));
    return true;
  }

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
    return DateTime(
      baseDate.year,
      baseDate.month,
      baseDate.day,
      t.hour,
      t.minute,
    );
  }

  /// Same calendar day as [scheduledStartsAt]; only the end **time** differs.
  DateTime? scheduledEndsAt() {
    final baseDate = state.selectedDate;
    if (baseDate == null) return null;
    final t = state.selectedEndTime;
    if (t == null) return null;
    return DateTime(
      baseDate.year,
      baseDate.month,
      baseDate.day,
      t.hour,
      t.minute,
    );
  }

  Map<String, dynamic>? buildCallPayload() {
    if (!state.isCall) return null;
    final scheduled = scheduledStartsAt();
    if (scheduled == null) return null;
    return <String, dynamic>{
      'mode': state.selectedCallMode,
      'scheduled_starts_at': _calendarInstantUtcIso(scheduled),
    };
  }

  Future<void> submit() async {
    if (state.status == AddScheduleStatus.submitting) return;

    if (state.selectedEventType == null) {
      emit(
        state.copyWith(
          status: AddScheduleStatus.failure,
          error: 'missing_type',
        ),
      );
      return;
    }
    if (state.selectedDate == null) {
      emit(
        state.copyWith(
          status: AddScheduleStatus.failure,
          error: 'missing_start_date',
        ),
      );
      return;
    }

    final startDt = scheduledStartsAt()!;
    final endDt = scheduledEndsAt();
    if (endDt != null && !endDt.isAfter(startDt)) {
      emit(
        state.copyWith(
          status: AddScheduleStatus.failure,
          error: 'end_time_not_after_start',
        ),
      );
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

    emit(
      state.copyWith(
        status: AddScheduleStatus.submitting,
        clearError: true,
        clearCreatedCall: true,
      ),
    );

    final startsAt = _calendarInstantUtcIso(startDt);
    final endsAt = endDt != null ? _calendarInstantUtcIso(endDt) : null;

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
