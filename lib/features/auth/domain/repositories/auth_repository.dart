import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/auth/domain/entities/login_response.dart';
import 'package:masr_al_qsariya/features/auth/domain/entities/register_response.dart';
import 'package:masr_al_qsariya/features/auth/domain/entities/user_profile.dart';
import 'package:masr_al_qsariya/features/auth/domain/entities/verify_email_response.dart';
import 'package:masr_al_qsariya/features/auth/domain/entities/workspace.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/login_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/add_child_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/invite_co_partner_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/manage_family_invitation_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/join_workspace_by_code_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/register_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/verify_email_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/verify_reset_code_usecase.dart';

abstract class AuthRepository {
  Future<Either<Failure, RegisterResponse>> register(RegisterParams params);
  Future<Either<Failure, LoginResponse>> login(LoginParams params);
  Future<Either<Failure, VerifyEmailResponse>> verifyEmail(VerifyEmailParams params);
  Future<Either<Failure, void>> resendVerificationCode(String email);
  Future<Either<Failure, void>> forgotPassword(String email);
  Future<Either<Failure, void>> verifyResetCode(VerifyResetCodeParams params);
  Future<Either<Failure, void>> resetPassword(ResetPasswordParams params);
  Future<Either<Failure, void>> changePassword(ChangePasswordParams params);
  Future<Either<Failure, void>> deleteAccount(DeleteAccountParams params);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, UserProfile>> getProfile();
  Future<Either<Failure, Workspace>> getWorkspace();
  Future<Either<Failure, void>> inviteCoPartner(InviteCoPartnerParams params);
  Future<Either<Failure, void>> resendFamilyInvitation(
    ResendFamilyInvitationParams params,
  );
  Future<Either<Failure, void>> cancelFamilyInvitation(
    CancelFamilyInvitationParams params,
  );
  Future<Either<Failure, void>> addChild(AddChildParams params);
  Future<Either<Failure, void>> upgradeWorkspaceToFamily();
  Future<Either<Failure, void>> joinWorkspaceByCode(JoinWorkspaceByCodeParams params);
}
