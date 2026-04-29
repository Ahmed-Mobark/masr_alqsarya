import 'package:masr_al_qsariya/features/documents/domain/entities/file_activity.dart';

class FileActivityModel extends FileActivityEntity {
  const FileActivityModel({
    required super.id,
    required super.action,
    required super.actor,
    super.metadata,
    required super.createdAt,
  });

  factory FileActivityModel.fromJson(Map<String, dynamic> json) {
    return FileActivityModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      action: (json['action'] as String?) ?? '',
      actor: FileActivityActorModel.fromJson(
        json['actor'] as Map<String, dynamic>? ?? {},
      ),
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: (json['created_at'] as String?) ?? '',
    );
  }

  FileActivityEntity toEntity() {
    return FileActivityEntity(
      id: id,
      action: action,
      actor: actor,
      metadata: metadata,
      createdAt: createdAt,
    );
  }
}

class FileActivityActorModel extends FileActivityActorEntity {
  const FileActivityActorModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory FileActivityActorModel.fromJson(Map<String, dynamic> json) {
    return FileActivityActorModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
    );
  }
}
