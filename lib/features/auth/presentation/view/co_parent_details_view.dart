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
import 'package:masr_al_qsariya/features/auth/presentation/view/add_child_view.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_field.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_phone_number_field.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_text_input.dart';

class CoParentDetailsView extends StatelessWidget {
  const CoParentDetailsView({super.key});

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
            case AuthAction.coPartnerInvited:
              context.read<AuthCubit>().clearAction();
              sl<AppNavigator>().pushAndRemoveUntil(
                screen: BlocProvider(
                  create: (_) => sl<AuthCubit>(),
                  child: const AddChildView(),
                ),
              );
              return;
            case null:
            case AuthAction.navigateToHome:
            case AuthAction.navigateToVerification:
            case AuthAction.navigateToRoleOptions:
            case AuthAction.navigateToLogin:
            case AuthAction.navigateToSignUp:
            case AuthAction.navigateToForgotPassword:
            case AuthAction.navigateToForgotPasswordOtp:
            case AuthAction.navigateToResetPassword:
            case AuthAction.passwordResetSuccess:
            case AuthAction.childAdded:
            case AuthAction.familyWorkspaceUpgraded:
              return;
          }
        },
        builder: (context, state) {
          final cubit = context.read<AuthCubit>();

          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Form(
                        key: cubit.coPartnerFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16.h),
                            Row(
                              children: [
                                SizedBox(width: 36.w),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      context.tr.authCoParentDetailsTitle,
                                      style: AppTextStyles.heading2(),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 36.w),
                              ],
                            ),
                            SizedBox(height: 32.h),
                            Text(
                              context.tr.authCoParentDetailsHeading,
                              style: AppTextStyles.heading2(),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              context.tr.authCoParentDetailsSubtitle,
                              style: AppTextStyles.caption(
                                color: AppColors.greyText,
                              ),
                            ),
                            SizedBox(height: 24.h),
                            AuthField(
                              label: context.tr.authCoParentFirstName,
                              child: AuthTextInput(
                                controller: cubit.coPartnerFirstNameController,
                                hint: context.tr.authCoParentFirstName,
                                keyboardType: TextInputType.name,
                                validator: (value) =>
                                    cubit.validateName(value),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            AuthField(
                              label: context.tr.authCoParentLastName,
                              child: AuthTextInput(
                                controller: cubit.coPartnerLastNameController,
                                hint: context.tr.authCoParentLastName,
                                keyboardType: TextInputType.name,
                                validator: (value) =>
                                    cubit.validateName(value),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            AuthField(
                              label: context.tr.authCoParentEmail,
                              child: AuthTextInput(
                                controller: cubit.coPartnerEmailController,
                                hint: context.tr.authEmailEntryHint,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) =>
                                    cubit.validateEmail(value),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            AuthField(
                              label: context.tr.authCoParentPhone,
                              child: AuthPhoneNumberField(
                                controller: cubit.coPartnerPhoneController,
                                hint: context.tr.authPhoneLabel,
                                validator: (value) =>
                                    cubit.validatePhone(value),
                                selectedDialCode: state.coPartnerDialCode,
                                onDialCodeChanged:
                                    cubit.setCoPartnerDialCode,
                              ),
                            ),
                            SizedBox(height: 16.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 8.h),
                    child: AuthPrimaryButton(
                      text: context.tr.authContinue.toUpperCase(),
                      onPressed: cubit.submitInviteCoPartner,
                      height: 48.h,
                      isLoading: state.isSubmitting,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
                    child: Text(
                      context.tr.authCoParentNote,
                      textAlign: TextAlign.center,
                      style:
                          AppTextStyles.caption(color: AppColors.greyText),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
