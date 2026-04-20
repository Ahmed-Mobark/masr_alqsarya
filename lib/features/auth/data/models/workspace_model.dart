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

  factory WorkspaceModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final dataMap = data is Map<String, dynamic> ? data : <String, dynamic>{};

    return WorkspaceModel(
      id: dataMap['id'] as int?,
      name: dataMap['name'] as String?,
      type: dataMap['type'] as String?,
      data: dataMap,
    );
  }

  Workspace toEntity() => Workspace(
        id: id,
        name: name,
        type: type,
        data: data,
      );
}
