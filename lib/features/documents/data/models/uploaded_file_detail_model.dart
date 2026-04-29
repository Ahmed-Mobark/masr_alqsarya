import 'package:masr_al_qsariya/features/documents/domain/entities/uploaded_file_detail.dart';

class UploadedFileDetailModel {
  const UploadedFileDetailModel._({required this.entity});

  final UploadedFileDetailEntity entity;

  factory UploadedFileDetailModel.fromJson(Map<String, dynamic> json) {
    final uploadedByJson = json['uploaded_by'] as Map<String, dynamic>? ?? {};
    final visibilityJson = json['visibility'] as Map<String, dynamic>? ?? {};
    final permissionsJson = json['permissions'] as Map<String, dynamic>? ?? {};

    final membersRaw =
        visibilityJson['can_view_workspace_members'] as List? ?? [];

    return UploadedFileDetailModel._(
      entity: UploadedFileDetailEntity(
        id: (json['id'] as num?)?.toInt() ?? 0,
        sourceType: (json['source_type'] as String?) ?? '',
        relatedId: (json['related_id'] as num?)?.toInt() ?? 0,
        originalName: (json['original_name'] as String?) ?? '',
        mimeType: (json['mime_type'] as String?) ?? '',
        size: (json['size'] as num?)?.toInt() ?? 0,
        url: (json['url'] as String?) ?? '',
        uploadedBy: UploadedByEntity(
          id: (uploadedByJson['id'] as num?)?.toInt() ?? 0,
          name: (uploadedByJson['name'] as String?) ?? '',
          email: (uploadedByJson['email'] as String?) ?? '',
        ),
        uploadedDateHumanReadable:
            (json['uploaded_date_human_readable'] as String?) ?? '',
        visibility: FileVisibilityEntity(
          members: membersRaw
              .whereType<Map<String, dynamic>>()
              .map(
                (m) => FileVisibilityMemberEntity(
                  id: (m['id'] as num?)?.toInt() ?? 0,
                  userId: (m['user_id'] as num?)?.toInt() ?? 0,
                  name: (m['name'] as String?) ?? '',
                  role: (m['role'] as String?) ?? '',
                ),
              )
              .toList(),
          canViewCount:
              (visibilityJson['can_view_count'] as num?)?.toInt() ?? 0,
          workspaceMembersCount:
              (visibilityJson['workspace_members_count'] as num?)?.toInt() ?? 0,
        ),
        permissions: FilePermissionsEntity(
          canView: (permissionsJson['can_view'] as bool?) ?? false,
          canUpdate: (permissionsJson['can_update'] as bool?) ?? false,
        ),
        isEvidence: (json['is_evidence'] as bool?) ?? false,
        evidenceMarkedAt: json['evidence_marked_at'] as String?,
        evidenceMarkedByUserId:
            (json['evidence_marked_by_user_id'] as num?)?.toInt(),
      ),
    );
  }
}
