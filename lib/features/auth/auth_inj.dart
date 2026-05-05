import 'package:get_it/get_it.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/core/realtime/realtime_service.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';
import 'package:masr_al_qsariya/core/storage/workspace_id_storage.dart';
import 'package:masr_al_qsariya/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:masr_al_qsariya/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:masr_al_qsariya/features/auth/domain/repositories/auth_repository.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/add_child_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/invite_co_partner_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/manage_family_invitation_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/join_workspace_by_code_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/login_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/logout_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/register_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/resend_code_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/get_workspace_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/verify_email_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/verify_reset_code_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/upgrade_workspace_to_family_usecase.dart';
import 'package:masr_al_qsariya/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:masr_al_qsariya/features/auth/presentation/cubit/change_password_cubit.dart';

Future<void> initAuthInjection(GetIt sl) async {
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      sl<ApiBaseHelper>(),
      sl<WorkspaceIdStorage>(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );

  // Use cases
  sl.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<VerifyEmailUseCase>(
    () => VerifyEmailUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<ResendCodeUseCase>(
    () => ResendCodeUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<InviteCoPartnerUseCase>(
    () => InviteCoPartnerUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<ResendFamilyInvitationUseCase>(
    () => ResendFamilyInvitationUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<CancelFamilyInvitationUseCase>(
    () => CancelFamilyInvitationUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<AddChildUseCase>(
    () => AddChildUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<ForgotPasswordUseCase>(
    () => ForgotPasswordUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<VerifyResetCodeUseCase>(
    () => VerifyResetCodeUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<ChangePasswordUseCase>(
    () => ChangePasswordUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<DeleteAccountUseCase>(
    () => DeleteAccountUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<GetWorkspaceUseCase>(
    () => GetWorkspaceUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<UpgradeWorkspaceToFamilyUseCase>(
    () => UpgradeWorkspaceToFamilyUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<JoinWorkspaceByCodeUseCase>(
    () => JoinWorkspaceByCodeUseCase(sl<AuthRepository>()),
  );

  // Cubit
  sl.registerFactory<ChangePasswordCubit>(
    () => ChangePasswordCubit(sl<ChangePasswordUseCase>()),
  );

  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      registerUseCase: sl<RegisterUseCase>(),
      loginUseCase: sl<LoginUseCase>(),
      verifyEmailUseCase: sl<VerifyEmailUseCase>(),
      resendCodeUseCase: sl<ResendCodeUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
      getProfileUseCase: sl<GetProfileUseCase>(),
      inviteCoPartnerUseCase: sl<InviteCoPartnerUseCase>(),
      addChildUseCase: sl<AddChildUseCase>(),
      forgotPasswordUseCase: sl<ForgotPasswordUseCase>(),
      verifyResetCodeUseCase: sl<VerifyResetCodeUseCase>(),
      resetPasswordUseCase: sl<ResetPasswordUseCase>(),
      getWorkspaceUseCase: sl<GetWorkspaceUseCase>(),
      upgradeWorkspaceToFamilyUseCase: sl<UpgradeWorkspaceToFamilyUseCase>(),
      joinWorkspaceByCodeUseCase: sl<JoinWorkspaceByCodeUseCase>(),
      storage: sl<Storage>(),
      workspaceIdStorage: sl<WorkspaceIdStorage>(),
      realtimeService: sl<RealtimeService>(),
    ),
  );
}
