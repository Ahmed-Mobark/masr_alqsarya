import 'package:equatable/equatable.dart';

enum AuthAction {
  navigateToHome,
  navigateToVerification,
  navigateToRoleOptions,
  navigateToLogin,
  navigateToSignUp,
  coPartnerInvited,
  childAdded,
}

class AuthState extends Equatable {
  const AuthState({
    this.isLoginPasswordObscured = true,
    this.isSignUpPasswordObscured = true,
    this.isSignUpConfirmPasswordObscured = true,
    this.hasAcceptedTerms = false,
    this.showTermsError = false,
    this.selectedDialCode = '+20',
    this.coPartnerDialCode = '+20',
    this.isSubmitting = false,
    this.isResending = false,
    this.submitError,
    this.registeredEmail,
    this.registerMessage,
    this.resendSuccess = false,
    this.action,
  });

  final bool isLoginPasswordObscured;
  final bool isSignUpPasswordObscured;
  final bool isSignUpConfirmPasswordObscured;
  final bool hasAcceptedTerms;
  final bool showTermsError;
  final String selectedDialCode;
  final String coPartnerDialCode;
  final bool isSubmitting;
  final bool isResending;
  final String? submitError;
  final String? registeredEmail;
  final String? registerMessage;
  final bool resendSuccess;
  final AuthAction? action;

  AuthState copyWith({
    bool? isLoginPasswordObscured,
    bool? isSignUpPasswordObscured,
    bool? isSignUpConfirmPasswordObscured,
    bool? hasAcceptedTerms,
    bool? showTermsError,
    String? selectedDialCode,
    String? coPartnerDialCode,
    bool? isSubmitting,
    bool? isResending,
    String? submitError,
    String? registeredEmail,
    String? registerMessage,
    bool? resendSuccess,
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
      coPartnerDialCode: coPartnerDialCode ?? this.coPartnerDialCode,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isResending: isResending ?? this.isResending,
      submitError: clearSubmitError ? null : submitError ?? this.submitError,
      registeredEmail: registeredEmail ?? this.registeredEmail,
      registerMessage: registerMessage ?? this.registerMessage,
      resendSuccess: resendSuccess ?? false,
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
    coPartnerDialCode,
    isSubmitting,
    isResending,
    submitError,
    registeredEmail,
    registerMessage,
    resendSuccess,
    action,
  ];
}
