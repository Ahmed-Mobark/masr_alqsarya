import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/storage/call_join_storage.dart';
import 'package:masr_al_qsariya/core/storage/workspace_id_storage.dart';
import 'package:masr_al_qsariya/features/schedule/domain/usecases/join_call_usecase.dart';
import 'package:masr_al_qsariya/features/schedule/presentation/cubit/join_call_state.dart';

class JoinCallCubit extends Cubit<JoinCallState> {
  JoinCallCubit(
    this._joinCall,
    this._workspaceIdStorage,
    this._callJoinStorage,
  ) : super(const JoinCallState());

  final JoinCallUseCase _joinCall;
  final WorkspaceIdStorage _workspaceIdStorage;
  final CallJoinStorage _callJoinStorage;

  void reset() {
    emit(const JoinCallState());
  }

  Future<void> join(int callId) async {
    final workspaceId = _workspaceIdStorage.get();
    if (workspaceId == null) {
      emit(state.copyWith(
        status: JoinCallStatus.failure,
        error: 'workspace_missing',
        activeCallId: callId,
      ));
      return;
    }

    emit(state.copyWith(
      status: JoinCallStatus.loading,
      clearError: true,
      clearJoined: true,
      activeCallId: callId,
    ));

    final result = await _joinCall(
      JoinCallParams(workspaceId: workspaceId, callId: callId),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: JoinCallStatus.failure,
        error: failure.message,
        activeCallId: callId,
      )),
      (joined) async {
        await _callJoinStorage.store(
          callId: callId,
          livekitUrl: joined.livekitUrl,
          token: joined.token,
          roomName: joined.roomName,
        );
        emit(state.copyWith(
          status: JoinCallStatus.success,
          joined: joined,
          activeCallId: callId,
        ));
      },
    );
  }
}

