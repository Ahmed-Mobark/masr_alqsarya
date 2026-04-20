import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/core/network/network_service/repository_helper.dart';
import 'package:masr_al_qsariya/features/news/data/datasources/news_remote_data_source.dart';
import 'package:masr_al_qsariya/features/news/domain/entities/news_feed.dart';
import 'package:masr_al_qsariya/features/news/domain/repositories/news_repository.dart';

class NewsRepositoryImpl with RepositoryHelper implements NewsRepository {
  const NewsRepositoryImpl(this._remote);
  final NewsRemoteDataSource _remote;

  @override
  Future<Either<Failure, NewsFeed>> getNewsFeeds({
    String? search,
    String? type,
    int? categoryId,
    int? personaId,
    String? sortDirection,
    int page = 1,
    int perPage = 5,
  }) {
    return handleEither(() async {
      final model = await _remote.getNewsFeeds(
        search: search,
        type: type,
        categoryId: categoryId,
        personaId: personaId,
        sortDirection: sortDirection,
        page: page,
        perPage: perPage,
      );
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> reactToFeed({
    required int feedId,
    required String reaction,
  }) {
    return handleEither(() async {
      await _remote.reactToFeed(feedId: feedId, reaction: reaction);
    });
  }

  @override
  Future<Either<Failure, void>> deleteReaction({required int feedId}) {
    return handleEither(() async {
      await _remote.deleteReaction(feedId: feedId);
    });
  }
}

