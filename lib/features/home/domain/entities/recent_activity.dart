import 'package:equatable/equatable.dart';

class RecentActivity extends Equatable {
  const RecentActivity({
    required this.kind,
    required this.occurredAt,
    required this.title,
    required this.description,
    this.itemId,
    this.liveSessionId,
    this.sessionLink,
    this.singleVideoUrl,
    this.personaName,
    this.imageUrl,
    this.actionLabel,
  });

  final String kind;
  final String occurredAt;
  final String title;
  final String description;
  final int? itemId;
  final int? liveSessionId;
  final String? sessionLink;
  final String? singleVideoUrl;
  final String? personaName;
  final String? imageUrl;
  final String? actionLabel;

  @override
  List<Object?> get props => [
        kind,
        occurredAt,
        title,
        description,
        itemId,
        liveSessionId,
        sessionLink,
        singleVideoUrl,
        personaName,
        imageUrl,
        actionLabel,
      ];
}
