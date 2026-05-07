import 'package:equatable/equatable.dart';

class HomeAwaitingCall extends Equatable {
  const HomeAwaitingCall({
    required this.id,
    required this.status,
    required this.scheduledStartsAt,
    required this.createdByName,
    this.workspaceId,
    this.workspaceName,
  });

  final int id;
  final String status;
  final DateTime? scheduledStartsAt;
  final String createdByName;
  final int? workspaceId;
  final String? workspaceName;

  @override
  List<Object?> get props => [
        id,
        status,
        scheduledStartsAt,
        createdByName,
        workspaceId,
        workspaceName,
      ];
}
