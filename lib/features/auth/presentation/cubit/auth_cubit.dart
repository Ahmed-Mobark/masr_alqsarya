import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/utils/validator.dart';
import 'package:masr_al_qsariya/features/auth/presentation/cubit/auth_state.dart';

export 'package:masr_al_qsariya/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  final loginFormKey = GlobalKey<FormState>();
  final signUpFormKey = GlobalKey<FormState>();

  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  final signUpFullNameController = TextEditingController();
  final signUpEmailController = TextEditingController();
  final signUpPhoneController = TextEditingController();
  final signUpPasswordController = TextEditingController();
  final signUpConfirmPasswordController = TextEditingController();

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

  void submitLogin() {
    final isFormValid = loginFormKey.currentState?.validate() ?? false;
    if (!isFormValid) {
      return;
    }

    emit(state.copyWith(action: AuthAction.navigateToHome));
  }

  void submitSignUp() {
    final isFormValid = signUpFormKey.currentState?.validate() ?? false;
    final hasAcceptedTerms = state.hasAcceptedTerms;

    emit(state.copyWith(showTermsError: !hasAcceptedTerms));

    if (!isFormValid || !hasAcceptedTerms) {
      return;
    }

    emit(state.copyWith(action: AuthAction.navigateToVerification));
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
    return super.close();
  }
}
