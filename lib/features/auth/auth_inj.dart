import 'package:get_it/get_it.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:masr_al_qsariya/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:masr_al_qsariya/features/auth/domain/repositories/auth_repository.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/register_usecase.dart';
import 'package:masr_al_qsariya/features/auth/presentation/cubit/auth_cubit.dart';

Future<void> initAuthInjection(GetIt sl) async {
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<ApiBaseHelper>()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );
  sl.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(sl<AuthRepository>()),
  );

  sl.registerFactory<AuthCubit>(() => AuthCubit(sl<RegisterUseCase>()));
}
