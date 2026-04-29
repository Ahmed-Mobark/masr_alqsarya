import 'package:masr_al_qsariya/features/documents/domain/entities/documents_workspace_member.dart';

class DocumentsWorkspaceMemberModel {
  const DocumentsWorkspaceMemberModel({
    required this.id,
    required this.fullName,
    required this.role,
  });

  final int id;
  final String fullName;
  final String role;

  factory DocumentsWorkspaceMemberModel.fromJson(Map<String, dynamic> json) {
    final id =
        (json['workspace_member_id'] as num?)?.toInt() ??
        (json['id'] as num?)?.toInt() ??
        0;

    final role = (json['role'] ?? json['type'] ?? '').toString();
    final first = (json['first_name'] ?? json['firstName'] ?? '').toString();
    final last = (json['last_name'] ?? json['lastName'] ?? '').toString();
    final name =
        (json['display_name'] ??
                json['name'] ??
                json['full_name'] ??
                json['fullName'] ??
                '')
            .toString();

    final fullName = name.isNotEmpty ? name : ('$first $last').trim();

    return DocumentsWorkspaceMemberModel(
      id: id,
      fullName: fullName,
      role: role,
    );
  }

  DocumentsWorkspaceMemberEntity toEntity() =>
      DocumentsWorkspaceMemberEntity(id: id, fullName: fullName, role: role);
}
