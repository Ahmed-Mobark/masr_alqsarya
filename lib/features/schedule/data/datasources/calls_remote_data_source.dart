import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:masr_al_qsariya/core/config/app_end_points.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/features/schedule/data/models/calendar_item_type_model.dart';
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
    required DateTime startsFrom,
    required DateTime endsTo,
  });

  Future<CallJoinModel> joinCall({
    required int workspaceId,
    required int callId,
  });

  Future<List<CalendarItemTypeModel>> getCalendarItemTypes({
    required int workspaceId,
  });

  Future<void> createCalendarItem({
    required int workspaceId,
    required String type,
    required String startsAt,
    String? endsAt,
    String? note,
    int? categoryId,
    int? childWorkspaceMemberId,
  });
}

class CallsRemoteDataSourceImpl implements CallsRemoteDataSource {
  const CallsRemoteDataSourceImpl(this._api);

  final ApiBaseHelper _api;
  static final DateFormat _calendarRangeFormat = DateFormat("M/dd/yyyy'T'HH:mm:ss");

  @override
  Future<CallModel> createCall({
    required int workspaceId,
    required String mode,
    required String scheduledStartsAt,
  }) async {
    final type = mode == 'audio' ? 'audio_call' : 'video_call';
    final startsAt = scheduledStartsAt.split('T').first;
    final response = await _api.post<Map<String, dynamic>>(
      url: AppEndpoints.workspaceCalendarItems(workspaceId),
      // Backend expects `form-data` for calendar items creation.
      formData: FormData.fromMap({
        'type': type,
        'starts_at': startsAt,
        'ends_at': null,
        'note': null,
        'child_workspace_member_id': null,
      }),
    );

    final data = response['data'];
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid call create response');
    }
    // API returns a calendar item wrapper; map it back to a call model.
    return CallModel.fromCalendarItemJson(data, workspaceId: workspaceId);
  }

  @override
  Future<List<CallModel>> getCalls({
    required int workspaceId,
    required DateTime startsFrom,
    required DateTime endsTo,
  }) async {
    final response = await _api.get<Map<String, dynamic>>(
      url: AppEndpoints.workspaceCalendarItems(workspaceId),
      queryParameters: {
        'starts_from': _calendarRangeFormat.format(startsFrom),
        'ends_to': _calendarRangeFormat.format(endsTo),
      },
    );

    final data = response['data'];
    if (data is! List) return const [];

    return data
        .whereType<Map<String, dynamic>>()
        .where((e) => (e['type'] as String?) == 'call')
        .map((e) => CallModel.fromCalendarItemJson(e, workspaceId: workspaceId))
        .where((m) => m.id != 0)
        .toList();
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

  @override
  Future<List<CalendarItemTypeModel>> getCalendarItemTypes({
    required int workspaceId,
  }) async {
    final response = await _api.get<Map<String, dynamic>>(
      url: AppEndpoints.workspaceCalendarItemTypes(workspaceId),
    );

    final data = response['data'];
    if (data is! List) return const [];

    return data
        .whereType<Map<String, dynamic>>()
        .map(CalendarItemTypeModel.fromJson)
        .where((e) => e.value.isNotEmpty)
        .toList();
  }

  @override
  Future<void> createCalendarItem({
    required int workspaceId,
    required String type,
    required String startsAt,
    String? endsAt,
    String? note,
    int? categoryId,
    int? childWorkspaceMemberId,
  }) async {
    final payload = <String, dynamic>{
      'type': type,
      'starts_at': startsAt,
      'ends_at': endsAt,
      'note': note,
      'category_id': categoryId,
      'child_workspace_member_id': childWorkspaceMemberId,
    }..removeWhere((_, v) => v == null);

    await _api.post<Map<String, dynamic>>(
      url: AppEndpoints.workspaceCalendarItems(workspaceId),
      formData: FormData.fromMap(payload),
    );
  }
}

