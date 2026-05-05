import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/features/sessions/domain/entities/session_library_entry.dart';

class SessionLibraryList extends Equatable {
  const SessionLibraryList({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
  });

  final List<SessionLibraryEntry> items;
  final int currentPage;
  final int lastPage;
  final int total;
  final int perPage;

  bool get hasMore => currentPage < lastPage;

  @override
  List<Object?> get props => [items, currentPage, lastPage, total, perPage];
}
