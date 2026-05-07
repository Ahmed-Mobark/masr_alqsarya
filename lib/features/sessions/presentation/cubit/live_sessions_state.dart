import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/features/sessions/domain/entities/live_session_summary.dart';

enum LiveSessionsStatus { initial, loading, success, failure }

enum LiveSessionsBookingStatus { idle, loading, success, failure }

class LiveSessionsState extends Equatable {
  const LiveSessionsState({
    this.status = LiveSessionsStatus.initial,
    this.items = const [],
    this.error,
    this.currentPage = 1,
    this.lastPage = 1,
    this.bookingStatus = LiveSessionsBookingStatus.idle,
    this.bookingSessionId,
    this.bookingError,
  });

  final LiveSessionsStatus status;
  final List<LiveSessionSummary> items;
  final String? error;
  final int currentPage;
  final int lastPage;
  final LiveSessionsBookingStatus bookingStatus;
  final int? bookingSessionId;
  final String? bookingError;

  LiveSessionsState copyWith({
    LiveSessionsStatus? status,
    List<LiveSessionSummary>? items,
    String? error,
    int? currentPage,
    int? lastPage,
    LiveSessionsBookingStatus? bookingStatus,
    int? bookingSessionId,
    String? bookingError,
    bool clearError = false,
    bool clearBookingError = false,
    bool clearBookingSessionId = false,
  }) {
    return LiveSessionsState(
      status: status ?? this.status,
      items: items ?? this.items,
      error: clearError ? null : error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      bookingStatus: bookingStatus ?? this.bookingStatus,
      bookingSessionId: clearBookingSessionId
          ? null
          : bookingSessionId ?? this.bookingSessionId,
      bookingError: clearBookingError
          ? null
          : bookingError ?? this.bookingError,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    error,
    currentPage,
    lastPage,
    bookingStatus,
    bookingSessionId,
    bookingError,
  ];
}
