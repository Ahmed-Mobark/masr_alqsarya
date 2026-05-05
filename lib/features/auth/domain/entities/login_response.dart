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
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.type,
    this.permissions = const [],
  });

  final String? token;
  final String? challengeToken;
  final bool requires2FA;
  final bool isVerified;
  final bool hasPendingInvitations;
  final PendingInvitation? pendingInvitation;
  final int? userId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? type;
  final List<String> permissions;

  @override
  List<Object?> get props => [
        token,
        challengeToken,
        requires2FA,
        isVerified,
        hasPendingInvitations,
        pendingInvitation,
        userId,
        firstName,
        lastName,
        email,
        phone,
        type,
        permissions,
      ];
}
