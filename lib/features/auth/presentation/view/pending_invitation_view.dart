import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/config/app_images.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/toast/app_toast.dart';
import 'package:masr_al_qsariya/features/auth/domain/entities/pending_invitation.dart';
import 'package:masr_al_qsariya/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:masr_al_qsariya/features/nav_bar/presentation/view/main_nav_view.dart';
import 'package:masr_al_qsariya/features/onboarding/presentation/view/onboarding_view.dart';

class PendingInvitationView extends StatelessWidget {
  const PendingInvitationView({super.key, required this.pendingInvitation});

  final PendingInvitation pendingInvitation;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>()..setPendingInvitation(pendingInvitation),
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
              sl<AppNavigator>().pushAndRemoveUntil(
                screen: const MainNavView(),
              );
              context.read<AuthCubit>().clearAction();
              return;
            case AuthAction.navigateToLogin:
              sl<AppNavigator>().pushAndRemoveUntil(
                screen: const OnboardingView(initialPage: 3),
              );
              context.read<AuthCubit>().clearAction();
              return;
            case null:
            case AuthAction.navigateToPendingInvitation:
            case AuthAction.navigateToVerification:
            case AuthAction.navigateToRoleOptions:
            case AuthAction.navigateToSignUp:
            case AuthAction.navigateToForgotPassword:
            case AuthAction.navigateToForgotPasswordOtp:
            case AuthAction.navigateToResetPassword:
            case AuthAction.passwordResetSuccess:
            case AuthAction.coPartnerInvited:
            case AuthAction.childAdded:
            case AuthAction.familyWorkspaceUpgraded:
              return;
          }
        },
        builder: (context, state) {
          final cubit = context.read<AuthCubit>();
          final pending = state.pendingInvitation ?? pendingInvitation;

          return Scaffold(
            backgroundColor: AppColors.scaffoldColorLight,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 17.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    Center(
                      child: Text(
                        context.tr.pendingInvitationTitle,
                        style: AppTextStyles.heading2().copyWith(
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                    Image.asset(
                      AppImages.pendingInvitation,
                      width: 55.w,
                      height: 12.h,
                    ),
                    Text(
                      context.tr.pendingInvitationSubtitle,
                      style: AppTextStyles.body(
                        color: AppColors.greyText,
                      ).copyWith(fontSize: 13.sp, height: 1.45),
                    ),
                    SizedBox(height: 18.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: AppColors.inputBg,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _InfoRow(
                            label: context.tr.pendingInvitationWorkspaceLabel,
                            value: pending.workspaceName,
                          ),
                          SizedBox(height: 10.h),
                          _InfoRow(
                            label: context.tr.pendingInvitationInvitedByLabel,
                            value: pending.invitedByName,
                          ),
                          // SizedBox(height: 10.h),
                          // _InfoRow(
                          //   label: context.tr.pendingInvitationRoleLabel,
                          //   value: pending.role,
                          // ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state.isSubmitting
                            ? null
                            : () => cubit.respondToPendingInvitation(
                                accept: true,
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.darkText,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                        child: state.isSubmitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.darkText,
                                ),
                              )
                            : Text(
                                context.tr.pendingInvitationAccept,
                                style: AppTextStyles.button(
                                  color: AppColors.darkText,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: state.isSubmitting
                            ? null
                            : () => cubit.respondToPendingInvitation(
                                accept: false,
                              ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.border),
                          foregroundColor: AppColors.darkText,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                        child: Text(
                          context.tr.pendingInvitationReject,
                          style: AppTextStyles.button(
                            color: AppColors.darkText,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 18.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120.w,
          child: Text(
            label,
            style: AppTextStyles.caption(color: AppColors.greyText),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium(color: AppColors.darkText),
          ),
        ),
      ],
    );
  }
}
