import 'package:equatable/equatable.dart';

class ChatAttachment extends Equatable {
  const ChatAttachment({
    required this.id,
    required this.displayName,
  });

  final int id;
  /// Best-effort filename from API; may be empty (UI should fall back to a generic label).
  final String displayName;

  @override
  List<Object?> get props => [id, displayName];
}
