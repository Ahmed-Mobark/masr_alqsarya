import 'package:dio/dio.dart';
import 'package:masr_al_qsariya/core/config/app_end_points.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/features/sessions/data/models/live_session_lobby_model.dart';
import 'package:masr_al_qsariya/features/sessions/data/models/live_sessions_list_model.dart';
import 'package:masr_al_qsariya/features/sessions/data/models/session_library_list_model.dart';

abstract class LiveSessionsRemoteDataSource {
  Future<LiveSessionsListModel> getLiveSessions({
    String? search,
    int? personaId,
    String? status,
    bool? isRecorded,
    int page,
    int perPage,
    String? sortDirection,
  });

  Future<LiveSessionLobbyModel> getLiveSessionDetail({
    required int liveSessionId,
  });

  Future<SessionLibraryListModel> getSessionLibrary({
    String? search,
    int? expertPersonaId,
    String? type,
    int page,
    int perPage,
    String? sortDirection,
  });

  Future<void> bookLiveSession({
    required int workspaceId,
    required int liveSessionId,
  });
}

class LiveSessionsRemoteDataSourceImpl implements LiveSessionsRemoteDataSource {
  const LiveSessionsRemoteDataSourceImpl(this._api);
  final ApiBaseHelper _api;

  static bool _hasText(String? v) => v != null && v.trim().isNotEmpty;

  @override
  Future<LiveSessionsListModel> getLiveSessions({
    String? search,
    int? personaId,
    String? status,
    bool? isRecorded,
    int page = 1,
    int perPage = 15,
    String? sortDirection,
  }) async {
    final response = await _api.get<Map<String, dynamic>>(
      url: AppEndpoints.liveSessions,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (_hasText(search)) 'search': search!.trim(),
        if (personaId != null) 'persona_id': personaId,
        if (_hasText(status)) 'status': status!.trim(),
        if (isRecorded != null) 'is_recorded': isRecorded,
        if (_hasText(sortDirection)) 'sort_direction': sortDirection!.trim(),
      },
    );
    return LiveSessionsListModel.fromJson(response);
  }

  @override
  Future<LiveSessionLobbyModel> getLiveSessionDetail({
    required int liveSessionId,
  }) async {
    final response = await _api.get<Map<String, dynamic>>(
      url: AppEndpoints.liveSession(liveSessionId),
    );
    return LiveSessionLobbyModel.fromJson(response);
  }

  @override
  Future<SessionLibraryListModel> getSessionLibrary({
    String? search,
    int? expertPersonaId,
    String? type,
    int page = 1,
    int perPage = 15,
    String? sortDirection,
  }) async {
    final response = await _api.get<Map<String, dynamic>>(
      url: AppEndpoints.sessionLibrary,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (_hasText(search)) 'search': search!.trim(),
        if (expertPersonaId != null) 'expert_persona_id': expertPersonaId,
        if (_hasText(type)) 'type': type!.trim(),
        if (_hasText(sortDirection)) 'sort_direction': sortDirection!.trim(),
      },
    );
    return SessionLibraryListModel.fromJson(response);
  }

  @override
  Future<void> bookLiveSession({
    required int workspaceId,
    required int liveSessionId,
  }) async {
    await _api.post<Map<String, dynamic>>(
      url: AppEndpoints.workspaceLiveSessionBookings(workspaceId),
      formData: FormData.fromMap({'live_session_id': liveSessionId}),
    );
  }
}
