import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/storage/workspace_id_storage.dart';
import 'package:masr_al_qsariya/features/schedule/domain/usecases/get_calls_usecase.dart';
import 'package:masr_al_qsariya/features/schedule/presentation/cubit/schedule_calls_state.dart';

class ScheduleCallsCubit extends Cubit<ScheduleCallsState> {
  ScheduleCallsCubit(this._getCalls, this._workspaceIdStorage)
      : super(const ScheduleCallsState());

  final GetCallsUseCase _getCalls;
  final WorkspaceIdStorage _workspaceIdStorage;

  Future<void> load({DateTime? focusedMonth}) async {
    emit(state.copyWith(status: ScheduleCallsStatus.loading, clearError: true));
    final workspaceId = _workspaceIdStorage.get();
    if (workspaceId == null) {
      emit(state.copyWith(
        status: ScheduleCallsStatus.failure,
        error: 'workspace_missing',
      ));
      return;
    }

    final m = focusedMonth ?? DateTime.now();
    final firstDayOfMonth = DateTime(m.year, m.month, 1);
    final startWeekday = firstDayOfMonth.weekday % 7; // Sun=0
    final gridStart = firstDayOfMonth.subtract(Duration(days: startWeekday));
    final gridEndExclusive = gridStart.add(const Duration(days: 42));

    final startsFrom = DateTime(gridStart.year, gridStart.month, gridStart.day);
    final endsTo = gridEndExclusive.subtract(const Duration(seconds: 1));

    final result = await _getCalls(
      GetCallsParams(
        workspaceId: workspaceId,
        startsFrom: startsFrom,
        endsTo: endsTo,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ScheduleCallsStatus.failure,
          error: failure.message,
        ),
      ),
      (calls) => emit(
        state.copyWith(status: ScheduleCallsStatus.success, calls: calls),
      ),
    );
  }
}

