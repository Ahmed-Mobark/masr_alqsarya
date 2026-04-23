import 'package:flutter/foundation.dart';
import 'package:masr_al_qsariya/core/moderation/chat_moderation_remote_data_source.dart';

class ChatModerationDecision {
  const ChatModerationDecision({
    required this.allowed,
    this.reason,
    this.severity = 0,
    this.blockedAttachmentNames = const [],
  });

  final bool allowed;
  final String? reason;

  /// 0..10
  final int severity;
  final List<String> blockedAttachmentNames;
}

/// Local “AI-like” moderation. Fast, offline, and deterministic.
///
/// Swap this later with a real backend/LLM moderation API if needed.
class ChatModerationService {
  const ChatModerationService({ChatModerationRemoteDataSource? remote})
    : _remote = remote;

  final ChatModerationRemoteDataSource? _remote;

  Future<ChatModerationDecision> review({
    String? text,
    List<String> attachmentPaths = const [],
  }) async {
    if (kDebugMode) {
      // ignore: avoid_print
      print('ChatModerationService remote: ${_remote.runtimeType}');
    }
    // OpenAI-only moderation (text + images/files).
    if (_remote != null) {
      try {
        final res = await _remote.review(
          text: text,
          attachmentPaths: attachmentPaths,
        );
        final allowed = res['allowed'];
        final reason = res['reason'];
        final severity = res['severity'];
        final blockedAttachments =
            res['blocked_attachments'] ?? res['blockedAttachments'];

        return ChatModerationDecision(
          allowed: allowed is bool ? allowed : true,
          reason: reason is String && reason.trim().isNotEmpty
              ? reason.trim()
              : null,
          severity: severity is num ? severity.toInt() : 0,
          blockedAttachmentNames: blockedAttachments is List
              ? blockedAttachments.whereType<String>().toList()
              : const [],
        );
      } catch (_) {
        if (kDebugMode) {
          // ignore: avoid_print
          print('ChatModerationService: remote moderation failed.');
        }
        return const ChatModerationDecision(
          allowed: false,
          reason:
              'تعذر تحليل المحتوى بالذكاء الاصطناعي. تحقق من الاتصال ومفتاح OpenAI.',
          severity: 10,
        );
      }
    }

    // No remote configured → fail-closed.
    return const ChatModerationDecision(
      allowed: false,
      reason: 'OpenAI moderation غير مُفعّل (مفتاح OPENAI_API_KEY غير موجود).',
      severity: 10,
    );
  }
}
