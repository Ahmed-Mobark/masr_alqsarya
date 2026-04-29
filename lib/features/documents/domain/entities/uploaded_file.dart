import 'package:equatable/equatable.dart';

enum DocumentsFolderType { chats, calls, invoices }

extension DocumentsFolderTypeX on DocumentsFolderType {
  String get sourceType => switch (this) {
    DocumentsFolderType.chats => 'chat_attachment',
    DocumentsFolderType.calls => 'call_attachment',
    DocumentsFolderType.invoices => 'regular_expense_receipt',
  };
}

DocumentsFolderType? documentsFolderTypeFromSourceType(String sourceType) {
  for (final type in DocumentsFolderType.values) {
    if (type.sourceType == sourceType) {
      return type;
    }
  }
  return null;
}

class UploadedFileEntity extends Equatable {
  const UploadedFileEntity({
    required this.id,
    required this.sourceType,
    required this.relatedId,
    required this.originalName,
    required this.mimeType,
    required this.size,
    required this.url,
    required this.createdAt,
  });

  final int id;
  final String sourceType;
  final int relatedId;
  final String originalName;
  final String mimeType;
  final int size;
  final String url;
  final String createdAt;

  @override
  List<Object?> get props => [
    id,
    sourceType,
    relatedId,
    originalName,
    mimeType,
    size,
    url,
    createdAt,
  ];
}
