import 'package:masr_al_qsariya/features/sessions/data/models/session_library_item_model.dart';
import 'package:masr_al_qsariya/features/sessions/domain/entities/session_library_list.dart';

class SessionLibraryListModel {
  const SessionLibraryListModel({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
  });

  final List<SessionLibraryItemModel> items;
  final int currentPage;
  final int lastPage;
  final int total;
  final int perPage;

  factory SessionLibraryListModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    if (data is List) {
      final list = _parseLibraryItems(data);
      return SessionLibraryListModel(
        items: list,
        currentPage: 1,
        lastPage: 1,
        total: list.length,
        perPage: list.length,
      );
    }

    if (data is Map) {
      final dataMap = Map<String, dynamic>.from(data);
      final inner = dataMap['data'];
      final list = _parseLibraryItems(inner is List ? inner : const []);

      final meta = dataMap['meta'];
      final metaMap =
          meta is Map ? Map<String, dynamic>.from(meta) : <String, dynamic>{};

      return SessionLibraryListModel(
        items: list,
        currentPage: (metaMap['current_page'] as num?)?.toInt() ?? 1,
        lastPage: (metaMap['last_page'] as num?)?.toInt() ?? 1,
        total: (metaMap['total'] as num?)?.toInt() ?? list.length,
        perPage: (metaMap['per_page'] as num?)?.toInt() ?? list.length,
      );
    }

    return const SessionLibraryListModel(
      items: [],
      currentPage: 1,
      lastPage: 1,
      total: 0,
      perPage: 15,
    );
  }

  static List<SessionLibraryItemModel> _parseLibraryItems(List<dynamic> raw) {
    return raw
        .map((e) {
          if (e is! Map) return null;
          return SessionLibraryItemModel.fromMap(
            Map<String, dynamic>.from(e),
          );
        })
        .whereType<SessionLibraryItemModel>()
        .toList();
  }

  SessionLibraryList toEntity() => SessionLibraryList(
        items: items.map((e) => e.toEntity()).toList(),
        currentPage: currentPage,
        lastPage: lastPage,
        total: total,
        perPage: perPage,
      );
}
