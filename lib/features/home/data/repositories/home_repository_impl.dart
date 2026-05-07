import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/core/network/network_service/repository_helper.dart';
import 'package:masr_al_qsariya/features/home/data/datasources/home_remote_data_source.dart';
import 'package:masr_al_qsariya/features/home/domain/entities/home_recent_activities_data.dart';
import 'package:masr_al_qsariya/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl with RepositoryHelper implements HomeRepository {
  const HomeRepositoryImpl(this._remote);
  final HomeRemoteDataSource _remote;

  @override
  Future<Either<Failure, HomeRecentActivitiesData>> getRecentActivities() {
    return handleEither(() async {
      final model = await _remote.getRecentActivities();
      return model.toEntity();
    });
  }
}
