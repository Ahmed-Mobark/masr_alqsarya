import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/storage/workspace_id_storage.dart';
import 'package:masr_al_qsariya/features/sessions/domain/usecases/book_live_session_usecase.dart';
import 'package:masr_al_qsariya/features/sessions/domain/usecases/get_live_session_detail_usecase.dart';
import 'package:masr_al_qsariya/features/sessions/presentation/cubit/live_session_lobby_state.dart';

class LiveSessionLobbyCubit extends Cubit<LiveSessionLobbyState> {
  LiveSessionLobbyCubit(
    this._getDetail,
    this._bookLiveSession,
    this._workspaceIdStorage, {
    required this.liveSessionId,
  }) : super(const LiveSessionLobbyState());

  final GetLiveSessionDetailUseCase _getDetail;
  final BookLiveSessionUseCase _bookLiveSession;
  final WorkspaceIdStorage _workspaceIdStorage;
  final int liveSessionId;

  String _errorMessageFromFailure(dynamic failure) {
    final errors = failure.errors;
    if (errors is Map && errors.isNotEmpty) {
      final sessionErr = errors['live_session_id'];
      if (sessionErr is List && sessionErr.isNotEmpty) {
        return sessionErr.map((e) => e.toString()).join('\n');
      }
      if (sessionErr is String && sessionErr.trim().isNotEmpty) {
        return sessionErr;
      }
    }
    final msg = failure.message?.toString();
    return (msg == null || msg.trim().isEmpty) ? 'unknown_error' : msg;
  }

  Future<void> load() async {
    emit(
      state.copyWith(
        status: LiveSessionLobbyStatus.loading,
        clearError: true,
        clearLobby: true,
      ),
    );

    final result = await _getDetail(liveSessionId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LiveSessionLobbyStatus.failure,
          error: failure.message,
        ),
      ),
      (lobby) => emit(
        state.copyWith(
          status: LiveSessionLobbyStatus.success,
          bookingStatus: LiveSessionLobbyBookingStatus.idle,
          lobby: lobby,
        ),
      ),
    );
  }

  Future<void> book() async {
    final current = state.lobby;
    if (current == null) return;
    if (current.isBooked == true) return;

    final workspaceId = _workspaceIdStorage.get();
    if (workspaceId == null) {
      emit(
        state.copyWith(
          bookingStatus: LiveSessionLobbyBookingStatus.failure,
          bookingError: 'workspace_missing',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        bookingStatus: LiveSessionLobbyBookingStatus.loading,
        clearBookingError: true,
      ),
    );

    final result = await _bookLiveSession(
      BookLiveSessionParams(
        workspaceId: workspaceId,
        liveSessionId: liveSessionId,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          bookingStatus: LiveSessionLobbyBookingStatus.failure,
          bookingError: _errorMessageFromFailure(failure),
        ),
      ),
      (_) => emit(
        state.copyWith(
          bookingStatus: LiveSessionLobbyBookingStatus.success,
          lobby: current.copyWith(isBooked: true),
          clearBookingError: true,
        ),
      ),
    );
  }
}
