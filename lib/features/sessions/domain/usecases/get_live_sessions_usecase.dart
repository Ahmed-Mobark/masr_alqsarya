import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/sessions/domain/entities/live_sessions_list.dart';
import 'package:masr_al_qsariya/features/sessions/domain/repositories/live_sessions_repository.dart';

class GetLiveSessionsUseCase {
  const GetLiveSessionsUseCase(this._repo);
  final LiveSessionsRepository _repo;

  Future<Either<Failure, LiveSessionsList>> call(GetLiveSessionsParams params) {
    return _repo.getLiveSessions(
      search: params.search,
      personaId: params.personaId,
      status: params.status,
      isRecorded: params.isRecorded,
      page: params.page,
      perPage: params.perPage,
      sortDirection: params.sortDirection,
    );
  }
}

class GetLiveSessionsParams {
  const GetLiveSessionsParams({
    this.search,
    this.personaId,
    this.status,
    this.isRecorded,
    this.page = 1,
    this.perPage = 15,
    this.sortDirection,
  });

  final String? search;
  final int? personaId;
  final String? status;
  final bool? isRecorded;
  final int page;
  final int perPage;
  final String? sortDirection;
}
