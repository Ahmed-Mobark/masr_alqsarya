import 'package:equatable/equatable.dart';

class ChatAttachment extends Equatable {
  const ChatAttachment({
    required this.id,
    required this.displayName,
    this.url,
    this.mimeType,
  });

  final int id;
  /// Best-effort filename from API; may be empty (UI should fall back to a generic label).
  final String displayName;
  /// Private download/preview URL (usually requires Authorization header).
  final String? url;
  final String? mimeType;

  @override
  List<Object?> get props => [id, displayName, url, mimeType];
}
