import 'package:masr_al_qsariya/core/config/app_end_points.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/features/home/data/models/home_awaiting_call_model.dart';
import 'package:masr_al_qsariya/features/home/data/models/home_recent_activities_data_model.dart';
import 'package:masr_al_qsariya/features/home/data/models/recent_activity_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeRecentActivitiesDataModel> getRecentActivities();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl(this._api);
  final ApiBaseHelper _api;

  @override
  Future<HomeRecentActivitiesDataModel> getRecentActivities() async {
    final response = await _api.get<Map<String, dynamic>>(
      url: AppEndpoints.homeRecentActivities,
    );

    final data = response['data'];
    if (data is! Map) {
      return const HomeRecentActivitiesDataModel(activities: [], calls: []);
    }

    final activitiesRaw = data['activities'];
    final callsRaw = data['calls'];

    final activities = activitiesRaw is List
        ? activitiesRaw
            .whereType<Map>()
            .map((e) => RecentActivityModel.fromJson(Map<String, dynamic>.from(e)))
            .toList(growable: false)
        : const <RecentActivityModel>[];

    final calls = callsRaw is List
        ? callsRaw
            .whereType<Map>()
            .map((e) => HomeAwaitingCallModel.fromJson(Map<String, dynamic>.from(e)))
            .toList(growable: false)
        : const <HomeAwaitingCallModel>[];

    return HomeRecentActivitiesDataModel(activities: activities, calls: calls);
  }
}
