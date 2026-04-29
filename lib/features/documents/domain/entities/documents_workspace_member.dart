import 'package:equatable/equatable.dart';

class DocumentsWorkspaceMemberEntity extends Equatable {
  const DocumentsWorkspaceMemberEntity({
    required this.id,
    required this.fullName,
    required this.role,
  });

  final int id;
  final String fullName;
  final String role;

  @override
  List<Object?> get props => [id, fullName, role];
}
