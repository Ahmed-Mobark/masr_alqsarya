import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/news/domain/repositories/news_repository.dart';

class ReactToFeedUseCase {
  const ReactToFeedUseCase(this._repo);
  final NewsRepository _repo;

  Future<Either<Failure, void>> call(ReactToFeedParams params) {
    return _repo.reactToFeed(feedId: params.feedId, reaction: params.reaction);
  }
}

class ReactToFeedParams {
  const ReactToFeedParams({required this.feedId, required this.reaction});
  final int feedId;
  final String reaction; // like | helpful
}

