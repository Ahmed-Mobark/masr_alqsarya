import 'package:masr_al_qsariya/features/news/domain/entities/news_feed.dart';

class NewsFeedModel {
  const NewsFeedModel({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
  });

  final List<NewsFeedItemModel> items;
  final int currentPage;
  final int lastPage;
  final int total;
  final int perPage;

  factory NewsFeedModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final dataMap = data is Map<String, dynamic> ? data : <String, dynamic>{};

    final innerData = dataMap['data'];
    final list = innerData is List ? innerData : const [];

    final meta = dataMap['meta'];
    final metaMap = meta is Map<String, dynamic> ? meta : <String, dynamic>{};

    return NewsFeedModel(
      items: list
          .whereType<Map<String, dynamic>>()
          .map(NewsFeedItemModel.fromMap)
          .toList(),
      currentPage: (metaMap['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (metaMap['last_page'] as num?)?.toInt() ?? 1,
      total: (metaMap['total'] as num?)?.toInt() ?? list.length,
      perPage: (metaMap['per_page'] as num?)?.toInt() ?? 5,
    );
  }

  NewsFeed toEntity() => NewsFeed(
        items: items.map((e) => e.toEntity()).toList(),
        currentPage: currentPage,
        lastPage: lastPage,
        total: total,
        perPage: perPage,
      );
}

class NewsFeedItemModel {
  const NewsFeedItemModel({
    required this.id,
    required this.title,
    required this.content,
    required this.publishDate,
    required this.type,
    required this.likesCount,
    required this.helpfulCount,
    required this.currentUserReaction,
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
  final String? currentUserReaction; // like | helpful | null
  final NewsCategoryModel? category;
  final NewsPersonaModel? persona;
  final PostedByUserModel? postedByUser;
  final List<NewsAttachmentModel> attachments;
  final String? createdAt;
  final String? updatedAt;

  static String _stripHtml(String value) {
    // Quick, safe snippet extraction for list UI.
    return value
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  factory NewsFeedItemModel.fromMap(Map<String, dynamic> map) {
    final attachmentsRaw = map['attachments'];
    final attachmentsList = attachmentsRaw is List ? attachmentsRaw : const [];

    return NewsFeedItemModel(
      id: (map['id'] as num?)?.toInt() ?? 0,
      title: (map['title'] as String?) ?? '',
      content: _stripHtml((map['content'] as String?) ?? ''),
      publishDate: (map['publish_date'] as String?) ?? '',
      type: (map['type'] as String?) ?? '',
      likesCount: (map['likes_count'] as num?)?.toInt() ?? 0,
      helpfulCount: (map['helpful_count'] as num?)?.toInt() ?? 0,
      currentUserReaction: map['current_user_reaction']?.toString(),
      category: map['category'] is Map<String, dynamic>
          ? NewsCategoryModel.fromMap(map['category'] as Map<String, dynamic>)
          : null,
      persona: map['persona'] is Map<String, dynamic>
          ? NewsPersonaModel.fromMap(map['persona'] as Map<String, dynamic>)
          : null,
      postedByUser: map['posted_by_user'] is Map<String, dynamic>
          ? PostedByUserModel.fromMap(
              map['posted_by_user'] as Map<String, dynamic>,
            )
          : null,
      attachments: attachmentsList
          .whereType<Map<String, dynamic>>()
          .map(NewsAttachmentModel.fromMap)
          .toList(),
      createdAt: map['created_at'] as String?,
      updatedAt: map['updated_at'] as String?,
    );
  }

  NewsFeedItem toEntity() => NewsFeedItem(
        id: id,
        title: title,
        content: content,
        publishDate: publishDate,
        type: type,
        likesCount: likesCount,
        helpfulCount: helpfulCount,
        myReaction: switch (currentUserReaction?.toLowerCase().trim()) {
          'like' => NewsReaction.like,
          'helpful' => NewsReaction.helpful,
          _ => null,
        },
        category: category?.toEntity(),
        persona: persona?.toEntity(),
        postedByUser: postedByUser?.toEntity(),
        attachments: attachments.map((e) => e.toEntity()).toList(),
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

class NewsCategoryModel {
  const NewsCategoryModel({required this.id, required this.name});
  final int id;
  final String name;

  factory NewsCategoryModel.fromMap(Map<String, dynamic> map) => NewsCategoryModel(
        id: (map['id'] as num?)?.toInt() ?? 0,
        name: (map['name'] as String?) ?? '',
      );

  NewsCategory toEntity() => NewsCategory(id: id, name: name);
}

class NewsPersonaModel {
  const NewsPersonaModel({required this.id, required this.name});
  final int id;
  final String name;

  factory NewsPersonaModel.fromMap(Map<String, dynamic> map) => NewsPersonaModel(
        id: (map['id'] as num?)?.toInt() ?? 0,
        name: (map['name'] as String?) ?? '',
      );

  NewsPersona toEntity() => NewsPersona(id: id, name: name);
}

class PostedByUserModel {
  const PostedByUserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  final int id;
  final String firstName;
  final String lastName;

  factory PostedByUserModel.fromMap(Map<String, dynamic> map) => PostedByUserModel(
        id: (map['id'] as num?)?.toInt() ?? 0,
        firstName: (map['first_name'] as String?) ?? '',
        lastName: (map['last_name'] as String?) ?? '',
      );

  PostedByUser toEntity() =>
      PostedByUser(id: id, firstName: firstName, lastName: lastName);
}

class NewsAttachmentModel {
  const NewsAttachmentModel({
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

  factory NewsAttachmentModel.fromMap(Map<String, dynamic> map) =>
      NewsAttachmentModel(
        id: (map['id'] as num?)?.toInt() ?? 0,
        path: map['path'] as String?,
        url: map['url'] as String?,
        mimeType: map['mime_type'] as String?,
        attachmentType: map['attachment_type'] as String?,
        originalName: map['original_name'] as String?,
        sortOrder: (map['sort_order'] as num?)?.toInt(),
      );

  NewsAttachment toEntity() => NewsAttachment(
        id: id,
        path: path,
        url: url,
        mimeType: mimeType,
        attachmentType: attachmentType,
        originalName: originalName,
        sortOrder: sortOrder,
      );
}

