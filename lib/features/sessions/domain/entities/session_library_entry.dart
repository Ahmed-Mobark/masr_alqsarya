import 'package:equatable/equatable.dart';

class SessionLibraryEntry extends Equatable {
  const SessionLibraryEntry({
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
  /// Raw API `type`, e.g. `single_video`, `playlist`.
  final String libraryType;
  final String durationLabel;
  final String? expertName;
  final String? participantsLine;
  final String? archivedLine;
  final String? thumbnailUrl;
  final bool isLocked;
  final String? watchUrl;
  /// Matches API `expert_persona_id` (for filters).
  final int? expertPersonaId;

  @override
  List<Object?> get props => [
        id,
        title,
        libraryType,
        durationLabel,
        expertName,
        participantsLine,
        archivedLine,
        thumbnailUrl,
        isLocked,
        watchUrl,
        expertPersonaId,
      ];
}
