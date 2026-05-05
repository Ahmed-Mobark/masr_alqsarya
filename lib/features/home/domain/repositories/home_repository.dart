import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/home/domain/entities/recent_activity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<RecentActivity>>> getRecentActivities();
}
