import 'package:get_it/get_it.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/core/storage/call_join_storage.dart';
import 'package:masr_al_qsariya/core/storage/workspace_id_storage.dart';
import 'package:masr_al_qsariya/features/schedule/data/datasources/calls_remote_data_source.dart';
import 'package:masr_al_qsariya/features/schedule/data/repositories/calls_repository_impl.dart';
import 'package:masr_al_qsariya/features/schedule/domain/repositories/calls_repository.dart';
import 'package:masr_al_qsariya/features/schedule/domain/usecases/create_call_usecase.dart';
import 'package:masr_al_qsariya/features/schedule/domain/usecases/create_calendar_item_usecase.dart';
import 'package:masr_al_qsariya/features/schedule/domain/usecases/get_calls_usecase.dart';
import 'package:masr_al_qsariya/features/schedule/domain/usecases/get_calendar_item_types_usecase.dart';
import 'package:masr_al_qsariya/features/schedule/domain/usecases/join_call_usecase.dart';
import 'package:masr_al_qsariya/features/schedule/presentation/cubit/add_schedule_cubit.dart';
import 'package:masr_al_qsariya/features/schedule/presentation/cubit/join_call_cubit.dart';
import 'package:masr_al_qsariya/features/schedule/presentation/cubit/schedule_calls_cubit.dart';

Future<void> initScheduleInjection(GetIt sl) async {
  sl.registerLazySingleton<CallsRemoteDataSource>(
    () => CallsRemoteDataSourceImpl(sl<ApiBaseHelper>()),
  );

  sl.registerLazySingleton<CallsRepository>(
    () => CallsRepositoryImpl(sl<CallsRemoteDataSource>()),
  );

  sl.registerLazySingleton<CreateCallUseCase>(
    () => CreateCallUseCase(sl<CallsRepository>()),
  );

  sl.registerLazySingleton<CreateCalendarItemUseCase>(
    () => CreateCalendarItemUseCase(sl<CallsRepository>()),
  );

  sl.registerLazySingleton<GetCallsUseCase>(
    () => GetCallsUseCase(sl<CallsRepository>()),
  );

  sl.registerLazySingleton<GetCalendarItemTypesUseCase>(
    () => GetCalendarItemTypesUseCase(sl<CallsRepository>()),
  );

  sl.registerLazySingleton<JoinCallUseCase>(
    () => JoinCallUseCase(sl<CallsRepository>()),
  );

  sl.registerFactory<AddScheduleCubit>(
    () => AddScheduleCubit(
      createCalendarItem: sl<CreateCalendarItemUseCase>(),
      getCalendarItemTypes: sl<GetCalendarItemTypesUseCase>(),
      workspaceIdStorage: sl<WorkspaceIdStorage>(),
    ),
  );

  sl.registerFactory<ScheduleCallsCubit>(
    () => ScheduleCallsCubit(
      sl<GetCallsUseCase>(),
      sl<WorkspaceIdStorage>(),
    ),
  );

  sl.registerFactory<JoinCallCubit>(
    () => JoinCallCubit(
      sl<JoinCallUseCase>(),
      sl<WorkspaceIdStorage>(),
      sl<CallJoinStorage>(),
    ),
  );
}

