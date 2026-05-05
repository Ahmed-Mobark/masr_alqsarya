import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/features/sessions/domain/entities/live_session_summary.dart';

enum LiveSessionsStatus { initial, loading, success, failure }

class LiveSessionsState extends Equatable {
  const LiveSessionsState({
    this.status = LiveSessionsStatus.initial,
    this.items = const [],
    this.error,
    this.currentPage = 1,
    this.lastPage = 1,
  });

  final LiveSessionsStatus status;
  final List<LiveSessionSummary> items;
  final String? error;
  final int currentPage;
  final int lastPage;

  LiveSessionsState copyWith({
    LiveSessionsStatus? status,
    List<LiveSessionSummary>? items,
    String? error,
    int? currentPage,
    int? lastPage,
    bool clearError = false,
  }) {
    return LiveSessionsState(
      status: status ?? this.status,
      items: items ?? this.items,
      error: clearError ? null : error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
    );
  }

  @override
  List<Object?> get props => [status, items, error, currentPage, lastPage];
}
