import 'package:masr_al_qsariya/core/methods/covert_datetime_to_string.dart';
import 'package:masr_al_qsariya/features/messages/domain/entities/chat_thread.dart';

class ChatThreadModel {
  const ChatThreadModel({
    required this.id,
    required this.displayName,
    required this.roleLabel,
    required this.avatarUrl,
    required this.lastPreview,
    required this.updatedAtIso,
    required this.unreadCount,
  });

  final int id;
  final String displayName;
  /// API role slug for the peer (e.g. owner, co_partner, child); localized in UI.
  final String roleLabel;
  final String avatarUrl;
  final String lastPreview;
  final String? updatedAtIso;
  final int unreadCount;

  static Map<String, dynamic>? _pickPeerMember(
    Map<String, dynamic> map,
    int? viewerUserId,
  ) {
    final lower = map['lower_member'] is Map<String, dynamic>
        ? map['lower_member'] as Map<String, dynamic>
        : null;
    final higher = map['higher_member'] is Map<String, dynamic>
        ? map['higher_member'] as Map<String, dynamic>
        : null;

    if (lower == null && higher == null) return null;

    final lowerUid = (lower?['user_id'] as num?)?.toInt();
    final higherUid = (higher?['user_id'] as num?)?.toInt();

    if (viewerUserId != null) {
      if (lowerUid == viewerUserId) return higher;
      if (higherUid == viewerUserId) return lower;
    }

    return higher ?? lower;
  }

  static String _nameFromUserMap(Map<String, dynamic> u) {
    final dn = (u['display_name'] as String?)?.trim();
    if (dn != null && dn.isNotEmpty) return dn;

    final full = (u['full_name'] as String?)?.trim();
    if (full != null && full.isNotEmpty) return full;
    final first = (u['first_name'] as String?) ?? '';
    final last = (u['last_name'] as String?) ?? '';
    final combined = '${first.trim()} ${last.trim()}'.trim();
    if (combined.isNotEmpty) return combined;
    return (u['name'] as String?)?.trim() ?? '';
  }

  factory ChatThreadModel.fromMap(
    Map<String, dynamic> map, {
    int? viewerUserId,
  }) {
    final peer = _pickPeerMember(map, viewerUserId);

    final otherUser = map['other_user'] is Map<String, dynamic>
        ? map['other_user'] as Map<String, dynamic>
        : null;
    final participant = map['participant'] is Map<String, dynamic>
        ? map['participant'] as Map<String, dynamic>
        : null;
    final user = peer ?? otherUser ?? participant;

    var displayName = (map['title'] as String?)?.trim() ??
        (map['name'] as String?)?.trim() ??
        (map['subject'] as String?)?.trim() ??
        (map['display_name'] as String?)?.trim() ??
        '';
    if (displayName.isEmpty && user != null) {
      displayName = _nameFromUserMap(user);
    }
    if (displayName.isEmpty) {
      displayName = 'Chat';
    }

    final lastMsg = map['latest_message'] ?? map['last_message'];
    var preview = (map['last_message_preview'] as String?)?.trim() ??
        (map['preview'] as String?)?.trim() ??
        '';
    if (lastMsg is Map<String, dynamic>) {
      final body = (lastMsg['body'] as String?) ??
          (lastMsg['message'] as String?) ??
          (lastMsg['text'] as String?) ??
          (lastMsg['content'] as String?) ??
          '';
      if (body.trim().isNotEmpty) preview = body.trim();
    } else if (lastMsg is String && lastMsg.trim().isNotEmpty) {
      preview = lastMsg.trim();
    }

    var avatar = (map['avatar_url'] as String?)?.trim() ??
        (map['avatar'] as String?)?.trim() ??
        '';
    if (avatar.isEmpty && user != null) {
      avatar = (user['image_url'] as String?)?.trim() ??
          (user['avatar'] as String?)?.trim() ??
          (user['avatar_url'] as String?)?.trim() ??
          '';
    }

    var role = (map['role'] as String?)?.trim() ?? '';
    if (role.isEmpty && user != null) {
      role = (user['type'] as String?)?.trim() ??
          (user['role'] as String?)?.trim() ??
          '';
    }

    String? messageTime;
    if (lastMsg is Map<String, dynamic>) {
      messageTime = (lastMsg['created_at'] as String?)?.trim();
    }

    final updatedAt = messageTime?.isNotEmpty == true
        ? messageTime
        : (map['updated_at'] as String?)?.trim() ??
            (map['last_message_at'] as String?)?.trim();

    final unread = (map['unread_count'] as num?)?.toInt() ??
        (map['unread_messages_count'] as num?)?.toInt() ??
        (map['unread'] as num?)?.toInt() ??
        0;

    return ChatThreadModel(
      id: (map['id'] as num?)?.toInt() ?? 0,
      displayName: displayName,
      roleLabel: role,
      avatarUrl: avatar,
      lastPreview: preview,
      updatedAtIso:
          (updatedAt == null || updatedAt.isEmpty) ? null : updatedAt,
      unreadCount: unread,
    );
  }

  String _formatTimeLabel() {
    final iso = updatedAtIso;
    if (iso == null || iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso);
      return ConvertDateTime.convertDateTimeToTime(date: dt);
    } catch (_) {
      return '';
    }
  }

  ChatThread toEntity() => ChatThread(
        id: id,
        displayName: displayName,
        roleLabel: roleLabel,
        avatarUrl: avatarUrl,
        lastPreview: lastPreview,
        timeLabel: _formatTimeLabel(),
        unreadCount: unreadCount,
      );
}
