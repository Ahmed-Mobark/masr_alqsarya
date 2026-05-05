import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/toast/app_toast.dart';
import 'package:masr_al_qsariya/features/auth/presentation/cubit/change_password_cubit.dart';
import 'package:masr_al_qsariya/features/auth/presentation/cubit/change_password_state.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_field.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_text_input.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChangePasswordCubit>(),
      child: const _ChangePasswordBody(),
    );
  }
}

class _ChangePasswordBody extends StatelessWidget {
  const _ChangePasswordBody();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
      listenWhen: (p, c) =>
          p.status != c.status ||
          (p.errorMessage != c.errorMessage && c.errorMessage != null),
      listener: (context, state) async {
        if (state.status == ChangePasswordStatus.failure &&
            (state.errorMessage ?? '').isNotEmpty) {
          await appToast(
            context: context,
            type: ToastType.error,
            message: state.errorMessage!,
          );
          if (context.mounted) {
            context.read<ChangePasswordCubit>().resetStatusAfterHandled();
          }
          return;
        }
        if (state.status == ChangePasswordStatus.success) {
          await appToast(
            context: context,
            type: ToastType.success,
            message: context.tr.accountSecurityPasswordChangedSuccess,
          );
          if (context.mounted) {
            Navigator.pop(context);
          }
        }
      },
      builder: (context, state) {
        final cubit = context.read<ChangePasswordCubit>();
        final isLoading = state.status == ChangePasswordStatus.loading;

        return Scaffold(
          backgroundColor: AppColors.scaffoldColorLight,
          appBar: AppBar(
            backgroundColor: AppColors.scaffoldColorLight,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.darkText, size: 22.sp),
              onPressed: isLoading ? null : () => Navigator.pop(context),
            ),
            title: Text(
              context.tr.accountSecurityChangePassword,
              style: AppTextStyles.heading2().copyWith(fontSize: 18.sp),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Form(
                key: cubit.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),
                    Text(
                      context.tr.accountSecurityChangePasswordSubtitle,
                      style: AppTextStyles.body(
                        color: AppColors.greyText,
                      ).copyWith(fontSize: 13.sp, height: 1.45),
                    ),
                    SizedBox(height: 24.h),
                    AuthField(
                      label: context.tr.accountSecurityCurrentPasswordLabel,
                      child: AuthTextInput(
                        controller: cubit.currentPasswordController,
                        hint: context.tr.authPasswordHint,
                        obscureText: state.obscureCurrent,
                        validator: cubit.validateCurrentPassword,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                        suffixWidget: IconButton(
                          onPressed: cubit.toggleObscureCurrent,
                          icon: Icon(
                            state.obscureCurrent
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
                      label: context.tr.authNewPasswordLabel,
                      child: AuthTextInput(
                        controller: cubit.newPasswordController,
                        hint: context.tr.authNewPasswordHint,
                        obscureText: state.obscureNew,
                        validator: cubit.validateNewPassword,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                        suffixWidget: IconButton(
                          onPressed: cubit.toggleObscureNew,
                          icon: Icon(
                            state.obscureNew
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
                        controller: cubit.confirmPasswordController,
                        hint: context.tr.authNewPasswordHint,
                        obscureText: state.obscureConfirm,
                        validator: cubit.validateConfirmPassword,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                        suffixWidget: IconButton(
                          onPressed: cubit.toggleObscureConfirm,
                          icon: Icon(
                            state.obscureConfirm
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.greyText,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 28.h),
                    AuthPrimaryButton(
                      text: context.tr.commonSave,
                      onPressed: () => cubit.submit(),
                      isLoading: isLoading,
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
