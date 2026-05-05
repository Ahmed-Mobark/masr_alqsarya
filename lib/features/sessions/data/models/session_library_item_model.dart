import 'package:masr_al_qsariya/features/sessions/data/models/live_session_parsing.dart';
import 'package:masr_al_qsariya/features/sessions/domain/entities/session_library_entry.dart';

String? _readWatchPlaybackUrl(Map<String, dynamic> json) {
  for (final key in const [
    'single_video_url',
    'singleVideoUrl',
    'playlist_url',
    'playlistUrl',
    'watch_url',
    'watchUrl',
    'playback_url',
    'playbackUrl',
    'video_url',
    'videoUrl',
    'url',
    'stream_url',
    'streamUrl',
  ]) {
    final v = json[key];
    if (v == null) continue;
    if (v is String) {
      final t = v.trim();
      if (t.isNotEmpty) return t;
    }
  }
  return null;
}

class SessionLibraryItemModel {
  const SessionLibraryItemModel({
    required this.id,
    required this.title,
    required this.libraryType,
    required this.durationLabel,
    this.expertName,
    this.participantsLine,
    this.archivedLine,
    this.thumbnailUrl,
    this.isLocked = false,
    this.watchUrl,
    this.expertPersonaId,
  });

  final int id;
  final String title;
  final String libraryType;
  final String durationLabel;
  final String? expertName;
  final String? participantsLine;
  final String? archivedLine;
  final String? thumbnailUrl;
  final bool isLocked;
  final String? watchUrl;
  final int? expertPersonaId;

  static String _formatDurationSeconds(int totalSeconds) {
    if (totalSeconds < 0) totalSeconds = 0;
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  factory SessionLibraryItemModel.fromMap(Map<String, dynamic> raw) {
    final json = Map<String, dynamic>.from(raw);

    final id = liveSessionReadInt(json, const ['id']) ?? 0;
    final title =
        liveSessionReadString(json, const ['title', 'name', 'topic']) ?? '';

    final libraryType =
        liveSessionReadString(json, const ['type', 'library_type', 'format']) ??
        '';

    final durationStr = liveSessionReadString(json, const [
      'duration_label',
      'duration_formatted',
      'duration_display',
    ]);

    final durationSecs = liveSessionReadInt(json, const [
      'duration_seconds',
      'length_seconds',
    ]);

    final durationLabel = (durationStr != null && durationStr.isNotEmpty)
        ? durationStr
        : (durationSecs != null
              ? _formatDurationSeconds(durationSecs)
              : '00:00');

    final persona = liveSessionMediatorOrPersona(json);
    final expertName =
        liveSessionReadString(persona, const ['name', 'full_name']) ??
        liveSessionReadString(json, const [
          'expert_name',
          'host_name',
          'mediator_name',
        ]);

    String? participantsLine = liveSessionReadString(json, const [
      'participants_label',
      'participants',
      'families_label',
    ]);
    if (participantsLine == null) {
      final n = liveSessionReadInt(json, const [
        'families_count',
        'participants_count',
      ]);
      if (n != null) participantsLine = n.toString();
    }

    final archivedRaw = liveSessionReadString(json, const [
      'published_at',
      'publishedAt',
      'archived_at',
      'archived_at_human',
      'archived_on',
    ]);

    final thumbnailUrl = liveSessionReadString(json, const [
      'featured_image_url',
      'featuredImageUrl',
      'thumbnail_url',
      'cover_url',
      'cover_image_url',
      'poster_url',
      'image_url',
    ]);

    final isLocked =
        liveSessionReadBool(json, const [
          'is_locked',
          'locked',
          'access_locked',
        ]) ??
        false;

    final watchUrl = _readWatchPlaybackUrl(json);

    final expertPersonaId = liveSessionReadInt(json, const [
      'expert_persona_id',
      'expertPersonaId',
    ]);

    return SessionLibraryItemModel(
      id: id,
      title: title,
      libraryType: libraryType,
      durationLabel: durationLabel,
      expertName: expertName,
      participantsLine: participantsLine,
      archivedLine: archivedRaw,
      thumbnailUrl: thumbnailUrl,
      isLocked: isLocked,
      watchUrl: watchUrl,
      expertPersonaId: expertPersonaId,
    );
  }

  SessionLibraryEntry toEntity() => SessionLibraryEntry(
    id: id,
    title: title,
    libraryType: libraryType,
    durationLabel: durationLabel,
    expertName: expertName,
    participantsLine: participantsLine,
    archivedLine: archivedLine,
    thumbnailUrl: thumbnailUrl,
        isLocked: isLocked,
        watchUrl: watchUrl,
        expertPersonaId: expertPersonaId,
      );
}
