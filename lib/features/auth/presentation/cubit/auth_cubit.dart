import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/core/realtime/realtime_service.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';
import 'package:masr_al_qsariya/core/storage/workspace_id_storage.dart';
import 'package:masr_al_qsariya/core/storage/models/local_user.dart';
import 'package:masr_al_qsariya/features/auth/domain/entities/login_response.dart';
import 'package:masr_al_qsariya/features/auth/domain/entities/workspace.dart';
import 'package:masr_al_qsariya/core/utils/validator.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/add_child_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/invite_co_partner_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/login_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/logout_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/register_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/resend_code_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/verify_email_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/get_workspace_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/verify_reset_code_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/upgrade_workspace_to_family_usecase.dart';
import 'package:masr_al_qsariya/features/auth/presentation/cubit/auth_state.dart';

export 'package:masr_al_qsariya/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required RegisterUseCase registerUseCase,
    required LoginUseCase loginUseCase,
    required VerifyEmailUseCase verifyEmailUseCase,
    required ResendCodeUseCase resendCodeUseCase,
    required LogoutUseCase logoutUseCase,
    required GetProfileUseCase getProfileUseCase,
    required InviteCoPartnerUseCase inviteCoPartnerUseCase,
    required AddChildUseCase addChildUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required VerifyResetCodeUseCase verifyResetCodeUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required GetWorkspaceUseCase getWorkspaceUseCase,
    required UpgradeWorkspaceToFamilyUseCase upgradeWorkspaceToFamilyUseCase,
    required Storage storage,
    required WorkspaceIdStorage workspaceIdStorage,
    required RealtimeService realtimeService,
  })  : _registerUseCase = registerUseCase,
        _loginUseCase = loginUseCase,
        _verifyEmailUseCase = verifyEmailUseCase,
        _resendCodeUseCase = resendCodeUseCase,
        _logoutUseCase = logoutUseCase,
        _getProfileUseCase = getProfileUseCase,
        _inviteCoPartnerUseCase = inviteCoPartnerUseCase,
        _addChildUseCase = addChildUseCase,
        _forgotPasswordUseCase = forgotPasswordUseCase,
        _verifyResetCodeUseCase = verifyResetCodeUseCase,
        _resetPasswordUseCase = resetPasswordUseCase,
        _getWorkspaceUseCase = getWorkspaceUseCase,
        _upgradeWorkspaceToFamilyUseCase = upgradeWorkspaceToFamilyUseCase,
        _storage = storage,
        _workspaceIdStorage = workspaceIdStorage,
        _realtimeService = realtimeService,
        super(const AuthState());

  final RegisterUseCase _registerUseCase;
  final LoginUseCase _loginUseCase;
  final VerifyEmailUseCase _verifyEmailUseCase;
  final ResendCodeUseCase _resendCodeUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetProfileUseCase _getProfileUseCase;
  final InviteCoPartnerUseCase _inviteCoPartnerUseCase;
  final AddChildUseCase _addChildUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final VerifyResetCodeUseCase _verifyResetCodeUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final GetWorkspaceUseCase _getWorkspaceUseCase;
  final UpgradeWorkspaceToFamilyUseCase _upgradeWorkspaceToFamilyUseCase;
  final Storage _storage;
  final WorkspaceIdStorage _workspaceIdStorage;
  final RealtimeService _realtimeService;

  Future<void> _cacheUserProfile() async {
    final result = await _getProfileUseCase();
    result.fold(
      (_) {},
      (profile) {
        _storage.storeUser(
          user: LocalUser(
            id: profile.id,
            firstName: profile.firstName,
            lastName: profile.lastName,
            email: profile.email,
            phone: profile.phone,
            imageUrl: null,
            isVerified: profile.isVerified,
            emailVerifiedAt: profile.emailVerifiedAt,
            createdAt: profile.createdAt,
            updatedAt: profile.updatedAt,
          ),
        );
      },
    );
  }

  final loginFormKey = GlobalKey<FormState>();
  final signUpFormKey = GlobalKey<FormState>();
  final forgotPasswordFormKey = GlobalKey<FormState>();
  final resetPasswordFormKey = GlobalKey<FormState>();
  final coPartnerFormKey = GlobalKey<FormState>();
  final addChildFormKey = GlobalKey<FormState>();

  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  final signUpFullNameController = TextEditingController();
  final signUpEmailController = TextEditingController();
  final signUpPhoneController = TextEditingController();
  final signUpPasswordController = TextEditingController();
  final signUpConfirmPasswordController = TextEditingController();

  final forgotPasswordEmailController = TextEditingController();
  final resetPasswordController = TextEditingController();
  final resetConfirmPasswordController = TextEditingController();

  final coPartnerFirstNameController = TextEditingController();
  final coPartnerLastNameController = TextEditingController();
  final coPartnerEmailController = TextEditingController();
  final coPartnerPhoneController = TextEditingController();

  final childDisplayNameController = TextEditingController();
  final childFirstNameController = TextEditingController();
  final childLastNameController = TextEditingController();
  final childEmailController = TextEditingController();
  final childPhoneController = TextEditingController();
  final childDateOfBirthController = TextEditingController();

  void toggleLoginPasswordVisibility() {
    emit(
      state.copyWith(isLoginPasswordObscured: !state.isLoginPasswordObscured),
    );
  }

  void toggleSignUpPasswordVisibility() {
    emit(
      state.copyWith(isSignUpPasswordObscured: !state.isSignUpPasswordObscured),
    );
  }

  void toggleSignUpConfirmPasswordVisibility() {
    emit(
      state.copyWith(
        isSignUpConfirmPasswordObscured: !state.isSignUpConfirmPasswordObscured,
      ),
    );
  }

  void setTermsAccepted(bool? value) {
    emit(
      state.copyWith(hasAcceptedTerms: value ?? false, showTermsError: false),
    );
  }

  void setSelectedDialCode(String dialCode) {
    emit(state.copyWith(selectedDialCode: dialCode));
  }

  void setCoPartnerDialCode(String dialCode) {
    emit(state.copyWith(coPartnerDialCode: dialCode));
  }

  void setChildDialCode(String dialCode) {
    emit(state.copyWith(childDialCode: dialCode));
  }

  Future<void> submitLogin() async {
    final isFormValid = loginFormKey.currentState?.validate() ?? false;
    if (!isFormValid) return;

    emit(state.copyWith(isSubmitting: true, clearSubmitError: true));

    final deviceName = kIsWeb ? null : Platform.operatingSystem;

    final result = await _loginUseCase(
      LoginParams(
        email: loginEmailController.text.trim(),
        password: loginPasswordController.text,
        deviceName: deviceName,
      ),
    );

    final failure = result.fold<Failure?>((f) => f, (_) => null);
    if (failure != null) {
      emit(state.copyWith(isSubmitting: false, submitError: failure.message));
      return;
    }

    final data = result.fold<LoginResponse?>((_) => null, (d) => d)!;

    if (data.token != null && data.token!.isNotEmpty) {
      await _storage.storeToken(token: data.token!);
    }
    await _cacheUserProfile();
    await _persistFirstWorkspaceAfterAuth();
    emit(
      state.copyWith(
        isSubmitting: false,
        action: AuthAction.navigateToHome,
      ),
    );
  }

  Future<void> _persistFirstWorkspaceAfterAuth() async {
    final result = await _getWorkspaceUseCase();
    final workspace = result.fold<Workspace?>((_) => null, (w) => w);
    final id = workspace?.id;
    if (id != null) {
      await _workspaceIdStorage.store(id);
    }
  }

  Future<void> submitSignUp() async {
    final isFormValid = signUpFormKey.currentState?.validate() ?? false;
    final hasAcceptedTerms = state.hasAcceptedTerms;

    emit(state.copyWith(showTermsError: !hasAcceptedTerms));

    if (!isFormValid || !hasAcceptedTerms) {
      return;
    }

    emit(state.copyWith(isSubmitting: true, clearSubmitError: true));

    final name = signUpFullNameController.text.trim();
    final parts = name
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    final firstName = parts.isNotEmpty ? parts.first : name;
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : firstName;

    final phoneDigits = signUpPhoneController.text.trim();
    final fullPhone = '${state.selectedDialCode}$phoneDigits';

    final deviceName = kIsWeb ? null : Platform.operatingSystem;

    final result = await _registerUseCase(
      RegisterParams(
        firstName: firstName,
        lastName: lastName,
        phone: fullPhone,
        email: signUpEmailController.text.trim(),
        type: '',
        password: signUpPasswordController.text,
        passwordConfirmation: signUpConfirmPasswordController.text,
        deviceName: deviceName,
      ),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isSubmitting: false, submitError: failure.message));
      },
      (data) {
        emit(
          state.copyWith(
            isSubmitting: false,
            registeredEmail: data.email,
            registerMessage: data.message,
            action: AuthAction.navigateToVerification,
          ),
        );
      },
    );
  }

  Future<void> verifyEmail(String code) async {
    final email = state.registeredEmail;
    if (email == null || email.isEmpty) return;

    emit(state.copyWith(isSubmitting: true, clearSubmitError: true));

    final deviceName = kIsWeb ? null : Platform.operatingSystem;

    final result = await _verifyEmailUseCase(
      VerifyEmailParams(
        email: email,
        code: code,
        deviceName: deviceName,
      ),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isSubmitting: false, submitError: failure.message));
      },
      (data) {
        if (data.token.isNotEmpty) {
          _storage.storeToken(token: data.token);
        }
        _cacheUserProfile().whenComplete(() {
          emit(
            state.copyWith(
              isSubmitting: false,
              action: AuthAction.navigateToRoleOptions,
            ),
          );
        });
      },
    );
  }

  Future<void> resendVerificationCode() async {
    final email = state.registeredEmail;
    if (email == null || email.isEmpty) return;

    emit(state.copyWith(isResending: true, clearSubmitError: true));

    final result = await _resendCodeUseCase(email);

    result.fold(
      (failure) {
        emit(state.copyWith(isResending: false, submitError: failure.message));
      },
      (_) {
        emit(state.copyWith(isResending: false, resendSuccess: true));
      },
    );
  }

  Future<void> logout() async {
    emit(state.copyWith(isSubmitting: true, clearSubmitError: true));

    await _logoutUseCase();

    // Always clear cache regardless of API result
    await _storage.deleteToken();
    await _storage.deleteUser();
    await _storage.deleteSelectedRole();
    await _workspaceIdStorage.delete();
    await _realtimeService.disconnect();

    emit(
      state.copyWith(
        isSubmitting: false,
        action: AuthAction.navigateToLogin,
      ),
    );
  }

  Future<void> submitUpgradeToFamily() async {
    emit(state.copyWith(isSubmitting: true, clearSubmitError: true));

    final upgrade = await _upgradeWorkspaceToFamilyUseCase();
    final fail = upgrade.fold<Failure?>((f) => f, (_) => null);
    if (fail != null) {
      emit(state.copyWith(isSubmitting: false, submitError: fail.message));
      return;
    }

    await _storage.storeSelectedRole(role: 'family_space');

    final wsResult = await _getWorkspaceUseCase();
    await wsResult.fold<Future<void>>(
      (_) async {},
      (workspace) async {
        final id = workspace.id;
        if (id != null) {
          await _workspaceIdStorage.store(id);
        }
      },
    );

    emit(
      state.copyWith(
        isSubmitting: false,
        action: AuthAction.familyWorkspaceUpgraded,
      ),
    );
  }

  Future<void> submitInviteCoPartner() async {
    final isFormValid = coPartnerFormKey.currentState?.validate() ?? false;
    if (!isFormValid) return;

    emit(state.copyWith(isSubmitting: true, clearSubmitError: true));

    final phoneDigits = coPartnerPhoneController.text.trim();
    final fullPhone = '${state.coPartnerDialCode}$phoneDigits';

    final result = await _inviteCoPartnerUseCase(
      InviteCoPartnerParams(
        firstName: coPartnerFirstNameController.text.trim(),
        lastName: coPartnerLastNameController.text.trim(),
        phone: fullPhone,
        email: coPartnerEmailController.text.trim(),
      ),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isSubmitting: false, submitError: failure.message));
      },
      (_) {
        emit(
          state.copyWith(
            isSubmitting: false,
            action: AuthAction.coPartnerInvited,
          ),
        );
      },
    );
  }

  Future<void> submitAddChild() async {
    await _submitAddChildInternal(finishOnboarding: true);
  }

  Future<void> submitAddChildAddAnother() async {
    await _submitAddChildInternal(finishOnboarding: false);
  }

  Future<void> _submitAddChildInternal({required bool finishOnboarding}) async {
    final isFormValid = addChildFormKey.currentState?.validate() ?? false;
    if (!isFormValid) return;

    emit(state.copyWith(isSubmitting: true, clearSubmitError: true));

    final phoneDigits = childPhoneController.text.trim();
    final fullPhone = '${state.childDialCode}$phoneDigits';

    final result = await _addChildUseCase(
      AddChildParams(
        displayName: childDisplayNameController.text.trim(),
        firstName: childFirstNameController.text.trim(),
        lastName: childLastNameController.text.trim(),
        email: childEmailController.text.trim(),
        phone: fullPhone,
        dateOfBirth: childDateOfBirthController.text.trim(),
      ),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isSubmitting: false, submitError: failure.message));
      },
      (_) {
        if (finishOnboarding) {
          emit(
            state.copyWith(
              isSubmitting: false,
              action: AuthAction.childAdded,
            ),
          );
        } else {
          _clearAddChildForm();
          emit(state.copyWith(isSubmitting: false));
        }
      },
    );
  }

  void _clearAddChildForm() {
    childDisplayNameController.clear();
    childFirstNameController.clear();
    childLastNameController.clear();
    childEmailController.clear();
    childPhoneController.clear();
    childDateOfBirthController.clear();
    addChildFormKey.currentState?.reset();
  }

  Future<void> fetchWorkspace() async {
    emit(state.copyWith(isLoadingWorkspace: true, clearSubmitError: true));

    final result = await _getWorkspaceUseCase();

    final failure = result.fold<Failure?>((f) => f, (_) => null);
    if (failure != null) {
      emit(state.copyWith(
        isLoadingWorkspace: false,
        submitError: failure.message,
      ));
      return;
    }

    final workspace = result.fold<Workspace?>((_) => null, (w) => w)!;
    final id = workspace.id;
    if (id != null) {
      await _workspaceIdStorage.store(id);
    }
    emit(state.copyWith(
      isLoadingWorkspace: false,
      workspace: workspace,
    ));
  }

  void goToForgotPassword() {
    emit(state.copyWith(action: AuthAction.navigateToForgotPassword));
  }

  Future<void> submitForgotPassword() async {
    final isFormValid = forgotPasswordFormKey.currentState?.validate() ?? false;
    if (!isFormValid) return;

    emit(state.copyWith(isSubmitting: true, clearSubmitError: true));

    final email = forgotPasswordEmailController.text.trim();

    final result = await _forgotPasswordUseCase(email);

    result.fold(
      (failure) {
        emit(state.copyWith(isSubmitting: false, submitError: failure.message));
      },
      (_) {
        emit(
          state.copyWith(
            isSubmitting: false,
            forgotPasswordEmail: email,
            action: AuthAction.navigateToForgotPasswordOtp,
          ),
        );
      },
    );
  }

  Future<void> verifyResetCode(String code) async {
    final email = state.forgotPasswordEmail;
    if (email == null || email.isEmpty) return;

    emit(state.copyWith(isSubmitting: true, clearSubmitError: true));

    final result = await _verifyResetCodeUseCase(
      VerifyResetCodeParams(email: email, code: code),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isSubmitting: false, submitError: failure.message));
      },
      (_) {
        emit(
          state.copyWith(
            isSubmitting: false,
            resetCode: code,
            action: AuthAction.navigateToResetPassword,
          ),
        );
      },
    );
  }

  Future<void> resendForgotPasswordCode() async {
    final email = state.forgotPasswordEmail;
    if (email == null || email.isEmpty) return;

    emit(state.copyWith(isResending: true, clearSubmitError: true));

    final result = await _forgotPasswordUseCase(email);

    result.fold(
      (failure) {
        emit(state.copyWith(isResending: false, submitError: failure.message));
      },
      (_) {
        emit(state.copyWith(isResending: false, resendSuccess: true));
      },
    );
  }

  Future<void> submitResetPassword() async {
    final isFormValid = resetPasswordFormKey.currentState?.validate() ?? false;
    if (!isFormValid) return;

    final email = state.forgotPasswordEmail;
    final code = state.resetCode;
    if (email == null || code == null) return;

    emit(state.copyWith(isSubmitting: true, clearSubmitError: true));

    final result = await _resetPasswordUseCase(
      ResetPasswordParams(
        email: email,
        code: code,
        password: resetPasswordController.text,
        passwordConfirmation: resetConfirmPasswordController.text,
      ),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isSubmitting: false, submitError: failure.message));
      },
      (_) {
        emit(
          state.copyWith(
            isSubmitting: false,
            action: AuthAction.passwordResetSuccess,
          ),
        );
      },
    );
  }

  void toggleResetPasswordVisibility() {
    emit(
      state.copyWith(isResetPasswordObscured: !state.isResetPasswordObscured),
    );
  }

  void toggleResetConfirmPasswordVisibility() {
    emit(
      state.copyWith(
        isResetConfirmPasswordObscured: !state.isResetConfirmPasswordObscured,
      ),
    );
  }

  String? validateResetConfirmPassword(String? value) {
    return Validator.confirmPassword(value, resetPasswordController.text);
  }

  void setForgotPasswordEmail(String email) {
    emit(state.copyWith(forgotPasswordEmail: email));
  }

  void setResetCode(String code) {
    emit(state.copyWith(resetCode: code));
  }

  void goToSignUp() {
    emit(state.copyWith(action: AuthAction.navigateToSignUp));
  }

  void goToLogin() {
    emit(state.copyWith(action: AuthAction.navigateToLogin));
  }

  void clearAction() {
    emit(state.copyWith(clearAction: true));
  }

  void clearSubmitError() {
    emit(state.copyWith(clearSubmitError: true));
  }

  void setRegisteredEmail(String email) {
    emit(state.copyWith(registeredEmail: email));
  }

  String? validateName(String? value) => Validator.name(value);

  String? validateEmail(String? value) => Validator.email(value);

  String? validatePhone(String? value) => Validator.numbers(value);

  String? validatePassword(String? value) => Validator.password(value);

  String? validateConfirmPassword(String? value) {
    return Validator.confirmPassword(value, signUpPasswordController.text);
  }

  @override
  Future<void> close() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    signUpFullNameController.dispose();
    signUpEmailController.dispose();
    signUpPhoneController.dispose();
    signUpPasswordController.dispose();
    signUpConfirmPasswordController.dispose();
    forgotPasswordEmailController.dispose();
    resetPasswordController.dispose();
    resetConfirmPasswordController.dispose();
    coPartnerFirstNameController.dispose();
    coPartnerLastNameController.dispose();
    coPartnerEmailController.dispose();
    coPartnerPhoneController.dispose();
    childDisplayNameController.dispose();
    childFirstNameController.dispose();
    childLastNameController.dispose();
    childEmailController.dispose();
    childPhoneController.dispose();
    childDateOfBirthController.dispose();
    return super.close();
  }
}
