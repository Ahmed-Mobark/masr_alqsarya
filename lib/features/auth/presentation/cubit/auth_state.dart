import 'package:equatable/equatable.dart';

enum AuthAction {
  navigateToHome,
  navigateToVerification,
  navigateToLogin,
  navigateToSignUp,
}

class AuthState extends Equatable {
  const AuthState({
    this.isLoginPasswordObscured = true,
    this.isSignUpPasswordObscured = true,
    this.isSignUpConfirmPasswordObscured = true,
    this.hasAcceptedTerms = false,
    this.showTermsError = false,
    this.selectedDialCode = '+20',
    this.isSubmitting = false,
    this.submitError,
    this.registeredEmail,
    this.registerMessage,
    this.action,
  });

  final bool isLoginPasswordObscured;
  final bool isSignUpPasswordObscured;
  final bool isSignUpConfirmPasswordObscured;
  final bool hasAcceptedTerms;
  final bool showTermsError;
  final String selectedDialCode;
  final bool isSubmitting;
  final String? submitError;
  final String? registeredEmail;
  final String? registerMessage;
  final AuthAction? action;

  AuthState copyWith({
    bool? isLoginPasswordObscured,
    bool? isSignUpPasswordObscured,
    bool? isSignUpConfirmPasswordObscured,
    bool? hasAcceptedTerms,
    bool? showTermsError,
    String? selectedDialCode,
    bool? isSubmitting,
    String? submitError,
    String? registeredEmail,
    String? registerMessage,
    AuthAction? action,
    bool clearSubmitError = false,
    bool clearAction = false,
  }) {
    return AuthState(
      isLoginPasswordObscured:
          isLoginPasswordObscured ?? this.isLoginPasswordObscured,
      isSignUpPasswordObscured:
          isSignUpPasswordObscured ?? this.isSignUpPasswordObscured,
      isSignUpConfirmPasswordObscured:
          isSignUpConfirmPasswordObscured ??
          this.isSignUpConfirmPasswordObscured,
      hasAcceptedTerms: hasAcceptedTerms ?? this.hasAcceptedTerms,
      showTermsError: showTermsError ?? this.showTermsError,
      selectedDialCode: selectedDialCode ?? this.selectedDialCode,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: clearSubmitError ? null : submitError ?? this.submitError,
      registeredEmail: registeredEmail ?? this.registeredEmail,
      registerMessage: registerMessage ?? this.registerMessage,
      action: clearAction ? null : action ?? this.action,
    );
  }

  @override
  List<Object?> get props => [
    isLoginPasswordObscured,
    isSignUpPasswordObscured,
    isSignUpConfirmPasswordObscured,
    hasAcceptedTerms,
    showTermsError,
    selectedDialCode,
    isSubmitting,
    submitError,
    registeredEmail,
    registerMessage,
    action,
  ];
}
