import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/features/sessions/domain/entities/live_session_lobby.dart';

enum LiveSessionLobbyStatus { initial, loading, success, failure }

class LiveSessionLobbyState extends Equatable {
  const LiveSessionLobbyState({
    this.status = LiveSessionLobbyStatus.initial,
    this.lobby,
    this.error,
  });

  final LiveSessionLobbyStatus status;
  final LiveSessionLobby? lobby;
  final String? error;

  LiveSessionLobbyState copyWith({
    LiveSessionLobbyStatus? status,
    LiveSessionLobby? lobby,
    String? error,
    bool clearError = false,
    bool clearLobby = false,
  }) {
    return LiveSessionLobbyState(
      status: status ?? this.status,
      lobby: clearLobby ? null : lobby ?? this.lobby,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, lobby, error];
}
