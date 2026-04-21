import 'package:masr_al_qsariya/features/auth/domain/entities/workspace.dart';

class WorkspaceModel {
  const WorkspaceModel({
    this.id,
    this.name,
    this.type,
    this.data,
  });

  final int? id;
  final String? name;
  final String? type;
  final Map<String, dynamic>? data;

  static int? _parseId(dynamic raw) {
    if (raw == null) return null;
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    if (raw is String) return int.tryParse(raw);
    return null;
  }

  factory WorkspaceModel.fromJson(Map<String, dynamic> json) {
    final payload = json['data'];
    final Map<String, dynamic> dataMap;

    if (payload is List && payload.isNotEmpty) {
      final first = payload.first;
      dataMap = first is Map<String, dynamic> ? first : <String, dynamic>{};
    } else if (payload is Map<String, dynamic>) {
      dataMap = payload;
    } else {
      dataMap = <String, dynamic>{};
    }

    return WorkspaceModel(
      id: _parseId(dataMap['id']),
      name: dataMap['name'] as String?,
      type: dataMap['type'] as String?,
      data: dataMap.isEmpty ? null : dataMap,
    );
  }

  Workspace toEntity() => Workspace(
        id: id,
        name: name,
        type: type,
        data: data,
      );
}
