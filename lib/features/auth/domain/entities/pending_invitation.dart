import 'package:equatable/equatable.dart';

class PendingInvitation extends Equatable {
  const PendingInvitation({
    required this.invitationCode,
    required this.workspaceName,
    required this.invitedByName,
    required this.role,
  });

  final String invitationCode;
  final String workspaceName;
  final String invitedByName;
  final String role;

  @override
  List<Object?> get props => [invitationCode, workspaceName, invitedByName, role];
}

