import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/home/domain/entities/home_recent_activities_data.dart';

abstract class HomeRepository {
  Future<Either<Failure, HomeRecentActivitiesData>> getRecentActivities();
}
