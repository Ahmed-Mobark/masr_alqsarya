import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/news/domain/repositories/news_repository.dart';

class DeleteReactionUseCase {
  const DeleteReactionUseCase(this._repo);
  final NewsRepository _repo;

  Future<Either<Failure, void>> call(int feedId) {
    return _repo.deleteReaction(feedId: feedId);
  }
}
