import 'package:dio/dio.dart';
import 'package:masr_al_qsariya/core/config/app_end_points.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/features/schedule/data/models/call_model.dart';
import 'package:masr_al_qsariya/features/schedule/data/models/call_join_model.dart';

abstract class CallsRemoteDataSource {
  Future<CallModel> createCall({
    required int workspaceId,
    required String mode,
    required String scheduledStartsAt,
  });

  Future<List<CallModel>> getCalls({
    required int workspaceId,
  });

  Future<CallJoinModel> joinCall({
    required int workspaceId,
    required int callId,
  });
}

class CallsRemoteDataSourceImpl implements CallsRemoteDataSource {
  const CallsRemoteDataSourceImpl(this._api);

  final ApiBaseHelper _api;

  @override
  Future<CallModel> createCall({
    required int workspaceId,
    required String mode,
    required String scheduledStartsAt,
  }) async {
    final response = await _api.post<Map<String, dynamic>>(
      url: AppEndpoints.workspaceCalls(workspaceId),
      // Postman shows `form-data`, so we send FormData to match the backend.
      formData: FormData.fromMap({
        'mode': mode,
        'scheduled_starts_at': scheduledStartsAt,
      }),
    );

    final data = response['data'];
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid call create response');
    }
    return CallModel.fromJson(data);
  }

  @override
  Future<List<CallModel>> getCalls({required int workspaceId}) async {
    final response = await _api.get<Map<String, dynamic>>(
      url: AppEndpoints.workspaceCalls(workspaceId),
    );

    final data = response['data'];
    if (data is! List) return const [];

    return data.whereType<Map<String, dynamic>>().map(CallModel.fromJson).toList();
  }

  @override
  Future<CallJoinModel> joinCall({
    required int workspaceId,
    required int callId,
  }) async {
    final response = await _api.post<Map<String, dynamic>>(
      url: AppEndpoints.workspaceCallJoin(workspaceId, callId),
    );

    final data = response['data'];
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid call join response');
    }
    return CallJoinModel.fromJson(data);
  }
}

