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
import 'package:masr_al_qsariya/features/auth/presentation/view/sign_up_view.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_bottom_link.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_divider.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_field.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_social_button.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_text_input.dart';
import 'package:masr_al_qsariya/features/home/presentation/view/home_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

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
            case AuthAction.navigateToHome:
              sl<AppNavigator>().pushAndRemoveUntil(screen: const HomeView());
              context.read<AuthCubit>().clearAction();
              return;
            case AuthAction.navigateToSignUp:
              sl<AppNavigator>().push(screen: const SignUpView());
              context.read<AuthCubit>().clearAction();
              return;
            case null:
            case AuthAction.navigateToVerification:
            case AuthAction.navigateToLogin:
              return;
          }
        },
        builder: (context, state) {
          final cubit = context.read<AuthCubit>();

          return Scaffold(
            backgroundColor: AppColors.scaffoldColorLight,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 17.w),
                child: Form(
                  key: cubit.loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12.h),
                      AuthBackButton(onTap: () => Navigator.pop(context)),
                      SizedBox(height: 14.h),
                      Center(
                        child: Text(
                          context.tr.authLoginTitle,
                          style: AppTextStyles.heading2().copyWith(
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 34.h),
                      Text(
                        context.tr.authLoginIntroTitle,
                        style: AppTextStyles.heading2().copyWith(
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        context.tr.authLoginIntroSubtitle,
                        style: AppTextStyles.body(
                          color: AppColors.greyText,
                        ).copyWith(fontSize: 13.sp, height: 1.45),
                      ),
                      SizedBox(height: 30.h),
                      AuthField(
                        label: context.tr.authEmailLabel,
                        child: AuthTextInput(
                          controller: cubit.loginEmailController,
                          hint: context.tr.authEmailEntryHint,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => cubit.validateEmail(value),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      AuthField(
                        label: context.tr.authPasswordLabel,
                        child: AuthTextInput(
                          controller: cubit.loginPasswordController,
                          hint: context.tr.authPasswordHint,
                          obscureText: state.isLoginPasswordObscured,
                          validator: (value) => cubit.validatePassword(value),
                          suffixWidget: IconButton(
                            onPressed: cubit.toggleLoginPasswordVisibility,
                            icon: Icon(
                              state.isLoginPasswordObscured
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppColors.greyText,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 4.h,
                            ),
                            child: Text(
                              context.tr.authForgotPassword,
                              style: AppTextStyles.caption(
                                color: AppColors.greyText,
                              ).copyWith(fontSize: 12.sp),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      AuthPrimaryButton(
                        text: context.tr.authLoginButton,
                        onPressed: cubit.submitLogin,
                        isLoading: state.isSubmitting,
                      ),
                      SizedBox(height: 36.h),
                      AuthDivider(label: context.tr.authOrShort),
                      SizedBox(height: 18.h),
                      AuthSocialButton(
                        label: context.tr.authContinueWithGoogle,
                        iconPath: AppIcons.googleIcon,
                        onTap: () {},
                      ),
                      SizedBox(height: 14.h),
                      AuthSocialButton(
                        label: context.tr.authContinueWithApple,
                        iconPath: AppIcons.appleIcon,
                        onTap: () {},
                      ),
                      SizedBox(height: 24.h),
                      Center(
                        child: AuthBottomLink(
                          prefixText: context.tr.authDontHaveAccountPrefix,
                          linkText: context.tr.authSignUp,
                          onTap: cubit.goToSignUp,
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
