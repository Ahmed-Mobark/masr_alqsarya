import 'package:equatable/equatable.dart';

class CallJoinEntity extends Equatable {
  const CallJoinEntity({
    required this.livekitUrl,
    required this.token,
    required this.roomName,
  });

  final String livekitUrl;
  final String token;
  final String roomName;

  @override
  List<Object?> get props => [livekitUrl, token, roomName];
}

