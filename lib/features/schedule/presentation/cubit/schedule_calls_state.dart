import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/features/schedule/domain/entities/call.dart';

enum ScheduleCallsStatus { initial, loading, success, failure }

class ScheduleCallsState extends Equatable {
  const ScheduleCallsState({
    this.status = ScheduleCallsStatus.initial,
    this.calls = const [],
    this.error,
  });

  final ScheduleCallsStatus status;
  final List<CallEntity> calls;
  final String? error;

  ScheduleCallsState copyWith({
    ScheduleCallsStatus? status,
    List<CallEntity>? calls,
    String? error,
    bool clearError = false,
  }) {
    return ScheduleCallsState(
      status: status ?? this.status,
      calls: calls ?? this.calls,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [status, calls, error];
}

