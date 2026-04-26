import 'package:get_it/get_it.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/features/family_workspace/data/datasources/family_workspace_remote_data_source.dart';
import 'package:masr_al_qsariya/features/family_workspace/data/repositories/family_workspace_repository_impl.dart';
import 'package:masr_al_qsariya/features/family_workspace/domain/repositories/family_workspace_repository.dart';
import 'package:masr_al_qsariya/features/family_workspace/domain/usecases/get_family_workspace_members_usecase.dart';
import 'package:masr_al_qsariya/features/family_workspace/presentation/cubit/family_workspace_members_cubit.dart';

Future<void> initFamilyWorkspaceInjection(GetIt sl) async {
  sl.registerLazySingleton<FamilyWorkspaceRemoteDataSource>(
    () => FamilyWorkspaceRemoteDataSourceImpl(sl<ApiBaseHelper>()),
  );

  sl.registerLazySingleton<FamilyWorkspaceRepository>(
    () => FamilyWorkspaceRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetFamilyWorkspaceMembersUseCase(sl()));

  sl.registerFactory(() => FamilyWorkspaceMembersCubit(sl()));
}

