import 'package:masr_al_qsariya/features/messages/domain/entities/chat_attachment.dart';
import 'package:masr_al_qsariya/features/messages/domain/entities/chat_message.dart';

class ChatMessageModel {
  const ChatMessageModel({
    required this.id,
    required this.body,
    this.createdAtIso,
    this.senderId,
    this.attachments = const [],
    this.isFlagged = false,
  });

  final int id;
  final String body;
  final String? createdAtIso;
  final int? senderId;
  final List<ChatAttachment> attachments;
  final bool isFlagged;

  static List<ChatAttachment> _attachmentsFromMap(Map<String, dynamic> map) {
    final raw = map['attachments'];
    if (raw is! List) return const [];
    final out = <ChatAttachment>[];
    for (final item in raw) {
      if (item is! Map<String, dynamic>) continue;
      final id = (item['id'] as num?)?.toInt();
      if (id == null) continue;
      final name = (item['original_name'] as String?)?.trim() ??
          (item['original_filename'] as String?)?.trim() ??
          (item['file_name'] as String?)?.trim() ??
          (item['name'] as String?)?.trim() ??
          '';
      final url = (item['url'] as String?)?.trim();
      final mimeType = (item['mime_type'] as String?)?.trim() ??
          (item['mimeType'] as String?)?.trim();
      out.add(
        ChatAttachment(
          id: id,
          displayName: name,
          url: url,
          mimeType: mimeType,
        ),
      );
    }
    return out;
  }

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    final sender = map['sender'] is Map<String, dynamic>
        ? map['sender'] as Map<String, dynamic>
        : null;

    int? senderId = (map['user_id'] as num?)?.toInt() ??
        (map['sender_id'] as num?)?.toInt() ??
        (map['author_id'] as num?)?.toInt();
    if (senderId == null && sender != null) {
      senderId = (sender['user_id'] as num?)?.toInt();
    }

    return ChatMessageModel(
      id: (map['id'] as num?)?.toInt() ?? 0,
      body: (map['body'] as String?)?.trim() ??
          (map['content'] as String?)?.trim() ??
          (map['message'] as String?)?.trim() ??
          (map['text'] as String?)?.trim() ??
          '',
      createdAtIso: (map['created_at'] as String?)?.trim(),
      senderId: senderId,
      attachments: _attachmentsFromMap(map),
      isFlagged: map['is_flagged'] == true,
    );
  }

  ChatMessage toEntity() => ChatMessage(
        id: id,
        body: body,
        createdAtIso: createdAtIso,
        senderId: senderId,
        attachments: attachments,
        isFlagged: isFlagged,
      );
}
