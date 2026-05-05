import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/features/sessions/domain/entities/session_library_entry.dart';
import 'package:masr_al_qsariya/features/sessions/domain/usecases/get_session_library_usecase.dart';
import 'package:masr_al_qsariya/features/sessions/presentation/cubit/session_library_filters.dart';
import 'package:masr_al_qsariya/features/sessions/presentation/cubit/session_library_state.dart';

class SessionLibraryCubit extends Cubit<SessionLibraryState> {
  SessionLibraryCubit(this._getSessionLibrary) : super(const SessionLibraryState());

  final GetSessionLibraryUseCase _getSessionLibrary;
  Timer? _searchDebounce;

  static Map<int, String> _mergeExpertChoices(
    Map<int, String> prev,
    List<SessionLibraryEntry> items,
  ) {
    final m = Map<int, String>.from(prev);
    for (final e in items) {
      final id = e.expertPersonaId;
      final name = e.expertName?.trim();
      if (id != null && name != null && name.isNotEmpty) {
        m[id] = name;
      }
    }
    final sorted = m.entries.toList()
      ..sort((a, b) => a.value.toLowerCase().compareTo(b.value.toLowerCase()));
    return Map<int, String>.fromEntries(sorted);
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  void setCategoryIndex(int index) {
    if (index == state.categoryIndex) return;
    emit(state.copyWith(categoryIndex: index));
    load();
  }

  void onSearchChanged(String value) {
    emit(state.copyWith(searchQuery: value));
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 450), load);
  }

  void clearSearch() {
    _searchDebounce?.cancel();
    emit(state.copyWith(searchQuery: ''));
    load();
  }

  void applyFilterSheet({
    required SessionLibraryFilters filters,
  }) {
    emit(state.copyWith(filters: filters));
    load();
  }

  void resetFilterSheet() {
    emit(state.copyWith(filters: const SessionLibraryFilters()));
    load();
  }

  Future<void> load() async {
    emit(
      state.copyWith(
        status: SessionLibraryStatus.loading,
        clearError: true,
      ),
    );

    final trimmed = state.searchQuery.trim();
    final f = state.filters;
    final result = await _getSessionLibrary(
      GetSessionLibraryParams(
        search: trimmed.isEmpty ? null : trimmed,
        expertPersonaId: f.expertPersonaId,
        type: state.typeQuery,
        page: 1,
        perPage: f.perPage,
        sortDirection: f.sortDirection,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SessionLibraryStatus.failure,
          error: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          status: SessionLibraryStatus.success,
          items: data.items,
          currentPage: data.currentPage,
          lastPage: data.lastPage,
          expertFilterChoices: _mergeExpertChoices(
            state.expertFilterChoices,
            data.items,
          ),
        ),
      ),
    );
  }
}
