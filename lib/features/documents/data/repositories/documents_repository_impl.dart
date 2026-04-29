import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/core/network/network_service/repository_helper.dart';
import 'package:masr_al_qsariya/features/documents/data/datasources/documents_remote_data_source.dart';
import 'package:masr_al_qsariya/features/documents/domain/entities/documents_uploaded_file_permission.dart';
import 'package:masr_al_qsariya/features/documents/domain/entities/documents_workspace_member.dart';
import 'package:masr_al_qsariya/features/documents/domain/entities/file_activity.dart';
import 'package:masr_al_qsariya/features/documents/domain/entities/uploaded_file.dart';
import 'package:masr_al_qsariya/features/documents/domain/entities/uploaded_file_detail.dart';
import 'package:masr_al_qsariya/features/documents/domain/repositories/documents_repository.dart';

class DocumentsRepositoryImpl
    with RepositoryHelper
    implements DocumentsRepository {
  const DocumentsRepositoryImpl(this._remote);

  final DocumentsRemoteDataSource _remote;

  @override
  Future<Either<Failure, Map<DocumentsFolderType, List<UploadedFileEntity>>>>
  getUploadedFiles({required int workspaceId}) {
    return handleEither(() async {
      final grouped = await _remote.getUploadedFiles(workspaceId: workspaceId);
      return grouped.map(
        (key, value) =>
            MapEntry(key, value.map((item) => item.toEntity()).toList()),
      );
    });
  }

  @override
  Future<Either<Failure, List<DocumentsWorkspaceMemberEntity>>>
  getWorkspaceMembers({required int workspaceId}) {
    return handleEither(() async {
      final models = await _remote.getWorkspaceMembers(
        workspaceId: workspaceId,
      );
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, String>> updateUploadedFilePermissions({
    required int workspaceId,
    required int assetId,
    required List<DocumentsUploadedFilePermissionEntity> permissions,
  }) {
    return handleEither(() async {
      final message = await _remote.updateUploadedFilePermissions(
        workspaceId: workspaceId,
        assetId: assetId,
        permissions: permissions,
      );
      return message;
    });
  }

  @override
  Future<Either<Failure, List<FileActivityEntity>>> getUploadedFileActivity({
    required int workspaceId,
    required int assetId,
  }) {
    return handleEither(() async {
      final models = await _remote.getUploadedFileActivity(
        workspaceId: workspaceId,
        assetId: assetId,
      );
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, UploadedFileDetailEntity>> getUploadedFileDetail({
    required int workspaceId,
    required int assetId,
  }) {
    return handleEither(() async {
      final model = await _remote.getUploadedFileDetail(
        workspaceId: workspaceId,
        assetId: assetId,
      );
      return model.entity;
    });
  }

  @override
  Future<Either<Failure, String>> toggleEvidence({
    required int workspaceId,
    required int assetId,
    required bool isEvidence,
  }) {
    return handleEither(() async {
      return _remote.toggleEvidence(
        workspaceId: workspaceId,
        assetId: assetId,
        isEvidence: isEvidence,
      );
    });
  }
}
