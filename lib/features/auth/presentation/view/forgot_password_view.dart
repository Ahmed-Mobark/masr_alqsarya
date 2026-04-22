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
import 'package:masr_al_qsariya/features/auth/presentation/view/forgot_password_otp_view.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_field.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_text_input.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key, this.prefilledEmail});

  /// When set (e.g. from Account & Security), the email field is prefilled.
  final String? prefilledEmail;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<AuthCubit>();
        final email = prefilledEmail?.trim();
        if (email != null && email.isNotEmpty) {
          cubit.forgotPasswordEmailController.text = email;
          cubit.setForgotPasswordEmail(email);
        }
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

          if (state.action == AuthAction.navigateToForgotPasswordOtp) {
            sl<AppNavigator>().push(
              screen: ForgotPasswordOtpView(email: state.forgotPasswordEmail),
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
                  key: cubit.forgotPasswordFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12.h),
                      AuthBackButton(onTap: () => Navigator.pop(context)),
                      SizedBox(height: 14.h),
                      Center(
                        child: Text(
                          context.tr.authForgotPasswordTitle,
                          style: AppTextStyles.heading2().copyWith(
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 34.h),
                      Text(
                        context.tr.authForgotPasswordHeading,
                        style: AppTextStyles.heading2().copyWith(
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        context.tr.authForgotPasswordSubtitle,
                        style: AppTextStyles.body(
                          color: AppColors.greyText,
                        ).copyWith(fontSize: 13.sp, height: 1.45),
                      ),
                      SizedBox(height: 30.h),
                      AuthField(
                        label: context.tr.authEmailLabel,
                        child: AuthTextInput(
                          controller: cubit.forgotPasswordEmailController,
                          hint: context.tr.authEmailEntryHint,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => cubit.validateEmail(value),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      AuthPrimaryButton(
                        text: context.tr.authForgotPasswordButton,
                        onPressed: cubit.submitForgotPassword,
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
