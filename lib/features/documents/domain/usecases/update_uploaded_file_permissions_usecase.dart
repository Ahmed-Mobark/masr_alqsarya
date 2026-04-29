import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/documents/domain/entities/documents_uploaded_file_permission.dart';
import 'package:masr_al_qsariya/features/documents/domain/repositories/documents_repository.dart';

class UpdateUploadedFilePermissionsUseCase {
  const UpdateUploadedFilePermissionsUseCase(this._repo);

  final DocumentsRepository _repo;

  Future<Either<Failure, String>> call(
    UpdateUploadedFilePermissionsParams params,
  ) {
    return _repo.updateUploadedFilePermissions(
      workspaceId: params.workspaceId,
      assetId: params.assetId,
      permissions: params.permissions,
    );
  }
}

class UpdateUploadedFilePermissionsParams extends Equatable {
  const UpdateUploadedFilePermissionsParams({
    required this.workspaceId,
    required this.assetId,
    required this.permissions,
  });

  final int workspaceId;
  final int assetId;
  final List<DocumentsUploadedFilePermissionEntity> permissions;

  @override
  List<Object?> get props => [workspaceId, assetId, permissions];
}
