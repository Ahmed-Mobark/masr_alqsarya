import 'package:masr_al_qsariya/core/config/app_end_points.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/features/documents/data/models/file_activity_model.dart';
import 'package:masr_al_qsariya/features/documents/data/models/uploaded_file_detail_model.dart';
import 'package:masr_al_qsariya/features/documents/data/models/uploaded_file_model.dart';
import 'package:masr_al_qsariya/features/documents/data/models/documents_workspace_member_model.dart';
import 'package:masr_al_qsariya/features/documents/domain/entities/uploaded_file.dart';
import 'package:masr_al_qsariya/features/documents/domain/entities/documents_uploaded_file_permission.dart';

abstract class DocumentsRemoteDataSource {
  Future<Map<DocumentsFolderType, List<UploadedFileModel>>> getUploadedFiles({
    required int workspaceId,
  });

  Future<List<DocumentsWorkspaceMemberModel>> getWorkspaceMembers({
    required int workspaceId,
  });

  Future<String> updateUploadedFilePermissions({
    required int workspaceId,
    required int assetId,
    required List<DocumentsUploadedFilePermissionEntity> permissions,
  });

  Future<List<FileActivityModel>> getUploadedFileActivity({
    required int workspaceId,
    required int assetId,
  });

  Future<UploadedFileDetailModel> getUploadedFileDetail({
    required int workspaceId,
    required int assetId,
  });

  Future<String> toggleEvidence({
    required int workspaceId,
    required int assetId,
    required bool isEvidence,
  });
}

class DocumentsRemoteDataSourceImpl implements DocumentsRemoteDataSource {
  const DocumentsRemoteDataSourceImpl(this._api);

  final ApiBaseHelper _api;

  @override
  Future<Map<DocumentsFolderType, List<UploadedFileModel>>> getUploadedFiles({
    required int workspaceId,
  }) async {
    final response = await _api.get<Map<String, dynamic>>(
      url: AppEndpoints.workspaceUploadedFiles(workspaceId),
    );

    final data = response['data'];
    if (data is! Map<String, dynamic>) {
      return _emptyFolders();
    }

    return {
      DocumentsFolderType.chats: _parseList(data['chats']),
      DocumentsFolderType.calls: _parseList(data['calls']),
      DocumentsFolderType.invoices: _parseList(data['invoices']),
    };
  }

  List<UploadedFileModel> _parseList(dynamic rawList) {
    if (rawList is! List) {
      return const [];
    }
    return rawList
        .whereType<Map<String, dynamic>>()
        .map(UploadedFileModel.fromJson)
        .toList();
  }

  Map<DocumentsFolderType, List<UploadedFileModel>> _emptyFolders() {
    return const {
      DocumentsFolderType.chats: <UploadedFileModel>[],
      DocumentsFolderType.calls: <UploadedFileModel>[],
      DocumentsFolderType.invoices: <UploadedFileModel>[],
    };
  }

  @override
  Future<List<DocumentsWorkspaceMemberModel>> getWorkspaceMembers({
    required int workspaceId,
  }) async {
    final response = await _api.get<Map<String, dynamic>>(
      url: AppEndpoints.familyWorkspaceMembers,
      queryParameters: {'workspace_id': workspaceId.toString()},
    );

    final data = response['data'];
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(DocumentsWorkspaceMemberModel.fromJson)
          .toList();
    }
    if (data is Map<String, dynamic>) {
      final inner = data['data'];
      if (inner is List) {
        return inner
            .whereType<Map<String, dynamic>>()
            .map(DocumentsWorkspaceMemberModel.fromJson)
            .toList();
      }
    }
    return const [];
  }

  @override
  Future<String> updateUploadedFilePermissions({
    required int workspaceId,
    required int assetId,
    required List<DocumentsUploadedFilePermissionEntity> permissions,
  }) async {
    final body = {
      'permissions': permissions
          .map(
            (p) => {
              'workspace_member_id': p.workspaceMemberId,
              'can_view': p.canView,
              'can_update': p.canUpdate,
            },
          )
          .toList(),
    };

    final response = await _api.patch<Map<String, dynamic>>(
      url: AppEndpoints.workspaceUploadedFilePermissions(workspaceId, assetId),
      body: body,
    );

    final message = response['message'];
    return message is String
        ? message
        : 'تم تحديث صلاحيات الملف المرفوع بنجاح.';
  }

  @override
  Future<List<FileActivityModel>> getUploadedFileActivity({
    required int workspaceId,
    required int assetId,
  }) async {
    final response = await _api.get<Map<String, dynamic>>(
      url: AppEndpoints.workspaceUploadedFileActivity(workspaceId, assetId),
    );

    final data = response['data'];
    if (data is! List) return const [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(FileActivityModel.fromJson)
        .toList();
  }

  @override
  Future<UploadedFileDetailModel> getUploadedFileDetail({
    required int workspaceId,
    required int assetId,
  }) async {
    final response = await _api.get<Map<String, dynamic>>(
      url: AppEndpoints.workspaceUploadedFileDetail(workspaceId, assetId),
    );

    final data = response['data'];
    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid uploaded file detail response');
    }
    return UploadedFileDetailModel.fromJson(data);
  }

  @override
  Future<String> toggleEvidence({
    required int workspaceId,
    required int assetId,
    required bool isEvidence,
  }) async {
    final response = await _api.post<Map<String, dynamic>>(
      url: AppEndpoints.workspaceUploadedFileEvidence(workspaceId, assetId),
      body: {'is_evidence': isEvidence ? 1 : 0},
    );

    final message = response['message'];
    return message is String ? message : '';
  }
}
