import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/documents/domain/entities/file_activity.dart';
import 'package:masr_al_qsariya/features/documents/domain/repositories/documents_repository.dart';

class GetUploadedFileActivityUseCase {
  const GetUploadedFileActivityUseCase(this._repo);

  final DocumentsRepository _repo;

  Future<Either<Failure, List<FileActivityEntity>>> call(
    GetUploadedFileActivityParams params,
  ) =>
      _repo.getUploadedFileActivity(
        workspaceId: params.workspaceId,
        assetId: params.assetId,
      );
}

class GetUploadedFileActivityParams extends Equatable {
  const GetUploadedFileActivityParams({
    required this.workspaceId,
    required this.assetId,
  });

  final int workspaceId;
  final int assetId;

  @override
  List<Object> get props => [workspaceId, assetId];
}
