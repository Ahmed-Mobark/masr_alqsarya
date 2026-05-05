import 'package:masr_al_qsariya/features/family_workspace/domain/entities/family_workspace_member.dart';

class FamilyWorkspaceMemberModel {
  final int id;
  final String fullName;
  final String role;
  final String? avatarUrl;
  final String? email;
  final String? phone;
  final String? birthDate;
  final int? invitationId;
  final String? invitationStatus;
  final String? memberStatus;

  const FamilyWorkspaceMemberModel({
    required this.id,
    required this.fullName,
    required this.role,
    this.avatarUrl,
    this.email,
    this.phone,
    this.birthDate,
    this.invitationId,
    this.invitationStatus,
    this.memberStatus,
  });

  factory FamilyWorkspaceMemberModel.fromJson(Map<String, dynamic> json) {
    // Try multiple backend shapes safely.
    final id = (json['id'] as num?)?.toInt() ??
        (json['workspace_member_id'] as num?)?.toInt() ??
        0;

    final first = (json['first_name'] ?? json['firstName'] ?? '').toString();
    final last = (json['last_name'] ?? json['lastName'] ?? '').toString();
    final name = (json['display_name'] ??
            json['name'] ??
            json['full_name'] ??
            json['fullName'] ??
            '')
        .toString();

    final fullName = (name.isNotEmpty)
        ? name
        : ('$first $last').trim();

    final role = (json['role'] ?? json['type'] ?? '').toString();

    final userJson = json['user'];
    final nestedEmail =
        userJson is Map ? userJson['email']?.toString() : null;
    final nestedPhone =
        userJson is Map ? userJson['phone']?.toString() : null;

    final emailRaw =
        (json['email'] ?? nestedEmail)?.toString().trim() ?? '';
    final phoneRaw = (json['phone'] ??
            json['phone_number'] ??
            json['mobile'] ??
            nestedPhone)
        ?.toString()
        .trim() ??
        '';

    final birthRaw = json['date_of_birth'] ??
        json['birth_date'] ??
        json['dob'] ??
        json['birthday'];
    final birthTrimmed =
        birthRaw == null ? '' : birthRaw.toString().trim();
    final birthDate = birthTrimmed.isEmpty ? null : birthTrimmed;

    int? invitationId;
    String? invitationStatus;
    final inv = json['invitation'];
    if (inv is Map) {
      invitationId = (inv['id'] as num?)?.toInt();
      invitationStatus = inv['status']?.toString();
    }
    invitationId ??= (json['invitation_id'] as num?)?.toInt() ??
        (json['pending_invitation_id'] as num?)?.toInt();
    invitationStatus ??= json['invitation_status']?.toString() ??
        json['invite_status']?.toString();

    final invitationStatusNorm = invitationStatus?.trim();
    final invitationStatusFinal =
        (invitationStatusNorm == null || invitationStatusNorm.isEmpty)
            ? null
            : invitationStatusNorm;

    final memberStatusRaw = json['status']?.toString().trim();
    final memberStatus =
        (memberStatusRaw == null || memberStatusRaw.isEmpty)
            ? null
            : memberStatusRaw;

    return FamilyWorkspaceMemberModel(
      id: id,
      fullName: fullName.isEmpty ? '-' : fullName,
      role: role.isEmpty ? 'member' : role,
      avatarUrl: json['avatar_url']?.toString() ?? json['image_url']?.toString(),
      email: emailRaw.isEmpty ? null : emailRaw,
      phone: phoneRaw.isEmpty ? null : phoneRaw,
      birthDate: birthDate,
      invitationId: invitationId,
      invitationStatus: invitationStatusFinal,
      memberStatus: memberStatus,
    );
  }

  FamilyWorkspaceMemberEntity toEntity() => FamilyWorkspaceMemberEntity(
        id: id,
        fullName: fullName,
        role: role,
        avatarUrl: avatarUrl,
        email: email,
        phone: phone,
        birthDate: birthDate,
        invitationId: invitationId,
        invitationStatus: invitationStatus,
        memberStatus: memberStatus,
      );
}

