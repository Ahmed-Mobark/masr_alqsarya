import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/features/messages/domain/usecases/get_chat_threads_usecase.dart';
import 'package:masr_al_qsariya/features/messages/presentation/cubit/messages_state.dart';
import 'package:masr_al_qsariya/core/storage/workspace_id_storage.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit(this._getThreads, this._workspaceIdStorage)
      : super(const MessagesState());

  final GetChatThreadsUseCase _getThreads;
  final WorkspaceIdStorage _workspaceIdStorage;

  Future<void> loadThreads() async {
    emit(state.copyWith(status: MessagesStatus.loading, clearError: true));

    final workspaceId = _workspaceIdStorage.get();
    if (workspaceId == null) {
      emit(state.copyWith(
        status: MessagesStatus.failure,
        errorMessage: '__workspace_missing__',
      ));
      return;
    }

    final result = await _getThreads(workspaceId);
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: MessagesStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (threads) {
        emit(state.copyWith(
          status: MessagesStatus.success,
          threads: threads,
        ));
      },
    );
  }
}
