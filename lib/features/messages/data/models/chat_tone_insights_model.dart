import 'package:masr_al_qsariya/features/messages/domain/entities/chat_tone_insights.dart';

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }
  return {};
}

String _str(dynamic v) {
  if (v == null) return '';
  if (v is String) return v.trim();
  return v.toString();
}

double _normScore(dynamic v) {
  if (v == null) return 0;
  if (v is num) {
    final x = v.toDouble();
    if (x <= 0) return 0;
    if (x <= 1) return x.clamp(0, 1);
    return (x / 100).clamp(0, 1);
  }
  return 0;
}

DateTime? _parseDate(dynamic v) {
  if (v == null) return null;
  if (v is int) {
    if (v > 2000000000000) return DateTime.fromMillisecondsSinceEpoch(v, isUtc: true);
    if (v > 1000000000) return DateTime.fromMillisecondsSinceEpoch(v * 1000, isUtc: true);
  }
  final s = _str(v);
  if (s.isEmpty) return null;
  return DateTime.tryParse(s);
}

ChatToneActivityKind _kindFromType(String raw) {
  final t = raw.toLowerCase();
  if (t.contains('correct') ||
      t.contains('success') ||
      t.contains('applied') ||
      t.contains('resolved') ||
      t == 'positive') {
    return ChatToneActivityKind.correction;
  }
  if (t.contains('alert') ||
      t.contains('warn') ||
      t.contains('negative') ||
      t.contains('flag') ||
      t.contains('risk') ||
      t.contains('escalat')) {
    return ChatToneActivityKind.alert;
  }
  if (t.contains('info') || t.contains('note')) {
    return ChatToneActivityKind.info;
  }
  return ChatToneActivityKind.unknown;
}

class ChatToneInsightsModel {
  const ChatToneInsightsModel({
    required this.overallScore,
    required this.barProgress,
    required this.toneLabel,
    required this.healthLabel,
    required this.qualityLabel,
    required this.summary,
    required this.activities,
  });

  final double overallScore;
  final double barProgress;
  final String toneLabel;
  final String healthLabel;
  final String qualityLabel;
  final String summary;
  final List<ChatToneActivityModel> activities;

  factory ChatToneInsightsModel.fromResponse(Map<String, dynamic> json) {
    final root = _asMap(json['data']);
    final payload = root.isNotEmpty ? root : json;

    final score = _firstNum(payload, const [
      'overall_score',
      'tone_score',
      'score',
      'percentage',
      'health_score',
    ]);

    final bar = _firstNum(payload, const [
      'bar_progress',
      'linear_progress',
      'progress',
      'health_progress',
      'tone_progress',
    ]);

    final toneLabel = _firstStr(payload, const [
      'tone_label',
      'calm_label',
      'secondary_label',
      'mood_label',
    ]);

    final healthLabel = _firstStr(payload, const [
      'health_label',
      'label',
      'status_label',
      'health_status',
    ]);

    final qualityLabel = _firstStr(payload, const [
      'quality_label',
      'score_label',
      'badge_label',
      'optimal_label',
      'rating_label',
    ]);

    final summary = _firstStr(payload, const [
      'summary',
      'description',
      'overview',
      'narrative',
      'analysis',
    ]);

    final rawList = _activityList(payload);
    final activities = rawList.map(ChatToneActivityModel.fromMap).toList();

    final overall = _normScore(score);
    var barVal = _normScore(bar);
    if (barVal <= 0 && overall > 0) barVal = overall;

    return ChatToneInsightsModel(
      overallScore: overall,
      barProgress: barVal,
      toneLabel: toneLabel,
      healthLabel: healthLabel,
      qualityLabel: qualityLabel,
      summary: summary,
      activities: activities,
    );
  }

  ChatToneInsights toEntity() => ChatToneInsights(
        overallScore: overallScore,
        barProgress: barProgress,
        toneLabel: toneLabel,
        healthLabel: healthLabel,
        qualityLabel: qualityLabel,
        summary: summary,
        activities: activities.map((e) => e.toEntity()).toList(),
      );

  static dynamic _firstNum(Map<String, dynamic> m, List<String> keys) {
    for (final k in keys) {
      final v = m[k];
      if (v != null) return v;
    }
    return null;
  }

  static String _firstStr(Map<String, dynamic> m, List<String> keys) {
    for (final k in keys) {
      final v = m[k];
      final s = _str(v);
      if (s.isNotEmpty) return s;
    }
    return '';
  }

  static List<Map<String, dynamic>> _activityList(Map<String, dynamic> m) {
    for (final key in const [
      'recent_activities',
      'activities',
      'alerts',
      'events',
      'items',
    ]) {
      final v = m[key];
      if (v is List) {
        return v.map(_asMap).where((e) => e.isNotEmpty).toList();
      }
    }
    return const [];
  }
}

class ChatToneActivityModel {
  const ChatToneActivityModel({
    required this.kind,
    required this.title,
    required this.snippet,
    this.occurredAt,
  });

  final ChatToneActivityKind kind;
  final String title;
  final String snippet;
  final DateTime? occurredAt;

  factory ChatToneActivityModel.fromMap(Map<String, dynamic> m) {
    final typeRaw = _firstStr(m, const ['type', 'event_type', 'severity', 'category', 'kind']);
    final title = _firstStr(m, const ['title', 'name', 'headline', 'label', 'subject']);
    final snippet = _firstStr(m, const [
      'snippet',
      'message',
      'preview',
      'body',
      'description',
      'excerpt',
      'text',
    ]);
    final at = _firstDynamic(m, const ['created_at', 'occurred_at', 'at', 'timestamp', 'date']);
    return ChatToneActivityModel(
      kind: typeRaw.isEmpty ? ChatToneActivityKind.unknown : _kindFromType(typeRaw),
      title: title,
      snippet: snippet,
      occurredAt: _parseDate(at),
    );
  }

  ChatToneActivity toEntity() => ChatToneActivity(
        kind: kind,
        title: title,
        snippet: snippet,
        occurredAt: occurredAt,
      );

  static String _firstStr(Map<String, dynamic> m, List<String> keys) {
    for (final k in keys) {
      final s = _str(m[k]);
      if (s.isNotEmpty) return s;
    }
    return '';
  }

  static dynamic _firstDynamic(Map<String, dynamic> m, List<String> keys) {
    for (final k in keys) {
      final v = m[k];
      if (v != null) return v;
    }
    return null;
  }
}
