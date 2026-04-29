import 'package:get_it/get_it.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/core/storage/workspace_id_storage.dart';
import 'package:masr_al_qsariya/features/documents/data/datasources/documents_remote_data_source.dart';
import 'package:masr_al_qsariya/features/documents/data/repositories/documents_repository_impl.dart';
import 'package:masr_al_qsariya/features/documents/domain/repositories/documents_repository.dart';
import 'package:masr_al_qsariya/features/documents/domain/usecases/get_workspace_uploaded_files_usecase.dart';
import 'package:masr_al_qsariya/features/documents/domain/usecases/get_workspace_members_usecase.dart';
import 'package:masr_al_qsariya/features/documents/domain/usecases/get_uploaded_file_activity_usecase.dart';
import 'package:masr_al_qsariya/features/documents/domain/usecases/get_uploaded_file_detail_usecase.dart';
import 'package:masr_al_qsariya/features/documents/domain/usecases/update_uploaded_file_permissions_usecase.dart';
import 'package:masr_al_qsariya/features/documents/presentation/cubit/document_detail_cubit.dart';
import 'package:masr_al_qsariya/features/documents/presentation/cubit/documents_cubit.dart';
import 'package:masr_al_qsariya/features/documents/presentation/cubit/file_activity_cubit.dart';
import 'package:masr_al_qsariya/features/documents/presentation/cubit/uploaded_file_permissions_cubit.dart';

Future<void> initDocumentsInjection(GetIt sl) async {
  sl.registerLazySingleton<DocumentsRemoteDataSource>(
    () => DocumentsRemoteDataSourceImpl(sl<ApiBaseHelper>()),
  );

  sl.registerLazySingleton<DocumentsRepository>(
    () => DocumentsRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetWorkspaceUploadedFilesUseCase(sl()));
  sl.registerLazySingleton(() => GetWorkspaceMembersUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUploadedFilePermissionsUseCase(sl()));
  sl.registerLazySingleton(() => GetUploadedFileActivityUseCase(sl()));
  sl.registerLazySingleton(() => GetUploadedFileDetailUseCase(sl()));

  sl.registerFactory(() => DocumentsCubit(sl(), sl<WorkspaceIdStorage>()));
  sl.registerFactory(
    () => UploadedFilePermissionsCubit(
      sl<GetWorkspaceMembersUseCase>(),
      sl<UpdateUploadedFilePermissionsUseCase>(),
    ),
  );
  sl.registerFactory(
    () => FileActivityCubit(
      sl<GetUploadedFileActivityUseCase>(),
      sl<DocumentsRepository>(),
    ),
  );
  sl.registerFactory(
    () => DocumentDetailCubit(sl<GetUploadedFileDetailUseCase>()),
  );
}
