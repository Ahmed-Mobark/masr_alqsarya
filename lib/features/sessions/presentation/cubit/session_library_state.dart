import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/features/sessions/domain/entities/session_library_entry.dart';
import 'package:masr_al_qsariya/features/sessions/presentation/cubit/session_library_filters.dart';

enum SessionLibraryStatus { initial, loading, success, failure }

class SessionLibraryState extends Equatable {
  const SessionLibraryState({
    this.status = SessionLibraryStatus.initial,
    this.items = const [],
    this.error,
    this.searchQuery = '',
    this.categoryIndex = 0,
    this.currentPage = 1,
    this.lastPage = 1,
    this.filters = const SessionLibraryFilters(),
    this.expertFilterChoices = const {},
  });

  final SessionLibraryStatus status;
  final List<SessionLibraryEntry> items;
  final String? error;
  final String searchQuery;

  /// 0 = all types, 1 = `single_video`, 2 = `playlist` (matches API `type`).
  final int categoryIndex;
  final int currentPage;
  final int lastPage;
  final SessionLibraryFilters filters;

  /// Expert id → display name, merged from successful list responses.
  final Map<int, String> expertFilterChoices;

  String? get typeQuery {
    switch (categoryIndex) {
      case 1:
        return 'single_video';
      case 2:
        return 'playlist';
      default:
        return null;
    }
  }

  SessionLibraryState copyWith({
    SessionLibraryStatus? status,
    List<SessionLibraryEntry>? items,
    String? error,
    String? searchQuery,
    int? categoryIndex,
    int? currentPage,
    int? lastPage,
    SessionLibraryFilters? filters,
    Map<int, String>? expertFilterChoices,
    bool clearError = false,
  }) {
    return SessionLibraryState(
      status: status ?? this.status,
      items: items ?? this.items,
      error: clearError ? null : error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
      categoryIndex: categoryIndex ?? this.categoryIndex,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      filters: filters ?? this.filters,
      expertFilterChoices: expertFilterChoices ?? this.expertFilterChoices,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    error,
    searchQuery,
    categoryIndex,
    currentPage,
    lastPage,
    filters,
    expertFilterChoices,
  ];
}
