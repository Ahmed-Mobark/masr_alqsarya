import 'package:equatable/equatable.dart';

enum NewsReaction { like, helpful }

class NewsFeed extends Equatable {
  const NewsFeed({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
  });

  final List<NewsFeedItem> items;
  final int currentPage;
  final int lastPage;
  final int total;
  final int perPage;

  bool get hasMore => currentPage < lastPage;

  @override
  List<Object?> get props => [items, currentPage, lastPage, total, perPage];
}

class NewsFeedItem extends Equatable {
  const NewsFeedItem({
    required this.id,
    required this.title,
    required this.content,
    required this.publishDate,
    required this.type,
    required this.likesCount,
    required this.helpfulCount,
    this.myReaction,
    required this.category,
    required this.persona,
    required this.postedByUser,
    required this.attachments,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String title;
  final String content;
  final String publishDate;
  final String type;
  final int likesCount;
  final int helpfulCount;
  final NewsReaction? myReaction;
  final NewsCategory? category;
  final NewsPersona? persona;
  final PostedByUser? postedByUser;
  final List<NewsAttachment> attachments;
  final String? createdAt;
  final String? updatedAt;

  String? get firstImageUrl {
    for (final a in attachments) {
      if (a.attachmentType == 'image' && (a.url?.isNotEmpty ?? false)) {
        return a.url;
      }
    }
    return null;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        publishDate,
        type,
        likesCount,
        helpfulCount,
        myReaction,
        category,
        persona,
        postedByUser,
        attachments,
        createdAt,
        updatedAt,
      ];
}

class NewsCategory extends Equatable {
  const NewsCategory({required this.id, required this.name});
  final int id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

class NewsPersona extends Equatable {
  const NewsPersona({required this.id, required this.name});
  final int id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

class PostedByUser extends Equatable {
  const PostedByUser({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  final int id;
  final String firstName;
  final String lastName;

  String get fullName => '$firstName $lastName'.trim();

  @override
  List<Object?> get props => [id, firstName, lastName];
}

class NewsAttachment extends Equatable {
  const NewsAttachment({
    required this.id,
    this.path,
    this.url,
    this.mimeType,
    this.attachmentType,
    this.originalName,
    this.sortOrder,
  });

  final int id;
  final String? path;
  final String? url;
  final String? mimeType;
  final String? attachmentType;
  final String? originalName;
  final int? sortOrder;

  @override
  List<Object?> get props =>
      [id, path, url, mimeType, attachmentType, originalName, sortOrder];
}

