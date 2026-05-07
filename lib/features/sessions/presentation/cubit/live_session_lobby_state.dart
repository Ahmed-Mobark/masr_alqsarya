import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/features/sessions/domain/entities/live_session_lobby.dart';

enum LiveSessionLobbyStatus { initial, loading, success, failure }
enum LiveSessionLobbyBookingStatus { idle, loading, success, failure }

class LiveSessionLobbyState extends Equatable {
  const LiveSessionLobbyState({
    this.status = LiveSessionLobbyStatus.initial,
    this.bookingStatus = LiveSessionLobbyBookingStatus.idle,
    this.lobby,
    this.error,
    this.bookingError,
  });

  final LiveSessionLobbyStatus status;
  final LiveSessionLobbyBookingStatus bookingStatus;
  final LiveSessionLobby? lobby;
  final String? error;
  final String? bookingError;

  LiveSessionLobbyState copyWith({
    LiveSessionLobbyStatus? status,
    LiveSessionLobbyBookingStatus? bookingStatus,
    LiveSessionLobby? lobby,
    String? error,
    String? bookingError,
    bool clearError = false,
    bool clearLobby = false,
    bool clearBookingError = false,
  }) {
    return LiveSessionLobbyState(
      status: status ?? this.status,
      bookingStatus: bookingStatus ?? this.bookingStatus,
      lobby: clearLobby ? null : lobby ?? this.lobby,
      error: clearError ? null : error ?? this.error,
      bookingError: clearBookingError
          ? null
          : bookingError ?? this.bookingError,
    );
  }

  @override
  List<Object?> get props => [status, bookingStatus, lobby, error, bookingError];
}
