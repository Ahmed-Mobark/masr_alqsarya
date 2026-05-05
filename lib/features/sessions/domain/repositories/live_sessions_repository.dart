import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/sessions/domain/entities/live_session_lobby.dart';
import 'package:masr_al_qsariya/features/sessions/domain/entities/live_sessions_list.dart';
import 'package:masr_al_qsariya/features/sessions/domain/entities/session_library_list.dart';

abstract class LiveSessionsRepository {
  Future<Either<Failure, LiveSessionsList>> getLiveSessions({
    String? search,
    int? personaId,
    String? status,
    bool? isRecorded,
    int page,
    int perPage,
    String? sortDirection,
  });

  Future<Either<Failure, LiveSessionLobby>> getLiveSessionDetail({
    required int liveSessionId,
  });

  Future<Either<Failure, SessionLibraryList>> getSessionLibrary({
    String? search,
    int? expertPersonaId,
    String? type,
    int page,
    int perPage,
    String? sortDirection,
  });
}
