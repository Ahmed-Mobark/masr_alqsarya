import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/core/storage/workspace_id_storage.dart';
import 'package:masr_al_qsariya/features/documents/domain/entities/uploaded_file.dart';
import 'package:masr_al_qsariya/features/documents/domain/usecases/get_workspace_uploaded_files_usecase.dart';

class DocumentsCubit extends Cubit<DocumentsState> {
  DocumentsCubit(this._getUploadedFiles, this._workspaceIdStorage)
    : super(const DocumentsState.initial());

  final GetWorkspaceUploadedFilesUseCase _getUploadedFiles;
  final WorkspaceIdStorage _workspaceIdStorage;

  Future<void> load() async {
    final workspaceId = _workspaceIdStorage.get();
    if (workspaceId == null) {
      emit(state.copyWith(status: DocumentsStatus.workspaceMissing));
      return;
    }

    emit(state.copyWith(status: DocumentsStatus.loading));
    final result = await _getUploadedFiles(
      GetWorkspaceUploadedFilesParams(workspaceId: workspaceId),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: DocumentsStatus.failure, failure: failure),
      ),
      (groupedFiles) => emit(
        state.copyWith(
          status: DocumentsStatus.success,
          filesByType: groupedFiles,
          workspaceId: workspaceId,
          failure: null,
        ),
      ),
    );
  }
}

enum DocumentsStatus { initial, loading, success, failure, workspaceMissing }

class DocumentsState extends Equatable {
  const DocumentsState({
    required this.status,
    this.workspaceId,
    required this.filesByType,
    required this.failure,
  });

  const DocumentsState.initial()
    : status = DocumentsStatus.initial,
      workspaceId = null,
      filesByType = const {
        DocumentsFolderType.chats: <UploadedFileEntity>[],
        DocumentsFolderType.calls: <UploadedFileEntity>[],
        DocumentsFolderType.invoices: <UploadedFileEntity>[],
      },
      failure = null;

  final DocumentsStatus status;
  final int? workspaceId;
  final Map<DocumentsFolderType, List<UploadedFileEntity>> filesByType;
  final Failure? failure;

  DocumentsState copyWith({
    DocumentsStatus? status,
    int? workspaceId,
    Map<DocumentsFolderType, List<UploadedFileEntity>>? filesByType,
    Failure? failure,
  }) {
    return DocumentsState(
      status: status ?? this.status,
      workspaceId: workspaceId ?? this.workspaceId,
      filesByType: filesByType ?? this.filesByType,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [status, workspaceId, filesByType, failure];
}
