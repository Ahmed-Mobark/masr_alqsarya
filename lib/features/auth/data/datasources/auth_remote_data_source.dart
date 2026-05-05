import 'package:dio/dio.dart';
import 'package:masr_al_qsariya/core/config/app_end_points.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/core/network/network_service/exceptions.dart';
import 'package:masr_al_qsariya/core/storage/workspace_id_storage.dart';
import 'package:masr_al_qsariya/features/auth/data/models/login_response_model.dart';
import 'package:masr_al_qsariya/features/auth/data/models/register_response_model.dart';
import 'package:masr_al_qsariya/features/auth/data/models/user_profile_model.dart';
import 'package:masr_al_qsariya/features/auth/data/models/verify_email_response_model.dart';
import 'package:masr_al_qsariya/features/auth/data/models/workspace_model.dart';
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

abstract class AuthRemoteDataSource {
  Future<RegisterResponseModel> register(RegisterParams params);
  Future<LoginResponseModel> login(LoginParams params);
  Future<VerifyEmailResponseModel> verifyEmail(VerifyEmailParams params);
  Future<void> resendVerificationCode(String email);
  Future<void> forgotPassword(String email);
  Future<void> verifyResetCode(VerifyResetCodeParams params);
  Future<void> resetPassword(ResetPasswordParams params);
  Future<void> changePassword(ChangePasswordParams params);
  Future<void> deleteAccount(DeleteAccountParams params);
  Future<void> logout();
  Future<UserProfileModel> getProfile();
  Future<WorkspaceModel> getWorkspace();
  Future<void> inviteCoPartner(InviteCoPartnerParams params);
  Future<void> resendFamilyInvitation(ResendFamilyInvitationParams params);
  Future<void> cancelFamilyInvitation(CancelFamilyInvitationParams params);
  Future<void> addChild(AddChildParams params);
  Future<void> upgradeWorkspaceToFamily();
  Future<void> joinWorkspaceByCode(JoinWorkspaceByCodeParams params);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._api, this._workspaceIdStorage);

  final ApiBaseHelper _api;
  final WorkspaceIdStorage _workspaceIdStorage;

  @override
  Future<RegisterResponseModel> register(RegisterParams params) async {
    final response = await _api.post<Map<String, dynamic>>(
      url: AppEndpoints.authRegister,
      formData: FormData.fromMap(
        {
          'first_name': params.firstName,
          'last_name': params.lastName,
          'phone': params.phone,
          'email': params.email,
          'date_of_birth': params.dateOfBirth,
          'device_name': params.deviceName,
          'type': params.type,
          'password': params.password,
          'password_confirmation': params.passwordConfirmation,
        }..removeWhere((key, value) => value == null || value == ''),
      ),
    );

    return RegisterResponseModel.fromJson(response);
  }

  @override
  Future<LoginResponseModel> login(LoginParams params) async {
    final response = await _api.post<Map<String, dynamic>>(
      url: AppEndpoints.authLogin,
      formData: FormData.fromMap(
        {
          'email': params.email,
          'password': params.password,
          'device_name': params.deviceName,
        }..removeWhere((key, value) => value == null || value == ''),
      ),
    );

    return LoginResponseModel.fromJson(response);
  }

  @override
  Future<VerifyEmailResponseModel> verifyEmail(VerifyEmailParams params) async {
    final response = await _api.post<Map<String, dynamic>>(
      url: AppEndpoints.authVerifyEmail,
      formData: FormData.fromMap(
        {
          'email': params.email,
          'code': params.code,
          'device_name': params.deviceName,
        }..removeWhere((key, value) => value == null || value == ''),
      ),
    );

    return VerifyEmailResponseModel.fromJson(response);
  }

  @override
  Future<void> resendVerificationCode(String email) async {
    await _api.post<Map<String, dynamic>>(
      url: AppEndpoints.authResendCode,
      formData: FormData.fromMap({'email': email}),
    );
  }

  @override
  Future<void> forgotPassword(String email) async {
    await _api.post<Map<String, dynamic>>(
      url: AppEndpoints.authForgotPassword,
      formData: FormData.fromMap({'email': email}),
    );
  }

  @override
  Future<void> verifyResetCode(VerifyResetCodeParams params) async {
    await _api.post<Map<String, dynamic>>(
      url: AppEndpoints.authVerifyResetCode,
      formData: FormData.fromMap({
        'email': params.email,
        'code': params.code,
      }),
    );
  }

  @override
  Future<void> resetPassword(ResetPasswordParams params) async {
    await _api.post<Map<String, dynamic>>(
      url: AppEndpoints.authResetPassword,
      formData: FormData.fromMap({
        'email': params.email,
        'otp': params.code,
        'password': params.password,
        'password_confirmation': params.passwordConfirmation,
      }),
    );
  }

  @override
  Future<void> changePassword(ChangePasswordParams params) async {
    await _api.patch<Map<String, dynamic>>(
      url: AppEndpoints.authPassword,
      formData: FormData.fromMap({
        'current_password': params.currentPassword,
        'password': params.password,
        'password_confirmation': params.passwordConfirmation,
      }),
      options: Options(contentType: 'multipart/form-data'),
    );
  }

  @override
  Future<void> deleteAccount(DeleteAccountParams params) async {
    await _api.delete<dynamic>(
      url: AppEndpoints.authAccount,
      formData: FormData.fromMap({
        'current_password': params.currentPassword,
      }),
      options: Options(contentType: 'multipart/form-data'),
    );
  }

  @override
  Future<void> logout() async {
    await _api.post<dynamic>(url: AppEndpoints.authLogout);
  }

  @override
  Future<UserProfileModel> getProfile() async {
    final response = await _api.get<Map<String, dynamic>>(
      url: AppEndpoints.authUser,
    );

    return UserProfileModel.fromJson(response);
  }

  @override
  Future<WorkspaceModel> getWorkspace() async {
    final response = await _api.get<Map<String, dynamic>>(
      url: AppEndpoints.workspace,
    );

    return WorkspaceModel.fromJson(response);
  }

  @override
  Future<void> upgradeWorkspaceToFamily() async {
    await _api.post<Map<String, dynamic>>(
      url: AppEndpoints.workspaceUpgradeToFamily,
      formData: FormData(),
    );
  }

  @override
  Future<void> inviteCoPartner(InviteCoPartnerParams params) async {
    final workspaceId = params.workspaceId ?? _workspaceIdStorage.get();
    if (workspaceId == null) {
      throw ValidationException(
        'Workspace id is required for this action.',
      );
    }
    final idStr = workspaceId.toString();
    final isCoPartnerInvite = params.type == InviteCoPartnerParams.typeCoPartner;
    final url = isCoPartnerInvite
        ? AppEndpoints.inviteCoPartner
        : AppEndpoints.inviteProfessional;

    final body = <String, dynamic>{
      'first_name': params.firstName,
      'last_name': params.lastName,
      'phone': params.phone,
      'email': params.email,
      'workspace_id': idStr,
      'workspace': idStr,
    };
    if (isCoPartnerInvite) {
      body['type'] = params.type;
    } else {
      body['professional_type'] = params.type;
    }

    await _api.post<Map<String, dynamic>>(
      url: url,
      formData: FormData.fromMap(body),
      options: Options(contentType: 'multipart/form-data'),
    );
  }

  @override
  Future<void> resendFamilyInvitation(ResendFamilyInvitationParams params) async {
    final workspaceId = _workspaceIdStorage.get();
    if (workspaceId == null) {
      throw ValidationException(
        'Workspace id is required for this action.',
      );
    }
    final idStr = workspaceId.toString();
    await _api.post<Map<String, dynamic>>(
      url: AppEndpoints.familyWorkspaceInvitationResend(params.invitationId),
      formData: FormData.fromMap({
        'email': params.email,
        'workspace_id': idStr,
        'workspace': idStr,
      }),
      options: Options(contentType: 'multipart/form-data'),
    );
  }

  @override
  Future<void> cancelFamilyInvitation(CancelFamilyInvitationParams params) async {
    final workspaceId = _workspaceIdStorage.get();
    if (workspaceId == null) {
      throw ValidationException(
        'Workspace id is required for this action.',
      );
    }
    final idStr = workspaceId.toString();
    await _api.post<Map<String, dynamic>>(
      url: AppEndpoints.familyWorkspaceInvitationCancel(params.invitationId),
      formData: FormData.fromMap({
        'email': params.email,
        'workspace_id': idStr,
        'workspace': idStr,
      }),
      options: Options(contentType: 'multipart/form-data'),
    );
  }

  /// POST `family-workspace/add-child` — **only** these multipart fields (no extras):
  /// `display_name`, `first_name`, `last_name`, `email`, `phone`, `date_of_birth`.
  @override
  Future<void> addChild(AddChildParams params) async {
    await _api.post<Map<String, dynamic>>(
      url: AppEndpoints.addChild,
      formData: FormData.fromMap({
        'display_name': params.displayName,
        'first_name': params.firstName,
        'last_name': params.lastName,
        'email': params.email,
        'phone': params.phone,
        'date_of_birth': params.dateOfBirth,
      }),
      options: Options(contentType: 'multipart/form-data'),
    );
  }

  @override
  Future<void> joinWorkspaceByCode(JoinWorkspaceByCodeParams params) async {
    await _api.post<Map<String, dynamic>>(
      url: AppEndpoints.familyWorkspaceJoinByCode,
      formData: FormData.fromMap({
        'invitation_code': params.invitationCode,
        'status': params.status,
      }),
    );
  }
}
