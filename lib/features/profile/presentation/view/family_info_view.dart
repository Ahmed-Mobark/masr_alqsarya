import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/toast/app_toast.dart';
import 'package:masr_al_qsariya/features/auth/presentation/cubit/auth_cubit.dart';

class FamilyInfoView extends StatelessWidget {
  const FamilyInfoView({super.key});

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

          if (state.action == AuthAction.childAdded) {
            appToast(
              context: context,
              type: ToastType.success,
              message: context.tr.familyChildAddedSuccess,
            );
            context.read<AuthCubit>().clearAction();
          }
        },
        builder: (context, state) {
          final cubit = context.read<AuthCubit>();

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.darkText,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                context.tr.familyInfoTitle,
                style: AppTextStyles.heading2(),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCoParentCard(context),
                  const SizedBox(height: 24),
                  Text(
                    context.tr.familyChildrenTitle,
                    style: AppTextStyles.heading2(),
                  ),
                  const SizedBox(height: 12),

                  // Add Child button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _showAddChildSheet(context, cubit, state),
                      icon: const Icon(Iconsax.add, size: 20),
                      label: Text(
                        context.tr.familyAddChild,
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.primaryDark,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryDark,
                        side: const BorderSide(
                          color: AppColors.primaryDark,
                          style: BorderStyle.solid,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        appToast(
                          context: context,
                          type: ToastType.success,
                          message: context.tr.familyInfoSaved,
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.darkText,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        context.tr.commonSave,
                        style: AppTextStyles.button(),
                      ),
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

  Widget _buildCoParentCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryDark.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Iconsax.user,
                  color: AppColors.primaryDark,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr.familyCoParent,
                      style: AppTextStyles.caption(),
                    ),
                    const SizedBox(height: 2),
                    Text('Fatima Ali', style: AppTextStyles.bodyMedium()),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  context.tr.familyConnected,
                  style: AppTextStyles.small(color: AppColors.success),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Iconsax.sms, size: 16, color: AppColors.greyText),
              const SizedBox(width: 8),
              Text('fatima.ali@email.com', style: AppTextStyles.caption()),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddChildSheet(
    BuildContext context,
    AuthCubit cubit,
    AuthState state,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return BlocProvider.value(
          value: cubit,
          child: BlocConsumer<AuthCubit, AuthState>(
            listenWhen: (previous, current) =>
                previous.action != current.action ||
                previous.submitError != current.submitError,
            listener: (ctx, st) {
              if (st.submitError != null && st.submitError!.isNotEmpty) {
                appToast(
                  context: ctx,
                  type: ToastType.error,
                  message: st.submitError!,
                );
                cubit.clearSubmitError();
              }
              if (st.action == AuthAction.childAdded) {
                cubit.clearAction();
                Navigator.pop(ctx);
                appToast(
                  context: context,
                  type: ToastType.success,
                  message: context.tr.familyChildAddedSuccess,
                );
              }
            },
            builder: (ctx, st) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom,
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24.w),
                  child: Form(
                    key: cubit.addChildFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.border,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          context.tr.familyAddChild,
                          style: AppTextStyles.heading2(),
                        ),
                        SizedBox(height: 20.h),
                        _buildField(
                          label: context.tr.familyChildDisplayNameLabel,
                          hint: context.tr.familyChildDisplayNameHint,
                          controller: cubit.childDisplayNameController,
                        ),
                        SizedBox(height: 14.h),
                        _buildField(
                          label: context.tr.familyChildFirstNameLabel,
                          hint: context.tr.familyChildFirstNameHint,
                          controller: cubit.childFirstNameController,
                          validator: (v) => cubit.validateName(v),
                        ),
                        SizedBox(height: 14.h),
                        _buildField(
                          label: context.tr.familyChildLastNameLabel,
                          hint: context.tr.familyChildLastNameHint,
                          controller: cubit.childLastNameController,
                          validator: (v) => cubit.validateName(v),
                        ),
                        SizedBox(height: 14.h),
                        _buildField(
                          label: context.tr.familyChildEmailLabel,
                          hint: context.tr.familyChildEmailHint,
                          controller: cubit.childEmailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) => cubit.validateEmail(v),
                        ),
                        SizedBox(height: 14.h),
                        _buildField(
                          label: context.tr.familyChildPhoneLabel,
                          hint: context.tr.familyChildPhoneHint,
                          controller: cubit.childPhoneController,
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 14.h),
                        _buildDateField(
                          context: ctx,
                          label: context.tr.familyChildDateOfBirthLabel,
                          hint: context.tr.familyChildDateOfBirthHint,
                          controller: cubit.childDateOfBirthController,
                        ),
                        SizedBox(height: 24.h),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: st.isSubmitting
                                ? null
                                : cubit.submitAddChild,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.darkText,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: st.isSubmitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.darkText,
                                    ),
                                  )
                                : Text(
                                    context.tr.commonAdd,
                                    style: AppTextStyles.button(
                                      color: AppColors.darkText,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption(color: AppColors.darkText)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: AppTextStyles.body(),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.body(color: AppColors.greyText),
            filled: true,
            fillColor: AppColors.inputBg,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required BuildContext context,
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption(color: AppColors.darkText)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            final now = DateTime.now();
            final picked = await showDatePicker(
              context: context,
              initialDate: now.subtract(const Duration(days: 365 * 5)),
              firstDate: DateTime(1900),
              lastDate: now,
            );
            if (picked != null) {
              controller.text =
                  '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              controller: controller,
              style: AppTextStyles.body(),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: AppTextStyles.body(color: AppColors.greyText),
                filled: true,
                fillColor: AppColors.inputBg,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                suffixIcon: const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: AppColors.primaryDark,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
