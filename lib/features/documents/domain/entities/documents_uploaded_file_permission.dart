import 'package:equatable/equatable.dart';

class DocumentsUploadedFilePermissionEntity extends Equatable {
  const DocumentsUploadedFilePermissionEntity({
    required this.workspaceMemberId,
    required this.canView,
    required this.canUpdate,
  });

  final int workspaceMemberId;
  final bool canView;
  final bool canUpdate;

  @override
  List<Object?> get props => [workspaceMemberId, canView, canUpdate];
}
