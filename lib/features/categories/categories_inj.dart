import 'package:get_it/get_it.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/features/categories/data/datasources/categories_remote_data_source.dart';
import 'package:masr_al_qsariya/features/categories/data/repositories/categories_repository_impl.dart';
import 'package:masr_al_qsariya/features/categories/domain/repositories/categories_repository.dart';
import 'package:masr_al_qsariya/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:masr_al_qsariya/features/categories/presentation/cubit/categories_cubit.dart';

Future<void> initCategoriesInjection(GetIt sl) async {
  sl.registerLazySingleton<CategoriesRemoteDataSource>(
    () => CategoriesRemoteDataSourceImpl(sl<ApiBaseHelper>()),
  );

  sl.registerLazySingleton<CategoriesRepository>(
    () => CategoriesRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));

  sl.registerFactory(() => CategoriesCubit(sl()));
}

