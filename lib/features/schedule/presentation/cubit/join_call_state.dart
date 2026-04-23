import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/features/schedule/domain/entities/call_join.dart';

enum JoinCallStatus { initial, loading, success, failure }

class JoinCallState extends Equatable {
  const JoinCallState({
    this.status = JoinCallStatus.initial,
    this.joined,
    this.error,
    this.activeCallId,
  });

  final JoinCallStatus status;
  final CallJoinEntity? joined;
  final String? error;
  final int? activeCallId;

  JoinCallState copyWith({
    JoinCallStatus? status,
    CallJoinEntity? joined,
    String? error,
    int? activeCallId,
    bool clearError = false,
    bool clearJoined = false,
  }) {
    return JoinCallState(
      status: status ?? this.status,
      joined: clearJoined ? null : (joined ?? this.joined),
      error: clearError ? null : (error ?? this.error),
      activeCallId: activeCallId ?? this.activeCallId,
    );
  }

  @override
  List<Object?> get props => [status, joined, error, activeCallId];
}

