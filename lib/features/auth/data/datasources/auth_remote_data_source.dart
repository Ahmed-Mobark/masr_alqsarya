import 'package:dio/dio.dart';
import 'package:masr_al_qsariya/core/config/app_end_points.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/features/auth/data/models/login_response_model.dart';
import 'package:masr_al_qsariya/features/auth/data/models/register_response_model.dart';
import 'package:masr_al_qsariya/features/auth/data/models/user_profile_model.dart';
import 'package:masr_al_qsariya/features/auth/data/models/verify_email_response_model.dart';
import 'package:masr_al_qsariya/features/auth/data/models/workspace_model.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/login_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/add_child_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/invite_co_partner_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/register_usecase.dart';
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
  Future<void> logout();
  Future<UserProfileModel> getProfile();
  Future<WorkspaceModel> getWorkspace();
  Future<void> inviteCoPartner(InviteCoPartnerParams params);
  Future<void> addChild(AddChildParams params);
  Future<void> upgradeWorkspaceToFamily();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._api);

  final ApiBaseHelper _api;

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
        'code': params.code,
        'password': params.password,
        'password_confirmation': params.passwordConfirmation,
      }),
    );
  }

  @override
  Future<void> logout() async {
    await _api.post<Map<String, dynamic>>(url: AppEndpoints.authLogout);
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
    await _api.post<Map<String, dynamic>>(
      url: AppEndpoints.inviteCoPartner,
      formData: FormData.fromMap({
        'first_name': params.firstName,
        'last_name': params.lastName,
        'phone': params.phone,
        'email': params.email,
      }),
    );
  }

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
    );
  }
}
