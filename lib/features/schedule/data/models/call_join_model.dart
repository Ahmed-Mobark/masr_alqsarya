import 'package:masr_al_qsariya/features/schedule/domain/entities/call_join.dart';

class CallJoinModel {
  const CallJoinModel({
    required this.livekitUrl,
    required this.token,
    required this.roomName,
  });

  final String livekitUrl;
  final String token;
  final String roomName;

  factory CallJoinModel.fromJson(Map<String, dynamic> json) {
    return CallJoinModel(
      livekitUrl: (json['livekit_url'] ?? '').toString(),
      token: (json['token'] ?? '').toString(),
      roomName: (json['room_name'] ?? '').toString(),
    );
  }

  CallJoinEntity toEntity() => CallJoinEntity(
        livekitUrl: livekitUrl,
        token: token,
        roomName: roomName,
      );
}

