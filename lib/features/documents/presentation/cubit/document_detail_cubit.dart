import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/documents/domain/entities/uploaded_file_detail.dart';
import 'package:masr_al_qsariya/features/documents/domain/usecases/get_uploaded_file_detail_usecase.dart';

class DocumentDetailCubit extends Cubit<DocumentDetailState> {
  DocumentDetailCubit(this._getDetail) : super(const DocumentDetailState.initial());

  final GetUploadedFileDetailUseCase _getDetail;

  Future<void> load({
    required int workspaceId,
    required int assetId,
  }) async {
    emit(state.copyWith(status: DocumentDetailStatus.loading));
    final result = await _getDetail(
      GetUploadedFileDetailParams(
        workspaceId: workspaceId,
        assetId: assetId,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: DocumentDetailStatus.failure, failure: failure),
      ),
      (detail) => emit(
        state.copyWith(
          status: DocumentDetailStatus.success,
          detail: detail,
          failure: null,
        ),
      ),
    );
  }
}

enum DocumentDetailStatus { initial, loading, success, failure }

class DocumentDetailState extends Equatable {
  const DocumentDetailState({
    required this.status,
    this.detail,
    this.failure,
  });

  const DocumentDetailState.initial()
      : status = DocumentDetailStatus.initial,
        detail = null,
        failure = null;

  final DocumentDetailStatus status;
  final UploadedFileDetailEntity? detail;
  final Failure? failure;

  DocumentDetailState copyWith({
    DocumentDetailStatus? status,
    UploadedFileDetailEntity? detail,
    Failure? failure,
  }) {
    return DocumentDetailState(
      status: status ?? this.status,
      detail: detail ?? this.detail,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [status, detail, failure];
}
