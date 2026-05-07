import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/storage/workspace_id_storage.dart';
import 'package:masr_al_qsariya/features/sessions/domain/usecases/book_live_session_usecase.dart';
import 'package:masr_al_qsariya/features/sessions/domain/usecases/get_live_sessions_usecase.dart';
import 'package:masr_al_qsariya/features/sessions/presentation/cubit/live_sessions_state.dart';

class LiveSessionsCubit extends Cubit<LiveSessionsState> {
  LiveSessionsCubit(
    this._getLiveSessions,
    this._bookLiveSession,
    this._workspaceIdStorage,
  ) : super(const LiveSessionsState());

  final GetLiveSessionsUseCase _getLiveSessions;
  final BookLiveSessionUseCase _bookLiveSession;
  final WorkspaceIdStorage _workspaceIdStorage;

  static const int _perPage = 15;

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

  Future<void> load({
    String? search,
    int? personaId,
    String? status,
    bool? isRecorded,
    String? sortDirection,
  }) async {
    emit(state.copyWith(status: LiveSessionsStatus.loading, clearError: true));

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

  Future<void> book(int liveSessionId) async {
    final workspaceId = _workspaceIdStorage.get();
    if (workspaceId == null) {
      emit(
        state.copyWith(
          bookingStatus: LiveSessionsBookingStatus.failure,
          bookingSessionId: liveSessionId,
          bookingError: 'workspace_missing',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        bookingStatus: LiveSessionsBookingStatus.loading,
        bookingSessionId: liveSessionId,
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
          bookingStatus: LiveSessionsBookingStatus.failure,
          bookingSessionId: liveSessionId,
          bookingError: _errorMessageFromFailure(failure),
        ),
      ),
      (_) {
        final updated = state.items
            .map(
              (item) => item.id == liveSessionId
                  ? item.copyWith(isBooked: true)
                  : item,
            )
            .toList(growable: false);
        emit(
          state.copyWith(
            items: updated,
            bookingStatus: LiveSessionsBookingStatus.success,
            bookingSessionId: liveSessionId,
            clearBookingError: true,
          ),
        );
      },
    );
  }
}
