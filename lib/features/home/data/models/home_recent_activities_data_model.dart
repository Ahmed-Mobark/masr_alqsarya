import 'package:masr_al_qsariya/features/home/data/models/home_awaiting_call_model.dart';
import 'package:masr_al_qsariya/features/home/data/models/recent_activity_model.dart';
import 'package:masr_al_qsariya/features/home/domain/entities/home_recent_activities_data.dart';

class HomeRecentActivitiesDataModel {
  const HomeRecentActivitiesDataModel({
    required this.activities,
    required this.calls,
  });

  final List<RecentActivityModel> activities;
  final List<HomeAwaitingCallModel> calls;

  HomeRecentActivitiesData toEntity() => HomeRecentActivitiesData(
        activities: activities.map((e) => e.toEntity()).toList(growable: false),
        calls: calls.map((e) => e.toEntity()).toList(growable: false),
      );
}
