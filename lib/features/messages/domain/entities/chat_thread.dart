import 'package:equatable/equatable.dart';

class ChatThread extends Equatable {
  const ChatThread({
    required this.id,
    required this.displayName,
    required this.roleLabel,
    required this.avatarUrl,
    required this.lastPreview,
    required this.timeLabel,
    this.unreadCount = 0,
  });

  final int id;
  final String displayName;
  final String roleLabel;
  final String avatarUrl;
  final String lastPreview;
  final String timeLabel;
  final int unreadCount;

  @override
  List<Object?> get props =>
      [id, displayName, roleLabel, avatarUrl, lastPreview, timeLabel, unreadCount];
}
