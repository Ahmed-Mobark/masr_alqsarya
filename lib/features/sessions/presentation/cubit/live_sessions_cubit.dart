import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/features/sessions/domain/usecases/get_live_sessions_usecase.dart';
import 'package:masr_al_qsariya/features/sessions/presentation/cubit/live_sessions_state.dart';

class LiveSessionsCubit extends Cubit<LiveSessionsState> {
  LiveSessionsCubit(this._getLiveSessions) : super(const LiveSessionsState());

  final GetLiveSessionsUseCase _getLiveSessions;

  static const int _perPage = 15;

  Future<void> load({
    String? search,
    int? personaId,
    String? status,
    bool? isRecorded,
    String? sortDirection,
  }) async {
    emit(
      state.copyWith(
        status: LiveSessionsStatus.loading,
        clearError: true,
      ),
    );

    final result = await _getLiveSessions(
      GetLiveSessionsParams(
        search: search,
        personaId: personaId,
        status: status,
        isRecorded: isRecorded,
        page: 1,
        perPage: _perPage,
        sortDirection: sortDirection,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LiveSessionsStatus.failure,
          error: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          status: LiveSessionsStatus.success,
          items: data.items,
          currentPage: data.currentPage,
          lastPage: data.lastPage,
        ),
      ),
    );
  }
}
