import 'package:masr_al_qsariya/features/sessions/data/models/live_session_summary_model.dart';
import 'package:masr_al_qsariya/features/sessions/domain/entities/live_sessions_list.dart';

class LiveSessionsListModel {
  const LiveSessionsListModel({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
  });

  final List<LiveSessionSummaryModel> items;
  final int currentPage;
  final int lastPage;
  final int total;
  final int perPage;

  factory LiveSessionsListModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    if (data is List) {
      final list = data
          .whereType<Map<String, dynamic>>()
          .map(LiveSessionSummaryModel.fromMap)
          .toList();
      return LiveSessionsListModel(
        items: list,
        currentPage: 1,
        lastPage: 1,
        total: list.length,
        perPage: list.length,
      );
    }

    if (data is Map<String, dynamic>) {
      final inner = data['data'];
      final listRaw = inner is List ? inner : const [];
      final list = listRaw
          .whereType<Map<String, dynamic>>()
          .map(LiveSessionSummaryModel.fromMap)
          .toList();

      final meta = data['meta'];
      final metaMap = meta is Map<String, dynamic> ? meta : <String, dynamic>{};

      return LiveSessionsListModel(
        items: list,
        currentPage: (metaMap['current_page'] as num?)?.toInt() ?? 1,
        lastPage: (metaMap['last_page'] as num?)?.toInt() ?? 1,
        total: (metaMap['total'] as num?)?.toInt() ?? list.length,
        perPage: (metaMap['per_page'] as num?)?.toInt() ?? list.length,
      );
    }

    return const LiveSessionsListModel(
      items: [],
      currentPage: 1,
      lastPage: 1,
      total: 0,
      perPage: 15,
    );
  }

  LiveSessionsList toEntity() => LiveSessionsList(
        items: items.map((e) => e.toEntity()).toList(),
        currentPage: currentPage,
        lastPage: lastPage,
        total: total,
        perPage: perPage,
      );
}
