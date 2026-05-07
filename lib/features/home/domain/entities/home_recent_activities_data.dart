import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/features/home/domain/entities/home_awaiting_call.dart';
import 'package:masr_al_qsariya/features/home/domain/entities/recent_activity.dart';

class HomeRecentActivitiesData extends Equatable {
  const HomeRecentActivitiesData({
    required this.activities,
    required this.calls,
  });

  final List<RecentActivity> activities;
  final List<HomeAwaitingCall> calls;

  @override
  List<Object?> get props => [activities, calls];
}
