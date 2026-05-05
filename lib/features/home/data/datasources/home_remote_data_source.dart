import 'package:masr_al_qsariya/core/config/app_end_points.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/features/home/data/models/recent_activity_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<RecentActivityModel>> getRecentActivities();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl(this._api);
  final ApiBaseHelper _api;

  @override
  Future<List<RecentActivityModel>> getRecentActivities() async {
    final response = await _api.get<Map<String, dynamic>>(
      url: AppEndpoints.homeRecentActivities,
    );

    final data = response['data'];
    if (data is! Map) return const [];

    final activitiesRaw = data['activities'];
    if (activitiesRaw is! List) return const [];

    return activitiesRaw
        .whereType<Map>()
        .map((e) => RecentActivityModel.fromJson(Map<String, dynamic>.from(e)))
        .toList(growable: false);
  }
}
