import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/documents/domain/entities/file_activity.dart';
import 'package:masr_al_qsariya/features/documents/domain/entities/uploaded_file.dart';
import 'package:masr_al_qsariya/features/documents/domain/entities/uploaded_file_detail.dart';
import 'package:masr_al_qsariya/features/documents/domain/entities/documents_uploaded_file_permission.dart';
import 'package:masr_al_qsariya/features/documents/domain/entities/documents_workspace_member.dart';

abstract class DocumentsRepository {
  Future<Either<Failure, Map<DocumentsFolderType, List<UploadedFileEntity>>>>
  getUploadedFiles({required int workspaceId});

  Future<Either<Failure, List<DocumentsWorkspaceMemberEntity>>>
  getWorkspaceMembers({required int workspaceId});

  Future<Either<Failure, String>> updateUploadedFilePermissions({
    required int workspaceId,
    required int assetId,
    required List<DocumentsUploadedFilePermissionEntity> permissions,
  });

  Future<Either<Failure, List<FileActivityEntity>>> getUploadedFileActivity({
    required int workspaceId,
    required int assetId,
  });

  Future<Either<Failure, UploadedFileDetailEntity>> getUploadedFileDetail({
    required int workspaceId,
    required int assetId,
  });

  Future<Either<Failure, String>> toggleEvidence({
    required int workspaceId,
    required int assetId,
    required bool isEvidence,
  });
}
