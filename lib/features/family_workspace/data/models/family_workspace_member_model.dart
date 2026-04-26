import 'package:masr_al_qsariya/features/family_workspace/domain/entities/family_workspace_member.dart';

class FamilyWorkspaceMemberModel {
  final int id;
  final String fullName;
  final String role;
  final String? avatarUrl;

  const FamilyWorkspaceMemberModel({
    required this.id,
    required this.fullName,
    required this.role,
    required this.avatarUrl,
  });

  factory FamilyWorkspaceMemberModel.fromJson(Map<String, dynamic> json) {
    // Try multiple backend shapes safely.
    final id = (json['id'] as num?)?.toInt() ??
        (json['workspace_member_id'] as num?)?.toInt() ??
        0;

    final first = (json['first_name'] ?? json['firstName'] ?? '').toString();
    final last = (json['last_name'] ?? json['lastName'] ?? '').toString();
    final name = (json['name'] ?? json['full_name'] ?? '').toString();

    final fullName = (name.isNotEmpty)
        ? name
        : ('$first $last').trim();

    final role = (json['role'] ?? json['type'] ?? '').toString();

    return FamilyWorkspaceMemberModel(
      id: id,
      fullName: fullName.isEmpty ? '-' : fullName,
      role: role.isEmpty ? 'member' : role,
      avatarUrl: json['avatar_url']?.toString() ?? json['image_url']?.toString(),
    );
  }

  FamilyWorkspaceMemberEntity toEntity() => FamilyWorkspaceMemberEntity(
        id: id,
        fullName: fullName,
        role: role,
        avatarUrl: avatarUrl,
      );
}

