import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/features/auth/domain/entities/workspace.dart';

enum AuthAction {
  navigateToHome,
  navigateToVerification,
  navigateToRoleOptions,
  navigateToLogin,
  navigateToSignUp,
  navigateToForgotPassword,
  navigateToForgotPasswordOtp,
  navigateToResetPassword,
  passwordResetSuccess,
  coPartnerInvited,
  childAdded,
  familyWorkspaceUpgraded,
}

class AuthState extends Equatable {
  const AuthState({
    this.isLoginPasswordObscured = true,
    this.isSignUpPasswordObscured = true,
    this.isSignUpConfirmPasswordObscured = true,
    this.isResetPasswordObscured = true,
    this.isResetConfirmPasswordObscured = true,
    this.hasAcceptedTerms = false,
    this.showTermsError = false,
    this.selectedDialCode = '+20',
    this.coPartnerDialCode = '+20',
    this.childDialCode = '+20',
    this.isSubmitting = false,
    this.isResending = false,
    this.submitError,
    this.registeredEmail,
    this.registerMessage,
    this.resendSuccess = false,
    this.forgotPasswordEmail,
    this.resetCode,
    this.workspace,
    this.isLoadingWorkspace = false,
    this.action,
  });

  final bool isLoginPasswordObscured;
  final bool isSignUpPasswordObscured;
  final bool isSignUpConfirmPasswordObscured;
  final bool isResetPasswordObscured;
  final bool isResetConfirmPasswordObscured;
  final bool hasAcceptedTerms;
  final bool showTermsError;
  final String selectedDialCode;
  final String coPartnerDialCode;
  final String childDialCode;
  final bool isSubmitting;
  final bool isResending;
  final String? submitError;
  final String? registeredEmail;
  final String? registerMessage;
  final bool resendSuccess;
  final String? forgotPasswordEmail;
  final String? resetCode;
  final Workspace? workspace;
  final bool isLoadingWorkspace;
  final AuthAction? action;

  AuthState copyWith({
    bool? isLoginPasswordObscured,
    bool? isSignUpPasswordObscured,
    bool? isSignUpConfirmPasswordObscured,
    bool? isResetPasswordObscured,
    bool? isResetConfirmPasswordObscured,
    bool? hasAcceptedTerms,
    bool? showTermsError,
    String? selectedDialCode,
    String? coPartnerDialCode,
    String? childDialCode,
    bool? isSubmitting,
    bool? isResending,
    String? submitError,
    String? registeredEmail,
    String? registerMessage,
    bool? resendSuccess,
    String? forgotPasswordEmail,
    String? resetCode,
    Workspace? workspace,
    bool? isLoadingWorkspace,
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
      isResetPasswordObscured:
          isResetPasswordObscured ?? this.isResetPasswordObscured,
      isResetConfirmPasswordObscured:
          isResetConfirmPasswordObscured ?? this.isResetConfirmPasswordObscured,
      hasAcceptedTerms: hasAcceptedTerms ?? this.hasAcceptedTerms,
      showTermsError: showTermsError ?? this.showTermsError,
      selectedDialCode: selectedDialCode ?? this.selectedDialCode,
      coPartnerDialCode: coPartnerDialCode ?? this.coPartnerDialCode,
      childDialCode: childDialCode ?? this.childDialCode,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isResending: isResending ?? this.isResending,
      submitError: clearSubmitError ? null : submitError ?? this.submitError,
      registeredEmail: registeredEmail ?? this.registeredEmail,
      registerMessage: registerMessage ?? this.registerMessage,
      resendSuccess: resendSuccess ?? false,
      forgotPasswordEmail: forgotPasswordEmail ?? this.forgotPasswordEmail,
      resetCode: resetCode ?? this.resetCode,
      workspace: workspace ?? this.workspace,
      isLoadingWorkspace: isLoadingWorkspace ?? this.isLoadingWorkspace,
      action: clearAction ? null : action ?? this.action,
    );
  }

  @override
  List<Object?> get props => [
    isLoginPasswordObscured,
    isSignUpPasswordObscured,
    isSignUpConfirmPasswordObscured,
    isResetPasswordObscured,
    isResetConfirmPasswordObscured,
    hasAcceptedTerms,
    showTermsError,
    selectedDialCode,
    coPartnerDialCode,
    childDialCode,
    isSubmitting,
    isResending,
    submitError,
    registeredEmail,
    registerMessage,
    resendSuccess,
    forgotPasswordEmail,
    resetCode,
    workspace,
    isLoadingWorkspace,
    action,
  ];
}
