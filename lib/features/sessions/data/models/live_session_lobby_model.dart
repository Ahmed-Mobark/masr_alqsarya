import 'package:masr_al_qsariya/features/sessions/data/models/live_session_parsing.dart';
import 'package:masr_al_qsariya/features/sessions/data/models/live_session_summary_model.dart';
import 'package:masr_al_qsariya/features/sessions/domain/entities/live_session_lobby.dart';

class LiveSessionLobbyModel {
  const LiveSessionLobbyModel({
    required this.id,
    required this.mediatorName,
    required this.mediatorTitle,
    required this.mediatorRating,
    required this.mediatorBio,
    this.mediatorImageUrl,
    this.startsAt,
    this.durationMinutes,
    this.sessionLink,
    required this.recordingConsentDescription,
    required this.recordingConsentAcknowledgement,
  });

  final int id;
  final String mediatorName;
  final String mediatorTitle;
  final String mediatorRating;
  final String mediatorBio;
  final String? mediatorImageUrl;
  final DateTime? startsAt;
  final int? durationMinutes;
  final String? sessionLink;
  final String recordingConsentDescription;
  final String recordingConsentAcknowledgement;

  factory LiveSessionLobbyModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final root = data is Map<String, dynamic> ? data : json;
    return LiveSessionLobbyModel.fromMap(root);
  }

  factory LiveSessionLobbyModel.fromMap(Map<String, dynamic> json) {
    final summary = LiveSessionSummaryModel.fromMap(json);
    final m = liveSessionMediatorOrPersona(json);

    final bio = liveSessionReadString(m, const [
          'bio',
          'about',
        ]) ??
        liveSessionReadString(json, const [
          'description',
          'mediator_bio',
          'host_bio',
        ]) ??
        '';

    final recording = liveSessionReadString(json, const [
          'recording_consent_message',
          'recording_consent_description',
          'recording_policy',
          'recording_notice',
        ]) ??
        '';

    final acknowledgement = liveSessionReadString(json, const [
          'recording_consent_acknowledgement',
          'recording_consent_label',
          'consent_acknowledgement',
        ]) ??
        '';

    final displayTitle = summary.mediatorTitle.trim().isNotEmpty
        ? summary.mediatorTitle
        : summary.title.trim();

    final link = liveSessionReadString(json, const [
      'session_link',
      'sessionLink',
      'join_url',
      'joinUrl',
    ]);

    return LiveSessionLobbyModel(
      id: summary.id,
      mediatorName: summary.mediatorName,
      mediatorTitle: displayTitle,
      mediatorRating: summary.mediatorRating,
      mediatorBio: bio,
      mediatorImageUrl: summary.mediatorImageUrl,
      startsAt: summary.startsAt,
      durationMinutes: summary.durationMinutes,
      sessionLink: link,
      recordingConsentDescription: recording,
      recordingConsentAcknowledgement: acknowledgement,
    );
  }

  LiveSessionLobby toEntity() => LiveSessionLobby(
        id: id,
        mediatorName: mediatorName,
        mediatorTitle: mediatorTitle,
        mediatorRating: mediatorRating,
        mediatorBio: mediatorBio,
        mediatorImageUrl: mediatorImageUrl,
        startsAt: startsAt,
        durationMinutes: durationMinutes,
        sessionLink: sessionLink,
        recordingConsentDescription: recordingConsentDescription,
        recordingConsentAcknowledgement: recordingConsentAcknowledgement,
      );
}
