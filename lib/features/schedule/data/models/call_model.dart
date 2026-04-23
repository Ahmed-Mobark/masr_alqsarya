import 'package:masr_al_qsariya/features/schedule/domain/entities/call.dart';

class CallModel {
  const CallModel({
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
  final String mode;
  final String status;
  final String livekitRoomName;
  final DateTime scheduledStartsAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory CallModel.fromJson(Map<String, dynamic> json) {
    return CallModel(
      id: (json['id'] as num).toInt(),
      workspaceId: (json['workspace_id'] as num).toInt(),
      mode: (json['mode'] as String?) ?? '',
      status: (json['status'] as String?) ?? '',
      livekitRoomName: (json['livekit_room_name'] as String?) ?? '',
      scheduledStartsAt: DateTime.parse(
        (json['scheduled_starts_at'] as String?) ?? DateTime.now().toIso8601String(),
      ),
      createdAt: DateTime.parse(
        (json['created_at'] as String?) ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        (json['updated_at'] as String?) ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  CallEntity toEntity() {
    return CallEntity(
      id: id,
      workspaceId: workspaceId,
      mode: mode,
      status: status,
      livekitRoomName: livekitRoomName,
      scheduledStartsAt: scheduledStartsAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

