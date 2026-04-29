import 'package:masr_al_qsariya/features/documents/domain/entities/uploaded_file.dart';

class UploadedFileModel extends UploadedFileEntity {
  const UploadedFileModel({
    required super.id,
    required super.sourceType,
    required super.relatedId,
    required super.originalName,
    required super.mimeType,
    required super.size,
    required super.url,
    required super.createdAt,
  });

  factory UploadedFileModel.fromJson(Map<String, dynamic> json) {
    return UploadedFileModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      sourceType: (json['source_type'] as String?) ?? '',
      relatedId: (json['related_id'] as num?)?.toInt() ?? 0,
      originalName: (json['original_name'] as String?) ?? '',
      mimeType: (json['mime_type'] as String?) ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
      url: (json['url'] as String?) ?? '',
      createdAt: (json['created_at'] as String?) ?? '',
    );
  }

  UploadedFileEntity toEntity() {
    return UploadedFileEntity(
      id: id,
      sourceType: sourceType,
      relatedId: relatedId,
      originalName: originalName,
      mimeType: mimeType,
      size: size,
      url: url,
      createdAt: createdAt,
    );
  }
}
