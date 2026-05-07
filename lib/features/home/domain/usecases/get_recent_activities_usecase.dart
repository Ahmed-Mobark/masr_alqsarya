import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/home/domain/entities/home_recent_activities_data.dart';
import 'package:masr_al_qsariya/features/home/domain/repositories/home_repository.dart';

class GetRecentActivitiesUseCase {
  const GetRecentActivitiesUseCase(this._repository);
  final HomeRepository _repository;

  Future<Either<Failure, HomeRecentActivitiesData>> call() {
    return _repository.getRecentActivities();
  }
}
