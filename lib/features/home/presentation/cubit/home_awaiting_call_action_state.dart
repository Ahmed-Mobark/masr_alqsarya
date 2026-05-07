import 'package:equatable/equatable.dart';

enum HomeAwaitingCallActionType { confirm, reschedule }

enum HomeAwaitingCallActionStatus { initial, loading, success, failure }

class HomeAwaitingCallActionState extends Equatable {
  const HomeAwaitingCallActionState({
    this.status = HomeAwaitingCallActionStatus.initial,
    this.actionType,
    this.callId,
    this.error,
  });

  final HomeAwaitingCallActionStatus status;
  final HomeAwaitingCallActionType? actionType;
  final int? callId;
  final String? error;

  HomeAwaitingCallActionState copyWith({
    HomeAwaitingCallActionStatus? status,
    HomeAwaitingCallActionType? actionType,
    int? callId,
    String? error,
    bool clearError = false,
  }) {
    return HomeAwaitingCallActionState(
      status: status ?? this.status,
      actionType: actionType ?? this.actionType,
      callId: callId ?? this.callId,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, actionType, callId, error];
}
