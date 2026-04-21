import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/toast/app_toast.dart';
import 'package:masr_al_qsariya/core/utils/validator.dart';
import 'package:masr_al_qsariya/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_field.dart';
import 'package:masr_al_qsariya/features/nav_bar/presentation/view/main_nav_view.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_phone_number_field.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_text_input.dart';
/// Onboarding step after co-parent invite: POST [add-child], then main shell.
class AddChildView extends StatelessWidget {
  const AddChildView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
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

          if (state.action == AuthAction.childAdded) {
            context.read<AuthCubit>().clearAction();
            sl<AppNavigator>().pushAndRemoveUntil(
              screen: const MainNavView(),
            );
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
                        key: cubit.addChildFormKey,
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
                                      context.tr.authOnboardingAddChildTitle,
                                      style: AppTextStyles.heading2(),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 36.w),
                              ],
                            ),
                            SizedBox(height: 32.h),
                            Text(
                              context.tr.authOnboardingAddChildHeading,
                              style: AppTextStyles.heading2(),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              context.tr.authOnboardingAddChildSubtitle,
                              style: AppTextStyles.caption(
                                color: AppColors.greyText,
                              ),
                            ),
                            SizedBox(height: 24.h),
                            AuthField(
                              label: context.tr.familyChildDisplayNameLabel,
                              child: AuthTextInput(
                                controller: cubit.childDisplayNameController,
                                hint: context.tr.familyChildDisplayNameHint,
                                keyboardType: TextInputType.name,
                                validator: (v) => Validator.defaultValidator(v),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            AuthField(
                              label: context.tr.familyChildFirstNameLabel,
                              child: AuthTextInput(
                                controller: cubit.childFirstNameController,
                                hint: context.tr.familyChildFirstNameHint,
                                keyboardType: TextInputType.name,
                                validator: (v) => cubit.validateName(v),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            AuthField(
                              label: context.tr.familyChildLastNameLabel,
                              child: AuthTextInput(
                                controller: cubit.childLastNameController,
                                hint: context.tr.familyChildLastNameHint,
                                keyboardType: TextInputType.name,
                                validator: (v) => cubit.validateName(v),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            AuthField(
                              label: context.tr.familyChildEmailLabel,
                              child: AuthTextInput(
                                controller: cubit.childEmailController,
                                hint: context.tr.familyChildEmailHint,
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) => cubit.validateEmail(v),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            AuthField(
                              label: context.tr.familyChildPhoneLabel,
                              child: AuthPhoneNumberField(
                                controller: cubit.childPhoneController,
                                hint: context.tr.familyChildPhoneHint,
                                validator: (v) => cubit.validatePhone(v),
                                selectedDialCode: state.childDialCode,
                                onDialCodeChanged: cubit.setChildDialCode,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            AuthField(
                              label: context.tr.familyChildDateOfBirthLabel,
                              child: GestureDetector(
                                onTap: () async {
                                  final now = DateTime.now();
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        now.subtract(const Duration(days: 365 * 8)),
                                    firstDate: DateTime(1900),
                                    lastDate: now,
                                  );
                                  if (picked != null) {
                                    cubit.childDateOfBirthController.text =
                                        '${picked.day.toString().padLeft(2, '0')}-'
                                        '${picked.month.toString().padLeft(2, '0')}-'
                                        '${picked.year}';
                                  }
                                },
                                child: AbsorbPointer(
                                  child: AuthTextInput(
                                    controller: cubit.childDateOfBirthController,
                                    hint: context.tr.familyChildDateOfBirthHint,
                                    validator: (v) => Validator.dateOfBirth(v),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 8.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: state.isSubmitting
                                ? null
                                : cubit.submitAddChildAddAnother,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.darkText,
                              side: const BorderSide(color: AppColors.border),
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: Text(
                              context.tr.authAddAnotherChild,
                              style: AppTextStyles.button(),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: state.isSubmitting
                                ? null
                                : cubit.submitAddChild,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.darkText,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: state.isSubmitting
                                ? SizedBox(
                                    width: 22.w,
                                    height: 22.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.darkText,
                                    ),
                                  )
                                : Text(
                                    context.tr.authNext.toUpperCase(),
                                    style: AppTextStyles.button(
                                      color: AppColors.darkText,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          );
        },
    );
  }
}
