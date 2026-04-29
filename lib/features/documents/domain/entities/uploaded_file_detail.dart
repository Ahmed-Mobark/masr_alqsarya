import 'package:equatable/equatable.dart';

class UploadedFileDetailEntity extends Equatable {
  const UploadedFileDetailEntity({
    required this.id,
    required this.sourceType,
    required this.relatedId,
    required this.originalName,
    required this.mimeType,
    required this.size,
    required this.url,
    required this.uploadedBy,
    required this.uploadedDateHumanReadable,
    required this.visibility,
    required this.permissions,
    required this.isEvidence,
    this.evidenceMarkedAt,
    this.evidenceMarkedByUserId,
  });

  final int id;
  final String sourceType;
  final int relatedId;
  final String originalName;
  final String mimeType;
  final int size;
  final String url;
  final UploadedByEntity uploadedBy;
  final String uploadedDateHumanReadable;
  final FileVisibilityEntity visibility;
  final FilePermissionsEntity permissions;
  final bool isEvidence;
  final String? evidenceMarkedAt;
  final int? evidenceMarkedByUserId;

  @override
  List<Object?> get props => [
    id, sourceType, relatedId, originalName, mimeType, size, url,
    uploadedBy, uploadedDateHumanReadable, visibility, permissions,
    isEvidence, evidenceMarkedAt, evidenceMarkedByUserId,
  ];
}

class UploadedByEntity extends Equatable {
  const UploadedByEntity({
    required this.id,
    required this.name,
    required this.email,
  });

  final int id;
  final String name;
  final String email;

  @override
  List<Object?> get props => [id, name, email];
}

class FileVisibilityEntity extends Equatable {
  const FileVisibilityEntity({
    required this.members,
    required this.canViewCount,
    required this.workspaceMembersCount,
  });

  final List<FileVisibilityMemberEntity> members;
  final int canViewCount;
  final int workspaceMembersCount;

  @override
  List<Object?> get props => [members, canViewCount, workspaceMembersCount];
}

class FileVisibilityMemberEntity extends Equatable {
  const FileVisibilityMemberEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.role,
  });

  final int id;
  final int userId;
  final String name;
  final String role;

  @override
  List<Object?> get props => [id, userId, name, role];
}

class FilePermissionsEntity extends Equatable {
  const FilePermissionsEntity({
    required this.canView,
    required this.canUpdate,
  });

  final bool canView;
  final bool canUpdate;

  @override
  List<Object?> get props => [canView, canUpdate];
}
