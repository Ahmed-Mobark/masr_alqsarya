import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/config/app_icons.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/toast/app_toast.dart';
import 'package:masr_al_qsariya/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:masr_al_qsariya/features/auth/presentation/view/login_view.dart';
import 'package:masr_al_qsariya/features/auth/presentation/view/verification_view.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_bottom_link.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_divider.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_field.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_phone_number_field.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_social_button.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_text_input.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/sign_up_terms.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (previous, current) =>
            previous.action != current.action ||
            previous.submitError != current.submitError,
        listener: (context, state) {
          if (state.submitError != null && state.submitError!.isNotEmpty) {
            appToast(
              context: context,
              type: ToastType.error,
              message: state.submitError!,
            );
            context.read<AuthCubit>().clearSubmitError();
          }

          switch (state.action) {
            case AuthAction.navigateToVerification:
              sl<AppNavigator>().push(
                screen: VerificationView(email: state.registeredEmail),
              );
              context.read<AuthCubit>().clearAction();
              return;
            case AuthAction.navigateToLogin:
              sl<AppNavigator>().pushReplacement(screen: const LoginView());
              context.read<AuthCubit>().clearAction();
              return;
            case null:
            case AuthAction.navigateToHome:
            case AuthAction.navigateToRoleOptions:
            case AuthAction.navigateToSignUp:
            case AuthAction.navigateToForgotPassword:
            case AuthAction.navigateToForgotPasswordOtp:
            case AuthAction.navigateToResetPassword:
            case AuthAction.passwordResetSuccess:
            case AuthAction.coPartnerInvited:
            case AuthAction.childAdded:
              return;
          }
        },
        builder: (context, state) {
          final cubit = context.read<AuthCubit>();

          return Scaffold(
            backgroundColor: AppColors.scaffoldColorLight,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Form(
                  key: cubit.signUpFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12.h),
                      AuthBackButton(onTap: () => Navigator.pop(context)),
                      SizedBox(height: 14.h),
                      Center(
                        child: Text(
                          context.tr.authSignUpTitle,
                          style: AppTextStyles.heading2().copyWith(
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),
                      Text(
                        context.tr.authSignUpIntroTitle,
                        style: AppTextStyles.heading2().copyWith(
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        context.tr.authSignUpIntroSubtitle,
                        style: AppTextStyles.body(
                          color: AppColors.greyText,
                        ).copyWith(fontSize: 13.sp, height: 1.45),
                      ),
                      SizedBox(height: 28.h),
                      AuthField(
                        label: context.tr.authFullNameLabel,
                        child: AuthTextInput(
                          controller: cubit.signUpFullNameController,
                          hint: context.tr.authFullNameHint,
                          keyboardType: TextInputType.name,
                          validator: (value) => cubit.validateName(value),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                        ),
                      ),
                      SizedBox(height: 18.h),
                      AuthField(
                        label: context.tr.authEmailLabel,
                        child: AuthTextInput(
                          controller: cubit.signUpEmailController,
                          hint: context.tr.authEmailEntryHint,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => cubit.validateEmail(value),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                        ),
                      ),
                      SizedBox(height: 18.h),
                      AuthField(
                        label: context.tr.authPhoneLabel,
                        child: AuthPhoneNumberField(
                          controller: cubit.signUpPhoneController,
                          hint: context.tr.authPhoneLabel,
                          validator: (value) => cubit.validatePhone(value),
                          selectedDialCode: state.selectedDialCode,
                          onDialCodeChanged: cubit.setSelectedDialCode,
                        ),
                      ),
                      SizedBox(height: 18.h),
                      AuthField(
                        label: context.tr.authPasswordLabel,
                        child: AuthTextInput(
                          controller: cubit.signUpPasswordController,
                          hint: context.tr.authPasswordHint,
                          obscureText: state.isSignUpPasswordObscured,
                          validator: (value) => cubit.validatePassword(value),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          suffixWidget: IconButton(
                            onPressed: cubit.toggleSignUpPasswordVisibility,
                            icon: Icon(
                              state.isSignUpPasswordObscured
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppColors.greyText,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 18.h),
                      AuthField(
                        label: context.tr.authConfirmPasswordLabel,
                        child: AuthTextInput(
                          controller: cubit.signUpConfirmPasswordController,
                          hint: context.tr.authPasswordHint,
                          obscureText: state.isSignUpConfirmPasswordObscured,
                          validator: (value) =>
                              cubit.validateConfirmPassword(value),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          suffixWidget: IconButton(
                            onPressed:
                                cubit.toggleSignUpConfirmPasswordVisibility,
                            icon: Icon(
                              state.isSignUpConfirmPasswordObscured
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppColors.greyText,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 14.h),
                      SignUpTerms(
                        value: state.hasAcceptedTerms,
                        showError: state.showTermsError,
                        onChanged: cubit.setTermsAccepted,
                      ),
                      SizedBox(height: 28.h),
                      AuthPrimaryButton(
                        text: context.tr.authSignUpButton,
                        onPressed: cubit.submitSignUp,
                        height: 48.h,
                        isLoading: state.isSubmitting,
                      ),
                      SizedBox(height: 32.h),
                      AuthDivider(label: context.tr.authOrShort),
                      SizedBox(height: 18.h),
                      AuthSocialButton(
                        label: context.tr.authContinueWithGoogle,
                        iconPath: AppIcons.googleIcon,
                        onTap: () {},
                        height: 48.h,
                      ),
                      SizedBox(height: 14.h),
                      AuthSocialButton(
                        label: context.tr.authContinueWithApple,
                        iconPath: AppIcons.appleIcon,
                        onTap: () {},
                        height: 48.h,
                      ),
                      SizedBox(height: 24.h),
                      Center(
                        child: AuthBottomLink(
                          prefixText: context.tr.authAlreadyHaveAccountPrefix,
                          linkText: context.tr.authLoginLink,
                          onTap: cubit.goToLogin,
                        ),
                      ),
                      SizedBox(height: 18.h),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
