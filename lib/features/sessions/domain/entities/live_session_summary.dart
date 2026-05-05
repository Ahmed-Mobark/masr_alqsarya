import 'package:equatable/equatable.dart';

class LiveSessionSummary extends Equatable {
  const LiveSessionSummary({
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
  /// Backend hint, e.g. `public` / `private` (optional).
  final String? visibility;

  @override
  List<Object?> get props => [
        id,
        title,
        status,
        personaId,
        isRecorded,
        mediatorName,
        mediatorTitle,
        mediatorRating,
        mediatorImageUrl,
        startsAt,
        durationMinutes,
        visibility,
      ];
}
