import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/features/sessions/domain/usecases/get_live_session_detail_usecase.dart';
import 'package:masr_al_qsariya/features/sessions/presentation/cubit/live_session_lobby_state.dart';

class LiveSessionLobbyCubit extends Cubit<LiveSessionLobbyState> {
  LiveSessionLobbyCubit(
    this._getDetail, {
    required this.liveSessionId,
  }) : super(const LiveSessionLobbyState());

  final GetLiveSessionDetailUseCase _getDetail;
  final int liveSessionId;

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
          lobby: lobby,
        ),
      ),
    );
  }
}
