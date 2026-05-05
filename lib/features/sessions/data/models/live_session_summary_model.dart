import 'package:masr_al_qsariya/features/sessions/data/models/live_session_parsing.dart';
import 'package:masr_al_qsariya/features/sessions/domain/entities/live_session_summary.dart';

class LiveSessionSummaryModel {
  const LiveSessionSummaryModel({
    required this.id,
    required this.title,
    required this.status,
    this.personaId,
    this.isRecorded,
    required this.mediatorName,
    required this.mediatorTitle,
    required this.mediatorRating,
    this.mediatorImageUrl,
    this.startsAt,
    this.durationMinutes,
    this.visibility,
  });

  final int id;
  final String title;
  final String status;
  final int? personaId;
  final bool? isRecorded;
  final String mediatorName;
  final String mediatorTitle;
  final String mediatorRating;
  final String? mediatorImageUrl;
  final DateTime? startsAt;
  final int? durationMinutes;
  final String? visibility;

  factory LiveSessionSummaryModel.fromMap(Map<String, dynamic> json) {
    final root = Map<String, dynamic>.from(json);
    final m = liveSessionMediatorOrPersona(root);

    final name = liveSessionReadString(m, const [
          'name',
          'full_name',
          'display_name',
        ]) ??
        liveSessionReadString(root, const [
          'mediator_name',
          'host_name',
        ]) ??
        '';

    final sessionTitle = liveSessionReadString(root, const [
          'title',
          'topic',
          'name',
        ]) ??
        '';

    final role = liveSessionReadString(m, const [
          'title',
          'role',
          'headline',
          'specialty',
        ]) ??
        liveSessionReadString(root, const [
          'mediator_title',
          'host_title',
        ]) ??
        '';

    final rating = liveSessionReadString(m, const [
          'rating',
          'average_rating',
        ]) ??
        liveSessionReadString(root, const ['mediator_rating']) ??
        '';

    final image = liveSessionReadString(root, const [
          'cover_image_url',
          'coverImageUrl',
        ]) ??
        liveSessionReadString(m, const [
          'avatar',
          'image',
          'photo_url',
          'avatar_url',
          'profile_image_url',
        ]) ??
        liveSessionReadString(root, const [
          'mediator_image_url',
          'host_image_url',
        ]);

    final id = liveSessionReadInt(root, const ['id']) ?? 0;
    final status = liveSessionReadString(root, const ['status']) ?? '';
    final visibility = liveSessionReadString(root, const [
      'visibility',
      'session_type',
      'type',
    ]);

    return LiveSessionSummaryModel(
      id: id,
      title: sessionTitle,
      status: status,
      personaId: liveSessionReadInt(root, const ['persona_id']),
      isRecorded: liveSessionReadBool(root, const ['is_recorded', 'isRecorded']),
      mediatorName: name,
      mediatorTitle: role,
      mediatorRating: rating,
      mediatorImageUrl: image,
      startsAt: liveSessionParseStartDateTime(root) ??
          liveSessionReadDateTime(root, const [
            'starts_at',
            'start_at',
            'scheduled_at',
            'startsAt',
          ]),
      durationMinutes: liveSessionReadInt(root, const [
        'duration_minutes',
        'duration',
      ]),
      visibility: visibility,
    );
  }

  LiveSessionSummary toEntity() => LiveSessionSummary(
        id: id,
        title: title,
        status: status,
        personaId: personaId,
        isRecorded: isRecorded,
        mediatorName: mediatorName,
        mediatorTitle: mediatorTitle,
        mediatorRating: mediatorRating,
        mediatorImageUrl: mediatorImageUrl,
        startsAt: startsAt,
        durationMinutes: durationMinutes,
        visibility: visibility,
      );
}
