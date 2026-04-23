import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/storage/workspace_id_storage.dart';
import 'package:masr_al_qsariya/features/schedule/domain/usecases/get_calls_usecase.dart';
import 'package:masr_al_qsariya/features/schedule/presentation/cubit/schedule_calls_state.dart';

class ScheduleCallsCubit extends Cubit<ScheduleCallsState> {
  ScheduleCallsCubit(this._getCalls, this._workspaceIdStorage)
      : super(const ScheduleCallsState());

  final GetCallsUseCase _getCalls;
  final WorkspaceIdStorage _workspaceIdStorage;

  Future<void> load() async {
    emit(state.copyWith(status: ScheduleCallsStatus.loading, clearError: true));
    final workspaceId = _workspaceIdStorage.get();
    if (workspaceId == null) {
      emit(state.copyWith(
        status: ScheduleCallsStatus.failure,
        error: 'workspace_missing',
      ));
      return;
    }

    final result = await _getCalls(GetCallsParams(workspaceId: workspaceId));
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

