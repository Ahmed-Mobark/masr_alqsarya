import 'package:equatable/equatable.dart';

class FamilyWorkspaceMemberEntity extends Equatable {
  final int id;
  final String fullName;
  final String role; // parent/child/lawyer/mediator...
  final String? avatarUrl;

  const FamilyWorkspaceMemberEntity({
    required this.id,
    required this.fullName,
    required this.role,
    required this.avatarUrl,
  });

  bool get isChild => role.toLowerCase().contains('child');

  @override
  List<Object?> get props => [id, fullName, role, avatarUrl];
}

