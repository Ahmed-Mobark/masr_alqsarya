import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/documents/domain/entities/file_activity.dart';
import 'package:masr_al_qsariya/features/documents/domain/repositories/documents_repository.dart';
import 'package:masr_al_qsariya/features/documents/domain/usecases/get_uploaded_file_activity_usecase.dart';

class FileActivityCubit extends Cubit<FileActivityState> {
  FileActivityCubit(this._getActivity, this._repo)
      : super(const FileActivityState.initial());

  final GetUploadedFileActivityUseCase _getActivity;
  final DocumentsRepository _repo;

  Future<void> load({
    required int workspaceId,
    required int assetId,
  }) async {
    emit(state.copyWith(status: FileActivityStatus.loading));
    final result = await _getActivity(
      GetUploadedFileActivityParams(
        workspaceId: workspaceId,
        assetId: assetId,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: FileActivityStatus.failure, failure: failure),
      ),
      (activities) => emit(
        state.copyWith(
          status: FileActivityStatus.success,
          activities: activities,
          failure: null,
        ),
      ),
    );
  }

  Future<void> toggleEvidence({
    required int workspaceId,
    required int assetId,
    required bool isEvidence,
  }) async {
    emit(state.copyWith(isTogglingEvidence: true, isEvidence: isEvidence));
    final result = await _repo.toggleEvidence(
      workspaceId: workspaceId,
      assetId: assetId,
      isEvidence: isEvidence,
    );
    result.fold(
      (failure) {
        // Revert on failure
        emit(state.copyWith(
          isTogglingEvidence: false,
          isEvidence: !isEvidence,
          evidenceError: failure.message,
        ));
      },
      (message) {
        emit(state.copyWith(
          isTogglingEvidence: false,
          evidenceError: null,
        ));
      },
    );
  }

  void clearEvidenceError() {
    emit(state.copyWith(evidenceError: null));
  }
}

enum FileActivityStatus { initial, loading, success, failure }

class FileActivityState extends Equatable {
  const FileActivityState({
    required this.status,
    required this.activities,
    this.failure,
    this.isEvidence = false,
    this.isTogglingEvidence = false,
    this.evidenceError,
  });

  const FileActivityState.initial()
      : status = FileActivityStatus.initial,
        activities = const [],
        failure = null,
        isEvidence = false,
        isTogglingEvidence = false,
        evidenceError = null;

  final FileActivityStatus status;
  final List<FileActivityEntity> activities;
  final Failure? failure;
  final bool isEvidence;
  final bool isTogglingEvidence;
  final String? evidenceError;

  FileActivityState copyWith({
    FileActivityStatus? status,
    List<FileActivityEntity>? activities,
    Failure? failure,
    bool? isEvidence,
    bool? isTogglingEvidence,
    String? evidenceError,
  }) {
    return FileActivityState(
      status: status ?? this.status,
      activities: activities ?? this.activities,
      failure: failure,
      isEvidence: isEvidence ?? this.isEvidence,
      isTogglingEvidence: isTogglingEvidence ?? this.isTogglingEvidence,
      evidenceError: evidenceError,
    );
  }

  @override
  List<Object?> get props =>
      [status, activities, failure, isEvidence, isTogglingEvidence, evidenceError];
}
