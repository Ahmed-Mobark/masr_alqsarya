import 'package:get_it/get_it.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/features/sessions/data/datasources/live_sessions_remote_data_source.dart';
import 'package:masr_al_qsariya/features/sessions/data/repositories/live_sessions_repository_impl.dart';
import 'package:masr_al_qsariya/features/sessions/domain/repositories/live_sessions_repository.dart';
import 'package:masr_al_qsariya/features/sessions/domain/usecases/book_live_session_usecase.dart';
import 'package:masr_al_qsariya/features/sessions/domain/usecases/get_live_session_detail_usecase.dart';
import 'package:masr_al_qsariya/features/sessions/domain/usecases/get_live_sessions_usecase.dart';
import 'package:masr_al_qsariya/features/sessions/domain/usecases/get_session_library_usecase.dart';
import 'package:masr_al_qsariya/features/sessions/presentation/cubit/live_sessions_cubit.dart';
import 'package:masr_al_qsariya/features/sessions/presentation/cubit/session_library_cubit.dart';

void initSessionsInjection(GetIt sl) {
  sl.registerLazySingleton<LiveSessionsRemoteDataSource>(
    () => LiveSessionsRemoteDataSourceImpl(sl<ApiBaseHelper>()),
  );

  sl.registerLazySingleton<LiveSessionsRepository>(
    () => LiveSessionsRepositoryImpl(sl<LiveSessionsRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetLiveSessionsUseCase>(
    () => GetLiveSessionsUseCase(sl<LiveSessionsRepository>()),
  );
  sl.registerLazySingleton<BookLiveSessionUseCase>(
    () => BookLiveSessionUseCase(sl<LiveSessionsRepository>()),
  );

  sl.registerLazySingleton<GetLiveSessionDetailUseCase>(
    () => GetLiveSessionDetailUseCase(sl<LiveSessionsRepository>()),
  );

  sl.registerLazySingleton<GetSessionLibraryUseCase>(
    () => GetSessionLibraryUseCase(sl<LiveSessionsRepository>()),
  );

  sl.registerFactory<LiveSessionsCubit>(
    () => LiveSessionsCubit(
      sl<GetLiveSessionsUseCase>(),
      sl<BookLiveSessionUseCase>(),
      sl(),
    ),
  );

  sl.registerFactory<SessionLibraryCubit>(
    () => SessionLibraryCubit(sl<GetSessionLibraryUseCase>()),
  );
}
