import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/documents/domain/entities/uploaded_file_detail.dart';
import 'package:masr_al_qsariya/features/documents/domain/repositories/documents_repository.dart';

class GetUploadedFileDetailUseCase {
  const GetUploadedFileDetailUseCase(this._repo);

  final DocumentsRepository _repo;

  Future<Either<Failure, UploadedFileDetailEntity>> call(
    GetUploadedFileDetailParams params,
  ) =>
      _repo.getUploadedFileDetail(
        workspaceId: params.workspaceId,
        assetId: params.assetId,
      );
}

class GetUploadedFileDetailParams extends Equatable {
  const GetUploadedFileDetailParams({
    required this.workspaceId,
    required this.assetId,
  });

  final int workspaceId;
  final int assetId;

  @override
  List<Object> get props => [workspaceId, assetId];
}
