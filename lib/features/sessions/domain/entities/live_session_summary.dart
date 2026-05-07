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
    this.isBooked,
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
  final bool? isBooked;

  LiveSessionSummary copyWith({
    int? id,
    String? title,
    String? status,
    int? personaId,
    bool? isRecorded,
    String? mediatorName,
    String? mediatorTitle,
    String? mediatorRating,
    String? mediatorImageUrl,
    DateTime? startsAt,
    int? durationMinutes,
    String? visibility,
    bool? isBooked,
  }) {
    return LiveSessionSummary(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      personaId: personaId ?? this.personaId,
      isRecorded: isRecorded ?? this.isRecorded,
      mediatorName: mediatorName ?? this.mediatorName,
      mediatorTitle: mediatorTitle ?? this.mediatorTitle,
      mediatorRating: mediatorRating ?? this.mediatorRating,
      mediatorImageUrl: mediatorImageUrl ?? this.mediatorImageUrl,
      startsAt: startsAt ?? this.startsAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      visibility: visibility ?? this.visibility,
      isBooked: isBooked ?? this.isBooked,
    );
  }

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
    isBooked,
  ];
}
