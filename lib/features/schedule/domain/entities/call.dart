import 'package:equatable/equatable.dart';

class CallEntity extends Equatable {
  const CallEntity({
    required this.id,
    required this.workspaceId,
    required this.mode,
    required this.status,
    required this.livekitRoomName,
    required this.scheduledStartsAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int workspaceId;
  final String mode; // audio | video
  final String status; // scheduled | live | ended | ...
  final String livekitRoomName;
  final DateTime scheduledStartsAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
        id,
        workspaceId,
        mode,
        status,
        livekitRoomName,
        scheduledStartsAt,
        createdAt,
        updatedAt,
      ];
}

