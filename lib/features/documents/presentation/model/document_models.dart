class DocumentFolder {
  final String title;
  final String createdAt;
  final String addedBy;
  final String access;
  final String? lastUpdatedBy;
  final String? lastUpdatedAt;

  const DocumentFolder({
    required this.title,
    required this.createdAt,
    required this.addedBy,
    required this.access,
    this.lastUpdatedBy,
    this.lastUpdatedAt,
  });
}

enum DocumentFilterTab { all, videos, photos, documents }

class FolderItem {
  final String title;
  final FolderItemType type;

  const FolderItem({required this.title, required this.type});
}

enum FolderItemType { video, photo, document }

