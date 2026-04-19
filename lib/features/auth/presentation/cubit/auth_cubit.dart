import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';
import 'package:masr_al_qsariya/core/utils/validator.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/add_child_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/invite_co_partner_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/login_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/logout_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/register_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/resend_code_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/verify_email_usecase.dart';
import 'package:masr_al_qsariya/features/auth/presentation/cubit/auth_state.dart';

export 'package:masr_al_qsariya/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required RegisterUseCase registerUseCase,
    required LoginUseCase loginUseCase,
    required VerifyEmailUseCase verifyEmailUseCase,
    required ResendCodeUseCase resendCodeUseCase,
    required LogoutUseCase logoutUseCase,
    required InviteCoPartnerUseCase inviteCoPartnerUseCase,
    required AddChildUseCase addChildUseCase,
    required Storage storage,
  })  : _registerUseCase = registerUseCase,
        _loginUseCase = loginUseCase,
        _verifyEmailUseCase = verifyEmailUseCase,
        _resendCodeUseCase = resendCodeUseCase,
        _logoutUseCase = logoutUseCase,
        _inviteCoPartnerUseCase = inviteCoPartnerUseCase,
        _addChildUseCase = addChildUseCase,
        _storage = storage,
        super(const AuthState());

  final RegisterUseCase _registerUseCase;
  final LoginUseCase _loginUseCase;
  final VerifyEmailUseCase _verifyEmailUseCase;
  final ResendCodeUseCase _resendCodeUseCase;
  final LogoutUseCase _logoutUseCase;
  final InviteCoPartnerUseCase _inviteCoPartnerUseCase;
  final AddChildUseCase _addChildUseCase;
  final Storage _storage;

  final loginFormKey = GlobalKey<FormState>();
  final signUpFormKey = GlobalKey<FormState>();
  final coPartnerFormKey = GlobalKey<FormState>();
  final addChildFormKey = GlobalKey<FormState>();

  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  final signUpFullNameController = TextEditingController();
  final signUpEmailController = TextEditingController();
  final signUpPhoneController = TextEditingController();
  final signUpPasswordController = TextEditingController();
  final signUpConfirmPasswordController = TextEditingController();

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

    result.fold(
      (failure) {
        emit(state.copyWith(isSubmitting: false, submitError: failure.message));
      },
      (data) {
        if (data.token != null && data.token!.isNotEmpty) {
          _storage.storeToken(token: data.token!);
        }
        emit(
          state.copyWith(
            isSubmitting: false,
            action: AuthAction.navigateToHome,
          ),
        );
      },
    );
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
        emit(
          state.copyWith(
            isSubmitting: false,
            action: AuthAction.navigateToRoleOptions,
          ),
        );
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

    final result = await _logoutUseCase();

    result.fold(
      (failure) {
        emit(state.copyWith(isSubmitting: false, submitError: failure.message));
      },
      (_) {
        _storage.deleteToken();
        emit(
          state.copyWith(
            isSubmitting: false,
            action: AuthAction.navigateToLogin,
          ),
        );
      },
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
    final isFormValid = addChildFormKey.currentState?.validate() ?? false;
    if (!isFormValid) return;

    emit(state.copyWith(isSubmitting: true, clearSubmitError: true));

    final result = await _addChildUseCase(
      AddChildParams(
        displayName: childDisplayNameController.text.trim(),
        firstName: childFirstNameController.text.trim(),
        lastName: childLastNameController.text.trim(),
        email: childEmailController.text.trim(),
        phone: childPhoneController.text.trim(),
        dateOfBirth: childDateOfBirthController.text.trim(),
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
            action: AuthAction.childAdded,
          ),
        );
      },
    );
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
