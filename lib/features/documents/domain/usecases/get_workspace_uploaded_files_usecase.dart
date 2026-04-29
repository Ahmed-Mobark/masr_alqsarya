import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/documents/domain/entities/uploaded_file.dart';
import 'package:masr_al_qsariya/features/documents/domain/repositories/documents_repository.dart';

class GetWorkspaceUploadedFilesUseCase {
  const GetWorkspaceUploadedFilesUseCase(this._repo);

  final DocumentsRepository _repo;

  Future<Either<Failure, Map<DocumentsFolderType, List<UploadedFileEntity>>>>
  call(GetWorkspaceUploadedFilesParams params) =>
      _repo.getUploadedFiles(workspaceId: params.workspaceId);
}

class GetWorkspaceUploadedFilesParams extends Equatable {
  const GetWorkspaceUploadedFilesParams({required this.workspaceId});

  final int workspaceId;

  @override
  List<Object> get props => [workspaceId];
}
