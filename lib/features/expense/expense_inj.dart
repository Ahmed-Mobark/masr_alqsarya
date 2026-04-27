import 'package:get_it/get_it.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/features/expense/data/datasources/regular_expenses_remote_data_source.dart';
import 'package:masr_al_qsariya/features/expense/data/datasources/support_expenses_remote_data_source.dart';
import 'package:masr_al_qsariya/features/expense/data/repositories/regular_expenses_repository_impl.dart';
import 'package:masr_al_qsariya/features/expense/data/repositories/support_expenses_repository_impl.dart';
import 'package:masr_al_qsariya/features/expense/domain/repositories/regular_expenses_repository.dart';
import 'package:masr_al_qsariya/features/expense/domain/repositories/support_expenses_repository.dart';
import 'package:masr_al_qsariya/features/expense/domain/usecases/add_regular_expense_usecase.dart';
import 'package:masr_al_qsariya/features/expense/domain/usecases/add_support_expense_usecase.dart';
import 'package:masr_al_qsariya/features/expense/domain/usecases/get_regular_expense_details_usecase.dart';
import 'package:masr_al_qsariya/features/expense/domain/usecases/get_regular_expenses_usecase.dart';
import 'package:masr_al_qsariya/features/expense/domain/usecases/get_support_expense_details_usecase.dart';
import 'package:masr_al_qsariya/features/expense/domain/usecases/get_support_expenses_usecase.dart';
import 'package:masr_al_qsariya/features/expense/presentation/cubit/add_regular_expense_cubit.dart';
import 'package:masr_al_qsariya/features/expense/presentation/cubit/add_support_expense_cubit.dart';
import 'package:masr_al_qsariya/features/expense/presentation/cubit/regular_expense_details_cubit.dart';
import 'package:masr_al_qsariya/features/expense/presentation/cubit/regular_expenses_cubit.dart';
import 'package:masr_al_qsariya/features/expense/presentation/cubit/support_expense_details_cubit.dart';
import 'package:masr_al_qsariya/features/expense/presentation/cubit/support_expenses_cubit.dart';

Future<void> initExpenseInjection(GetIt sl) async {
  sl.registerLazySingleton<RegularExpensesRemoteDataSource>(
    () => RegularExpensesRemoteDataSourceImpl(sl<ApiBaseHelper>()),
  );
  sl.registerLazySingleton<SupportExpensesRemoteDataSource>(
    () => SupportExpensesRemoteDataSourceImpl(sl<ApiBaseHelper>()),
  );

  sl.registerLazySingleton<RegularExpensesRepository>(
    () => RegularExpensesRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<SupportExpensesRepository>(
    () => SupportExpensesRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetRegularExpensesUseCase(sl()));
  sl.registerLazySingleton(() => GetRegularExpenseDetailsUseCase(sl()));
  sl.registerLazySingleton(() => AddRegularExpenseUseCase(sl()));
  sl.registerLazySingleton(() => AddSupportExpenseUseCase(sl()));
  sl.registerLazySingleton(() => GetSupportExpensesUseCase(sl()));
  sl.registerLazySingleton(() => GetSupportExpenseDetailsUseCase(sl()));

  sl.registerFactory(() => RegularExpensesCubit(sl()));
  sl.registerFactory(() => RegularExpenseDetailsCubit(sl()));
  sl.registerFactory(() => AddRegularExpenseCubit(sl()));
  sl.registerFactory(() => AddSupportExpenseCubit(sl()));
  sl.registerFactory(() => SupportExpensesCubit(sl()));
  sl.registerFactory(() => SupportExpenseDetailsCubit(sl()));
}
