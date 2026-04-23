import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:masr_al_qsariya/features/schedule/domain/entities/call.dart';

enum AddScheduleStatus { initial, submitting, success, failure }

class AddScheduleState extends Equatable {
  const AddScheduleState({
    required this.focusedMonth,
    required this.selectedDay,
    this.selectedEventType,
    this.selectedChild,
    this.selectedDate,
    this.selectedTime,
    this.selectedCallMode = 'video',
    this.status = AddScheduleStatus.initial,
    this.error,
    this.createdCall,
  });

  factory AddScheduleState.initial() => AddScheduleState(
        focusedMonth: DateTime.now(),
        selectedDay: DateTime.now(),
        selectedEventType: 'Call',
      );

  final DateTime focusedMonth;
  final DateTime selectedDay;
  final String? selectedEventType;
  final String? selectedChild;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final String selectedCallMode; // audio | video
  final AddScheduleStatus status;
  final String? error;
  final CallEntity? createdCall;

  bool get isCall => selectedEventType == 'Call';

  AddScheduleState copyWith({
    DateTime? focusedMonth,
    DateTime? selectedDay,
    String? selectedEventType,
    bool clearSelectedEventType = false,
    String? selectedChild,
    bool clearSelectedChild = false,
    DateTime? selectedDate,
    bool clearSelectedDate = false,
    TimeOfDay? selectedTime,
    bool clearSelectedTime = false,
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
      selectedChild:
          clearSelectedChild ? null : (selectedChild ?? this.selectedChild),
      selectedDate: clearSelectedDate ? null : (selectedDate ?? this.selectedDate),
      selectedTime: clearSelectedTime ? null : (selectedTime ?? this.selectedTime),
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
        selectedChild,
        selectedDate,
        selectedTime,
        selectedCallMode,
        status,
        error,
        createdCall,
      ];
}

