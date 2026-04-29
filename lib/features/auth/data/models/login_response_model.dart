import 'package:masr_al_qsariya/features/auth/domain/entities/login_response.dart';
import 'package:masr_al_qsariya/features/auth/domain/entities/pending_invitation.dart';

class LoginResponseModel {
  const LoginResponseModel({
    this.token,
    this.challengeToken,
    this.requires2FA = false,
    this.isVerified = true,
    this.hasPendingInvitations = false,
    this.pendingInvitation,
  });

  final String? token;
  final String? challengeToken;
  final bool requires2FA;
  final bool isVerified;
  final bool hasPendingInvitations;
  final PendingInvitation? pendingInvitation;

  static bool _parseLooseBool(dynamic v) {
    if (v is bool) return v;
    if (v is num) return v == 1;
    if (v is String) {
      final s = v.trim().toLowerCase();
      return s == 'true' || s == '1' || s == 'yes';
    }
    return false;
  }

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final dataMap = data is Map<String, dynamic> ? data : <String, dynamic>{};

    final challengeToken = dataMap['challenge_token'] as String?;
    final token = dataMap['token'] as String?;

    final user = dataMap['user'];
    final userMap = user is Map<String, dynamic> ? user : <String, dynamic>{};
    final isVerified = _parseLooseBool(userMap['is_verified']);
    final hasPendingInvitations =
        _parseLooseBool(userMap['has_pending_invitations']);

    PendingInvitation? pendingInvitation;
    if (hasPendingInvitations) {
      final pending = userMap['pending_invitation'];
      final pendingMap =
          pending is Map<String, dynamic> ? pending : <String, dynamic>{};

      final code = pendingMap['invitation_code']?.toString();
      if (code != null && code.trim().isNotEmpty) {
        pendingInvitation = PendingInvitation(
          invitationCode: code.trim(),
          workspaceName: (pendingMap['workspace_name']?.toString() ?? '')
              .trim(),
          invitedByName: (pendingMap['invited_by_name']?.toString() ?? '')
              .trim(),
          role: (pendingMap['role']?.toString() ?? '').trim(),
        );
      }
    }

    return LoginResponseModel(
      token: token,
      challengeToken: challengeToken,
      requires2FA: challengeToken != null && token == null,
      isVerified: isVerified,
      hasPendingInvitations: hasPendingInvitations,
      pendingInvitation: pendingInvitation,
    );
  }

  LoginResponse toEntity() => LoginResponse(
        token: token,
        challengeToken: challengeToken,
        requires2FA: requires2FA,
        isVerified: isVerified,
        hasPendingInvitations: hasPendingInvitations,
        pendingInvitation: pendingInvitation,
      );
}
