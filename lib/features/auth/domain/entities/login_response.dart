import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/features/auth/domain/entities/pending_invitation.dart';

class LoginResponse extends Equatable {
  const LoginResponse({
    required this.token,
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

  @override
  List<Object?> get props => [
        token,
        challengeToken,
        requires2FA,
        isVerified,
        hasPendingInvitations,
        pendingInvitation,
      ];
}
