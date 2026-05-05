import 'package:equatable/equatable.dart';

/// Mirrors `GET session-library` filter query params (subset shown in UI).
class SessionLibraryFilters extends Equatable {
  const SessionLibraryFilters({
    this.expertPersonaId,
    this.sortDirection = 'desc',
    this.perPage = 15,
  });

  final int? expertPersonaId;
  /// API `sort_direction`: `asc` | `desc`.
  final String sortDirection;
  final int perPage;

  /// True when sheet filters differ from defaults (filter icon badge).
  bool get hasActiveCustomizations =>
      expertPersonaId != null ||
      sortDirection != 'desc' ||
      perPage != 15;

  @override
  List<Object?> get props => [expertPersonaId, sortDirection, perPage];
}
