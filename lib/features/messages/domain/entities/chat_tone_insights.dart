import 'package:equatable/equatable.dart';

enum ChatToneActivityKind { alert, correction, info, unknown }

class ChatToneActivity extends Equatable {
  const ChatToneActivity({
    required this.kind,
    required this.title,
    required this.snippet,
    this.occurredAt,
  });

  final ChatToneActivityKind kind;
  final String title;
  final String snippet;
  final DateTime? occurredAt;

  @override
  List<Object?> get props => [kind, title, snippet, occurredAt];
}

class ChatToneInsights extends Equatable {
  const ChatToneInsights({
    required this.overallScore,
    required this.barProgress,
    required this.toneLabel,
    required this.healthLabel,
    required this.qualityLabel,
    required this.summary,
    required this.activities,
  });

  /// 0.0–1.0 for the circular gauge.
  final double overallScore;

  /// 0.0–1.0 for the linear bar under labels.
  final double barProgress;

  /// Short label under the gauge (e.g. calm / neutral); may be empty to use ARB fallback.
  final String toneLabel;

  /// Secondary status (e.g. healthy); may be empty.
  final String healthLabel;

  /// Label inside/near the gauge (e.g. optimal); may be empty to use ARB fallback.
  final String qualityLabel;

  final String summary;

  final List<ChatToneActivity> activities;

  @override
  List<Object?> get props => [
        overallScore,
        barProgress,
        toneLabel,
        healthLabel,
        qualityLabel,
        summary,
        activities,
      ];
}
