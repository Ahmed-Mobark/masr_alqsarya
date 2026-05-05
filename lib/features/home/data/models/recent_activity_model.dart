import 'package:masr_al_qsariya/features/home/domain/entities/recent_activity.dart';

class RecentActivityModel {
  const RecentActivityModel({
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

  factory RecentActivityModel.fromJson(Map<String, dynamic> json) {
    final root = Map<String, dynamic>.from(json);
    final itemRaw = root['item'];
    final item = itemRaw is Map<String, dynamic>
        ? itemRaw
        : (itemRaw is Map ? Map<String, dynamic>.from(itemRaw) : <String, dynamic>{});

    final kind = _readString(root, const ['kind']) ?? '';
    final title = _readString(item, const ['title']) ?? '';
    final occurredAt = _readString(root, const ['occurred_at']) ?? '';
    final description = _readString(item, const ['description', 'content']) ?? '';
    final itemId = _readInt(item, const ['id']);
    final liveSessionId = _readInt(item, const ['live_session_id']);
    final sessionLink = _readString(item, const ['session_link']);
    final singleVideoUrl = _readString(item, const ['single_video_url']);

    final persona = _readMap(item, const ['persona', 'expert_persona']);
    final personaName = _readString(persona, const ['name']);
    final imageUrl = _readString(item, const ['cover_image_url', 'featured_image_url']);

    return RecentActivityModel(
      kind: kind,
      occurredAt: occurredAt,
      title: title,
      description: description,
      itemId: itemId,
      liveSessionId: liveSessionId,
      sessionLink: sessionLink,
      singleVideoUrl: singleVideoUrl,
      personaName: personaName,
      imageUrl: imageUrl,
      actionLabel: null,
    );
  }

  RecentActivity toEntity() => RecentActivity(
        kind: kind,
        occurredAt: occurredAt,
        title: title,
        description: description,
        itemId: itemId,
        liveSessionId: liveSessionId,
        sessionLink: sessionLink,
        singleVideoUrl: singleVideoUrl,
        personaName: personaName,
        imageUrl: imageUrl,
        actionLabel: actionLabel,
      );

  static String? _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return null;
  }

  static Map<String, dynamic> _readMap(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is Map<String, dynamic>) return value;
      if (value is Map) return Map<String, dynamic>.from(value);
    }
    return <String, dynamic>{};
  }

  static int? _readInt(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) {
        final parsed = int.tryParse(value);
        if (parsed != null) return parsed;
      }
    }
    return null;
  }
}
