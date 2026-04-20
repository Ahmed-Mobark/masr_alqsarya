import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/news/domain/entities/news_feed.dart';
import 'package:masr_al_qsariya/features/news/domain/repositories/news_repository.dart';

class GetNewsFeedsUseCase {
  const GetNewsFeedsUseCase(this._repo);
  final NewsRepository _repo;

  Future<Either<Failure, NewsFeed>> call(GetNewsFeedsParams params) {
    return _repo.getNewsFeeds(
      search: params.search,
      type: params.type,
      categoryId: params.categoryId,
      personaId: params.personaId,
      sortDirection: params.sortDirection,
      page: params.page,
      perPage: params.perPage,
    );
  }
}

class GetNewsFeedsParams {
  const GetNewsFeedsParams({
    this.search,
    this.type,
    this.categoryId,
    this.personaId,
    this.sortDirection,
    this.page = 1,
    this.perPage = 5,
  });

  final String? search;
  final String? type;
  final int? categoryId;
  final int? personaId;
  final String? sortDirection;
  final int page;
  final int perPage;
}

