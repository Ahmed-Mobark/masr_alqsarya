import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/toast/app_toast.dart';
import 'package:masr_al_qsariya/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:masr_al_qsariya/features/auth/presentation/view/login_view.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_field.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_text_input.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key, this.email, this.code});

  final String? email;
  final String? code;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<AuthCubit>();
        if (email != null) cubit.setForgotPasswordEmail(email!);
        if (code != null) cubit.setResetCode(code!);
        return cubit;
      },
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

          if (state.action == AuthAction.passwordResetSuccess) {
            appToast(
              context: context,
              type: ToastType.success,
              message: context.tr.authPasswordResetSuccess,
            );
            sl<AppNavigator>().pushAndRemoveUntil(
              screen: const LoginView(),
            );
            context.read<AuthCubit>().clearAction();
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
                  key: cubit.resetPasswordFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12.h),
                      AuthBackButton(onTap: () => Navigator.pop(context)),
                      SizedBox(height: 14.h),
                      Center(
                        child: Text(
                          context.tr.authResetPasswordTitle,
                          style: AppTextStyles.heading2().copyWith(
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 34.h),
                      Text(
                        context.tr.authResetPasswordHeading,
                        style: AppTextStyles.heading2().copyWith(
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        context.tr.authResetPasswordSubtitle,
                        style: AppTextStyles.body(
                          color: AppColors.greyText,
                        ).copyWith(fontSize: 13.sp, height: 1.45),
                      ),
                      SizedBox(height: 30.h),
                      AuthField(
                        label: context.tr.authNewPasswordLabel,
                        child: AuthTextInput(
                          controller: cubit.resetPasswordController,
                          hint: context.tr.authNewPasswordHint,
                          obscureText: state.isResetPasswordObscured,
                          validator: (value) => cubit.validatePassword(value),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          suffixWidget: IconButton(
                            onPressed: cubit.toggleResetPasswordVisibility,
                            icon: Icon(
                              state.isResetPasswordObscured
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
                        label: context.tr.authConfirmNewPasswordLabel,
                        child: AuthTextInput(
                          controller: cubit.resetConfirmPasswordController,
                          hint: context.tr.authNewPasswordHint,
                          obscureText: state.isResetConfirmPasswordObscured,
                          validator: (value) =>
                              cubit.validateResetConfirmPassword(value),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          suffixWidget: IconButton(
                            onPressed:
                                cubit.toggleResetConfirmPasswordVisibility,
                            icon: Icon(
                              state.isResetConfirmPasswordObscured
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppColors.greyText,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      AuthPrimaryButton(
                        text: context.tr.authResetPasswordButton,
                        onPressed: cubit.submitResetPassword,
                        isLoading: state.isSubmitting,
                      ),
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
