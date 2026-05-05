import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:masr_al_qsariya/features/schedule/domain/entities/call.dart';
import 'package:masr_al_qsariya/features/schedule/domain/entities/calendar_item_type.dart';

enum AddScheduleStatus { initial, submitting, success, failure }

class AddScheduleState extends Equatable {
  const AddScheduleState({
    required this.focusedMonth,
    required this.selectedDay,
    this.selectedEventType,
    this.eventTypes = const [],
    this.selectedChild,
    this.selectedDate,
    this.selectedTime,
    this.selectedEndTime,
    this.note,
    this.selectedCategoryId,
    this.selectedCallMode = 'video',
    this.status = AddScheduleStatus.initial,
    this.error,
    this.createdCall,
  });

  factory AddScheduleState.initial() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return AddScheduleState(
      focusedMonth: DateTime(today.year, today.month, 1),
      selectedDay: today,
      selectedDate: today,
      selectedEventType: null,
    );
  }

  final DateTime focusedMonth;
  final DateTime selectedDay;
  final String? selectedEventType;
  final List<CalendarItemTypeEntity> eventTypes;
  final String? selectedChild;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final TimeOfDay? selectedEndTime;
  final String? note;
  final int? selectedCategoryId;
  final String selectedCallMode; // audio | video
  final AddScheduleStatus status;
  final String? error;
  final CallEntity? createdCall;

  bool get isCall => selectedEventType == 'audio_call' || selectedEventType == 'video_call';
  bool get isSimpleEvent => selectedEventType == 'simple_event';

  /// Both times set on the same day and end is not strictly after start.
  bool get hasInvalidEndBeforeStart {
    final s = selectedTime;
    final e = selectedEndTime;
    if (s == null || e == null) return false;
    final sm = s.hour * 60 + s.minute;
    final em = e.hour * 60 + e.minute;
    return em <= sm;
  }

  AddScheduleState copyWith({
    DateTime? focusedMonth,
    DateTime? selectedDay,
    String? selectedEventType,
    bool clearSelectedEventType = false,
    List<CalendarItemTypeEntity>? eventTypes,
    String? selectedChild,
    bool clearSelectedChild = false,
    DateTime? selectedDate,
    bool clearSelectedDate = false,
    TimeOfDay? selectedTime,
    bool clearSelectedTime = false,
    TimeOfDay? selectedEndTime,
    bool clearSelectedEndTime = false,
    String? note,
    bool clearNote = false,
    int? selectedCategoryId,
    bool clearSelectedCategoryId = false,
    String? selectedCallMode,
    AddScheduleStatus? status,
    String? error,
    bool clearError = false,
    CallEntity? createdCall,
    bool clearCreatedCall = false,
  }) {
    return AddScheduleState(
      focusedMonth: focusedMonth ?? this.focusedMonth,
      selectedDay: selectedDay ?? this.selectedDay,
      selectedEventType:
          clearSelectedEventType ? null : (selectedEventType ?? this.selectedEventType),
      eventTypes: eventTypes ?? this.eventTypes,
      selectedChild:
          clearSelectedChild ? null : (selectedChild ?? this.selectedChild),
      selectedDate: clearSelectedDate ? null : (selectedDate ?? this.selectedDate),
      selectedTime: clearSelectedTime ? null : (selectedTime ?? this.selectedTime),
      selectedEndTime:
          clearSelectedEndTime ? null : (selectedEndTime ?? this.selectedEndTime),
      note: clearNote ? null : (note ?? this.note),
      selectedCategoryId: clearSelectedCategoryId
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
      selectedCallMode: selectedCallMode ?? this.selectedCallMode,
      status: status ?? this.status,
      error: clearError ? null : (error ?? this.error),
      createdCall: clearCreatedCall ? null : (createdCall ?? this.createdCall),
    );
  }

  @override
  List<Object?> get props => [
        focusedMonth,
        selectedDay,
        selectedEventType,
        eventTypes,
        selectedChild,
        selectedDate,
        selectedTime,
        selectedEndTime,
        note,
        selectedCategoryId,
        selectedCallMode,
        status,
        error,
        createdCall,
      ];
}

