import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/news/domain/entities/news_feed.dart';

abstract class NewsRepository {
  Future<Either<Failure, NewsFeed>> getNewsFeeds({
    String? search,
    String? type,
    int? categoryId,
    int? personaId,
    String? sortDirection,
    int page = 1,
    int perPage = 5,
  });

  Future<Either<Failure, void>> reactToFeed({
    required int feedId,
    required String reaction, // like | helpful
  });

  Future<Either<Failure, void>> deleteReaction({required int feedId});
}

