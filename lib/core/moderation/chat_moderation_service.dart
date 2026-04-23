import 'dart:math';

class ChatModerationDecision {
  const ChatModerationDecision({
    required this.allowed,
    this.reason,
    this.severity = 0,
  });

  final bool allowed;
  final String? reason;
  /// 0..10
  final int severity;
}

/// Local “AI-like” moderation. Fast, offline, and deterministic.
///
/// Swap this later with a real backend/LLM moderation API if needed.
class ChatModerationService {
  const ChatModerationService();

  ChatModerationDecision review(String text) {
    final cleaned = _normalize(text);
    if (cleaned.isEmpty) {
      return const ChatModerationDecision(allowed: true);
    }

    final hits = <String>[];
    for (final w in _blockedWords) {
      if (cleaned.contains(w)) hits.add(w);
    }
    if (hits.isEmpty) {
      return const ChatModerationDecision(allowed: true);
    }

    final severity = min(10, 3 + hits.length * 2);
    return ChatModerationDecision(
      allowed: false,
      severity: severity,
      reason: 'محتوى غير لائق. يرجى تعديل الرسالة.',
    );
  }
}

String _normalize(String input) {
  var s = input.toLowerCase();
  // Arabic normalization (very light)
  s = s
      .replaceAll('أ', 'ا')
      .replaceAll('إ', 'ا')
      .replaceAll('آ', 'ا')
      .replaceAll('ى', 'ي')
      .replaceAll('ة', 'ه');
  // Remove common punctuation/spaces
  s = s.replaceAll(RegExp(r'[\s\-_.,;:!؟"''()\[\]{}]+'), '');
  // Collapse repeated characters (e.g., “سسسس”)
  s = s.replaceAll(RegExp(r'(.)\1{2,}'), r'$1$1');
  return s.trim();
}

/// Minimal list – extend as needed.
const List<String> _blockedWords = [
  // Arabic (obfuscated forms will still often match after normalization)
  'كس',
  'كسم',
  'شرمو',
  'منيك',
  'خول',
  'عرص',
  'كلب',
  'حمار',
  // English
  'fuck',
  'shit',
  'bitch',
  'asshole',
];

