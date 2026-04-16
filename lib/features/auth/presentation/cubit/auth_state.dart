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
    this.action,
  });

  final bool isLoginPasswordObscured;
  final bool isSignUpPasswordObscured;
  final bool isSignUpConfirmPasswordObscured;
  final bool hasAcceptedTerms;
  final bool showTermsError;
  final String selectedDialCode;
  final AuthAction? action;

  AuthState copyWith({
    bool? isLoginPasswordObscured,
    bool? isSignUpPasswordObscured,
    bool? isSignUpConfirmPasswordObscured,
    bool? hasAcceptedTerms,
    bool? showTermsError,
    String? selectedDialCode,
    AuthAction? action,
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
    action,
  ];
}
