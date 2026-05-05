import 'package:get_it/get_it.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/features/home/data/datasources/home_remote_data_source.dart';
import 'package:masr_al_qsariya/features/home/data/repositories/home_repository_impl.dart';
import 'package:masr_al_qsariya/features/home/domain/repositories/home_repository.dart';
import 'package:masr_al_qsariya/features/home/domain/usecases/get_recent_activities_usecase.dart';
import 'package:masr_al_qsariya/features/home/presentation/cubit/home_recent_activities_cubit.dart';

void initHomeInjection(GetIt sl) {
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(sl<ApiBaseHelper>()),
  );

  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl<HomeRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetRecentActivitiesUseCase>(
    () => GetRecentActivitiesUseCase(sl<HomeRepository>()),
  );

  sl.registerFactory<HomeRecentActivitiesCubit>(
    () => HomeRecentActivitiesCubit(sl<GetRecentActivitiesUseCase>()),
  );
}
