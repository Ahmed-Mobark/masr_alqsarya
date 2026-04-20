import 'package:dio/dio.dart';
import 'package:masr_al_qsariya/core/config/app_end_points.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/features/news/data/models/news_feed_model.dart';

abstract class NewsRemoteDataSource {
  Future<NewsFeedModel> getNewsFeeds({
    String? search,
    String? type,
    int? categoryId,
    int? personaId,
    String? sortDirection,
    int page,
    int perPage,
  });

  Future<void> reactToFeed({required int feedId, required String reaction});
  Future<void> deleteReaction({required int feedId});
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  const NewsRemoteDataSourceImpl(this._api);
  final ApiBaseHelper _api;

  static bool _hasText(String? v) => v != null && v.trim().isNotEmpty;

  @override
  Future<NewsFeedModel> getNewsFeeds({
    String? search,
    String? type,
    int? categoryId,
    int? personaId,
    String? sortDirection,
    int page = 1,
    int perPage = 5,
  }) async {
    final response = await _api.get<Map<String, dynamic>>(
      url: AppEndpoints.newsFeeds,
      queryParameters: {
        // Always send pagination
        'per_page': perPage,
        'page': page,
        // Optional filters (only when non-empty)
        if (_hasText(search)) 'search': search!.trim(),
        if (_hasText(type)) 'type': type!.trim(),
        if (categoryId != null) 'category_id': categoryId,
        if (personaId != null) 'persona_id': personaId,
        if (_hasText(sortDirection)) 'sort_direction': sortDirection!.trim(),
      },
    );

    return NewsFeedModel.fromJson(response);
  }

  @override
  Future<void> reactToFeed({required int feedId, required String reaction}) async {
    await _api.post<Map<String, dynamic>>(
      url: AppEndpoints.newsFeedReactions(feedId),
      formData: FormData.fromMap({'reaction': reaction}),
    );
  }

  @override
  Future<void> deleteReaction({required int feedId}) async {
    await _api.delete<Map<String, dynamic>>(
      url: AppEndpoints.newsFeedReactions(feedId),
    );
  }
}

