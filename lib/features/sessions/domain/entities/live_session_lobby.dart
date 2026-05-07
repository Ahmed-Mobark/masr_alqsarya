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
    this.isBooked,
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
  final bool? isBooked;
  final String recordingConsentDescription;
  final String recordingConsentAcknowledgement;

  LiveSessionLobby copyWith({
    int? id,
    String? mediatorName,
    String? mediatorTitle,
    String? mediatorRating,
    String? mediatorBio,
    String? mediatorImageUrl,
    DateTime? startsAt,
    int? durationMinutes,
    String? sessionLink,
    bool? isBooked,
    String? recordingConsentDescription,
    String? recordingConsentAcknowledgement,
  }) {
    return LiveSessionLobby(
      id: id ?? this.id,
      mediatorName: mediatorName ?? this.mediatorName,
      mediatorTitle: mediatorTitle ?? this.mediatorTitle,
      mediatorRating: mediatorRating ?? this.mediatorRating,
      mediatorBio: mediatorBio ?? this.mediatorBio,
      mediatorImageUrl: mediatorImageUrl ?? this.mediatorImageUrl,
      startsAt: startsAt ?? this.startsAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      sessionLink: sessionLink ?? this.sessionLink,
      isBooked: isBooked ?? this.isBooked,
      recordingConsentDescription:
          recordingConsentDescription ?? this.recordingConsentDescription,
      recordingConsentAcknowledgement: recordingConsentAcknowledgement ??
          this.recordingConsentAcknowledgement,
    );
  }

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
        isBooked,
        recordingConsentDescription,
        recordingConsentAcknowledgement,
      ];
}
