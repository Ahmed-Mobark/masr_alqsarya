import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/core/network/network_service/repository_helper.dart';
import 'package:masr_al_qsariya/features/sessions/data/datasources/live_sessions_remote_data_source.dart';
import 'package:masr_al_qsariya/features/sessions/domain/entities/live_session_lobby.dart';
import 'package:masr_al_qsariya/features/sessions/domain/entities/live_sessions_list.dart';
import 'package:masr_al_qsariya/features/sessions/domain/entities/session_library_list.dart';
import 'package:masr_al_qsariya/features/sessions/domain/repositories/live_sessions_repository.dart';

class LiveSessionsRepositoryImpl
    with RepositoryHelper
    implements LiveSessionsRepository {
  const LiveSessionsRepositoryImpl(this._remote);
  final LiveSessionsRemoteDataSource _remote;

  @override
  Future<Either<Failure, LiveSessionsList>> getLiveSessions({
    String? search,
    int? personaId,
    String? status,
    bool? isRecorded,
    int page = 1,
    int perPage = 15,
    String? sortDirection,
  }) {
    return handleEither(() async {
      final model = await _remote.getLiveSessions(
        search: search,
        personaId: personaId,
        status: status,
        isRecorded: isRecorded,
        page: page,
        perPage: perPage,
        sortDirection: sortDirection,
      );
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, LiveSessionLobby>> getLiveSessionDetail({
    required int liveSessionId,
  }) {
    return handleEither(() async {
      final model = await _remote.getLiveSessionDetail(
        liveSessionId: liveSessionId,
      );
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, SessionLibraryList>> getSessionLibrary({
    String? search,
    int? expertPersonaId,
    String? type,
    int page = 1,
    int perPage = 15,
    String? sortDirection,
  }) {
    return handleEither(() async {
      final model = await _remote.getSessionLibrary(
        search: search,
        expertPersonaId: expertPersonaId,
        type: type,
        page: page,
        perPage: perPage,
        sortDirection: sortDirection,
      );
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, Unit>> bookLiveSession({
    required int workspaceId,
    required int liveSessionId,
  }) {
    return handleEither(() async {
      await _remote.bookLiveSession(
        workspaceId: workspaceId,
        liveSessionId: liveSessionId,
      );
      return unit;
    });
  }
}
