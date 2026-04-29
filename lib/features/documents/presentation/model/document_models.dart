import 'package:masr_al_qsariya/features/documents/domain/entities/uploaded_file.dart';

class DocumentFolder {
  final DocumentsFolderType type;
  final String title;
  final String createdAt;
  final String addedBy;
  final String access;
  final int filesCount;
  final String? lastUpdatedBy;
  final String? lastUpdatedAt;

  const DocumentFolder({
    required this.type,
    required this.title,
    required this.createdAt,
    required this.addedBy,
    required this.access,
    required this.filesCount,
    this.lastUpdatedBy,
    this.lastUpdatedAt,
  });
}

enum DocumentFilterTab { all, videos, photos, documents }

class FolderItem {
  final String title;
  final FolderItemType type;
  final UploadedFileEntity uploadedFile;

  const FolderItem({
    required this.title,
    required this.type,
    required this.uploadedFile,
  });
}

enum FolderItemType { video, photo, document }
