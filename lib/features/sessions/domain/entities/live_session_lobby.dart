import 'package:equatable/equatable.dart';

class LiveSessionLobby extends Equatable {
  const LiveSessionLobby({
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

  @override
  List<Object?> get props => [
        id,
        mediatorName,
        mediatorTitle,
        mediatorRating,
        mediatorBio,
        mediatorImageUrl,
        startsAt,
        durationMinutes,
        sessionLink,
        recordingConsentDescription,
        recordingConsentAcknowledgement,
      ];
}
