import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/features/home/domain/entities/home_awaiting_call.dart';
import 'package:masr_al_qsariya/features/home/domain/entities/recent_activity.dart';

enum HomeRecentActivitiesStatus { initial, loading, success, failure }

class HomeRecentActivitiesState extends Equatable {
  const HomeRecentActivitiesState({
    this.status = HomeRecentActivitiesStatus.initial,
    this.activities = const [],
    this.calls = const [],
    this.error,
  });

  final HomeRecentActivitiesStatus status;
  final List<RecentActivity> activities;
  final List<HomeAwaitingCall> calls;
  final String? error;

  HomeRecentActivitiesState copyWith({
    HomeRecentActivitiesStatus? status,
    List<RecentActivity>? activities,
    List<HomeAwaitingCall>? calls,
    String? error,
    bool clearError = false,
  }) {
    return HomeRecentActivitiesState(
      status: status ?? this.status,
      activities: activities ?? this.activities,
      calls: calls ?? this.calls,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, activities, calls, error];
}
