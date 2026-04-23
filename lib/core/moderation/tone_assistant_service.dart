class ToneAssistantDecision {
  const ToneAssistantDecision({
    required this.shouldIntervene,
    this.warning,
    this.suggestedAlternative,
    this.score = 0,
  });

  final bool shouldIntervene;
  final String? warning;
  final String? suggestedAlternative;
  /// 0..100
  final int score;
}

/// Free “AI-like” tone assistant (on-device heuristic).
///
/// الهدف: تقليل التصعيد قبل الإرسال، وإظهار اقتراح بديل بصياغة ألطف.
class ToneAssistantService {
  const ToneAssistantService();

  ToneAssistantDecision review(String raw) {
    final text = raw.trim();
    if (text.isEmpty) {
      return const ToneAssistantDecision(shouldIntervene: false);
    }

    final normalized = _normalize(text);
    var score = 0;

    // Profanity / obscene words
    final hasProfanity = _profanity.any(normalized.contains);
    if (hasProfanity) score += 70;

    // Aggressive / conflict markers
    final hasAggression = _aggressive.any(normalized.contains);
    if (hasAggression) score += 35;

    // Excess punctuation / shouting
    if (RegExp(r'[!؟]{3,}').hasMatch(text)) score += 10;
    if (RegExp(r'[A-Z]{6,}').hasMatch(text)) score += 10;

    score = score.clamp(0, 100);
    final shouldIntervene = score >= 50;
    if (!shouldIntervene) {
      return ToneAssistantDecision(shouldIntervene: false, score: score);
    }

    final warning = 'هذه الرسالة قد تزيد التوتر. حاول صياغتها بلطف.';
    final suggestion = _suggestAlternative(text);
    return ToneAssistantDecision(
      shouldIntervene: true,
      warning: warning,
      suggestedAlternative: suggestion,
      score: score,
    );
  }

  String _suggestAlternative(String original) {
    // If the message includes direct blame/insults, propose a calm framing.
    return 'أنا حابب نتكلم بهدوء عشان نوصل لحل. '
        'ممكن نناقش الموضوع ده سوا ونشوف أفضل قرار؟';
  }
}

String _normalize(String input) {
  var s = input.toLowerCase();
  // Arabizi digits → Arabic-ish letters (best effort).
  s = s
      .replaceAll('7', 'ح')
      .replaceAll('3', 'ع')
      .replaceAll('5', 'خ')
      .replaceAll('2', 'ء');
  s = s
      .replaceAll('أ', 'ا')
      .replaceAll('إ', 'ا')
      .replaceAll('آ', 'ا')
      .replaceAll('ى', 'ي')
      .replaceAll('ة', 'ه');
  s = s.replaceAll(RegExp(r'[\s\-_.,;:!؟"''()\[\]{}]+'), '');
  s = s.replaceAll(RegExp(r'(.)\1{2,}'), r'$1$1');
  return s.trim();
}

const List<String> _profanity = [
  // Arabic
  'احا',
  'aحa', // catches a7a → aحa after mapping
  'كس',
  'كسم',
  'شرمو',
  'منيك',
  'متناك',
  'زب',
  'طيز',
  // English
  'fuck',
  'shit',
  'bitch',
  'asshole',
];

const List<String> _aggressive = [
  // Arabic
  'انتغبي',
  'غبي',
  'حمار',
  'كلب',
  'مابتفهمش',
  'اسكت',
  'اخرس',
  'بطل',
  'مشعاجبني',
  // English
  'you are difficult',
  'shut up',
  'idiot',
  'stupid',
];

