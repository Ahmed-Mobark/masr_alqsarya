import 'package:equatable/equatable.dart';

class FamilyWorkspaceMemberEntity extends Equatable {
  final int id;
  final String fullName;
  final String role; // parent/child/lawyer/mediator...
  final String? avatarUrl;
  final String? email;
  final String? phone;
  /// Raw or display-ready birth date string from the API.
  final String? birthDate;
  /// Family-workspace invitation id (for resend/cancel), when returned by API.
  final int? invitationId;
  /// e.g. pending, accepted, cancelled — from API when present.
  final String? invitationStatus;
  /// Workspace membership row status from API `status` (e.g. pending, accepted).
  final String? memberStatus;

  const FamilyWorkspaceMemberEntity({
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

  bool get isChild => role.toLowerCase().contains('child');

  /// Workspace owner (primary account on this workspace).
  bool get isOwnerRole {
    final r = role.toLowerCase().trim();
    return r == 'owner';
  }

  /// Invited professionals / mediators (API role `prof`, therapist, lawyer, …).
  bool get isProfessionalRole {
    final r = role.toLowerCase().trim();
    if (r == 'prof') return true;
    return r.contains('lawyer') ||
        r.contains('lower') ||
        r.contains('therapist') ||
        r.contains('mediator') ||
        r.contains('legal');
  }

  /// Other parent linked to the workspace (not the owner, not a professional).
  bool get isCoPartnerRole {
    final r = role.toLowerCase().trim();
    return !isChild &&
        !isProfessionalRole &&
        !isOwnerRole &&
        (r == 'co_partner' || r.contains('co_partner'));
  }

  /// Same as [isProfessionalRole] (legacy name).
  bool get isLawyerRole => isProfessionalRole;

  /// Professional row with an invitation that can be resent or cancelled.
  bool get canManageLawyerInvitation {
    if (!isProfessionalRole || invitationId == null) return false;
    final s = (invitationStatus ?? memberStatus ?? '').toLowerCase();
    if (s.isEmpty) return true;
    if (s == 'accepted' ||
        s == 'cancelled' ||
        s == 'canceled' ||
        s == 'declined' ||
        s == 'rejected' ||
        s == 'expired') {
      return false;
    }
    return true;
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        role,
        avatarUrl,
        email,
        phone,
        birthDate,
        invitationId,
        invitationStatus,
        memberStatus,
      ];
}

