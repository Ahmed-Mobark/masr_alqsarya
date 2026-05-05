import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/sessions/domain/entities/session_library_list.dart';
import 'package:masr_al_qsariya/features/sessions/domain/repositories/live_sessions_repository.dart';

class GetSessionLibraryUseCase {
  const GetSessionLibraryUseCase(this._repo);
  final LiveSessionsRepository _repo;

  Future<Either<Failure, SessionLibraryList>> call(
    GetSessionLibraryParams params,
  ) {
    return _repo.getSessionLibrary(
      search: params.search,
      expertPersonaId: params.expertPersonaId,
      type: params.type,
      page: params.page,
      perPage: params.perPage,
      sortDirection: params.sortDirection,
    );
  }
}

class GetSessionLibraryParams {
  const GetSessionLibraryParams({
    this.search,
    this.expertPersonaId,
    this.type,
    this.page = 1,
    this.perPage = 15,
    this.sortDirection,
  });

  final String? search;
  final int? expertPersonaId;
  final String? type;
  final int page;
  final int perPage;
  final String? sortDirection;
}
