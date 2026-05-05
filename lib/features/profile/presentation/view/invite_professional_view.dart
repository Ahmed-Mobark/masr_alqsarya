import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/storage/workspace_id_storage.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/toast/app_toast.dart';
import 'package:masr_al_qsariya/core/utils/validator.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/invite_co_partner_usecase.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_field.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_phone_number_field.dart';

/// Invites via `POST family-workspace/invite-professional` (multipart `professional_type`).
class InviteProfessionalView extends StatefulWidget {
  const InviteProfessionalView({super.key, this.onSuccess});

  final VoidCallback? onSuccess;

  @override
  State<InviteProfessionalView> createState() => _InviteProfessionalViewState();
}

class _InviteProfessionalViewState extends State<InviteProfessionalView> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  String _dialCode = '+20';
  String _type = InviteCoPartnerParams.typeTherapist;
  bool _submitting = false;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final phoneDigits = _phone.text.trim();
    if (phoneDigits.isEmpty) {
      await appToast(
        context: context,
        type: ToastType.error,
        message: context.tr.errorFieldRequired,
      );
      return;
    }

    final workspaceId = sl<WorkspaceIdStorage>().get();
    if (workspaceId == null) {
      await appToast(
        context: context,
        type: ToastType.error,
        message: context.tr.familyInfoNoWorkspace,
      );
      return;
    }

    setState(() => _submitting = true);
    final fullPhone = '$_dialCode$phoneDigits';

    final result = await sl<InviteCoPartnerUseCase>()(
      InviteCoPartnerParams(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        phone: fullPhone,
        email: _email.text.trim(),
        type: _type,
        workspaceId: workspaceId,
      ),
    );

    if (!mounted) return;
    setState(() => _submitting = false);

    await result.fold<Future<void>>(
      (failure) async {
        await appToast(
          context: context,
          type: ToastType.error,
          message: failure.message,
        );
      },
      (_) async {
        await appToast(
          context: context,
          type: ToastType.success,
          message: context.tr.familyInfoLawyerInviteSuccess,
        );
        widget.onSuccess?.call();
        sl<AppNavigator>().pop();
      },
    );
  }

  static const double _fieldRadius = 14;

  /// Matches typed value color across this form (dropdown + text fields).
  TextStyle get _fieldValueStyle =>
      AppTextStyles.body(color: AppColors.darkText);

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.body(color: AppColors.greyText),
      filled: true,
      fillColor: AppColors.inputBg,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_fieldRadius.r),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_fieldRadius.r),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_fieldRadius.r),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.inputBg,
      isDense: true,
      contentPadding: EdgeInsetsDirectional.fromSTEB(16.w, 10.h, 10.w, 10.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_fieldRadius.r),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_fieldRadius.r),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_fieldRadius.r),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp),
          color: AppColors.darkText,
          onPressed: _submitting ? null : () => sl<AppNavigator>().pop(),
        ),
        title: Text(
          tr.inviteProfessionalTitle,
          style: AppTextStyles.heading2().copyWith(fontSize: 17.sp),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.h),
                      Text(
                        tr.inviteProfessionalSubtitle,
                        style: AppTextStyles.body(
                          color: AppColors.greyText,
                        ).copyWith(height: 1.45, fontSize: 13.sp),
                      ),
                      SizedBox(height: 24.h),
                      AuthField(
                        label: tr.inviteProfessionalTypeLabel,
                        child: InputDecorator(
                          decoration: _dropdownDecoration(),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              isDense: true,
                              padding: EdgeInsets.zero,
                              value: _type,
                              borderRadius: BorderRadius.circular(
                                _fieldRadius.r,
                              ),
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppColors.greyText,
                                size: 20.sp,
                              ),
                              style: _fieldValueStyle,
                              selectedItemBuilder: (context) => [
                                Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Text(
                                    tr.inviteProfessionalTypeTherapist,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: _fieldValueStyle,
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Text(
                                    tr.inviteProfessionalTypeLawyer,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: _fieldValueStyle,
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Text(
                                    tr.inviteProfessionalTypeOther,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: _fieldValueStyle,
                                  ),
                                ),
                              ],
                              items: [
                                DropdownMenuItem(
                                  value: InviteCoPartnerParams.typeTherapist,
                                  child: Text(
                                    tr.inviteProfessionalTypeTherapist,
                                    style: _fieldValueStyle,
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: InviteCoPartnerParams.typeLawyer,
                                  child: Text(
                                    tr.inviteProfessionalTypeLawyer,
                                    style: _fieldValueStyle,
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: InviteCoPartnerParams.typeOther,
                                  child: Text(
                                    tr.inviteProfessionalTypeOther,
                                    style: _fieldValueStyle,
                                  ),
                                ),
                              ],
                              onChanged: _submitting
                                  ? null
                                  : (v) {
                                      if (v != null) {
                                        setState(() => _type = v);
                                      }
                                    },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      AuthField(
                        label: tr.inviteProfessionalFirstNameLabel,
                        child: TextFormField(
                          controller: _firstName,
                          enabled: !_submitting,
                          validator: (v) => Validator.name(v),
                          style: _fieldValueStyle,
                          decoration: _fieldDecoration(
                            tr.inviteProfessionalFirstNameHint,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      AuthField(
                        label: tr.inviteProfessionalLastNameLabel,
                        child: TextFormField(
                          controller: _lastName,
                          enabled: !_submitting,
                          validator: (v) => Validator.name(v),
                          style: _fieldValueStyle,
                          decoration: _fieldDecoration(
                            tr.inviteProfessionalLastNameHint,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      AuthField(
                        label: tr.inviteProfessionalEmailLabel,
                        child: TextFormField(
                          controller: _email,
                          enabled: !_submitting,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) => Validator.email(v),
                          style: _fieldValueStyle,
                          decoration: _fieldDecoration(
                            tr.inviteProfessionalEmailHint,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      AuthField(
                        label: tr.inviteProfessionalPhoneLabel,
                        child: AuthPhoneNumberField(
                          controller: _phone,
                          hint: tr.inviteProfessionalPhoneHint,
                          validator: (v) => Validator.numbers(v),
                          selectedDialCode: _dialCode,
                          onDialCodeChanged: (c) =>
                              setState(() => _dialCode = c),
                          fillColor: AppColors.inputBg,
                          borderRadius: _fieldRadius,
                          borderColor: AppColors.border,
                          focusedBorderColor: AppColors.primary,
                          contentPadding: EdgeInsetsDirectional.fromSTEB(
                            0,
                            14.h,
                            16.w,
                            14.h,
                          ),
                          textColor: AppColors.darkText,
                        ),
                      ),
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
              child: SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.darkText,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  child: _submitting
                      ? SizedBox(
                          width: 22.w,
                          height: 22.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.darkText,
                          ),
                        )
                      : Text(
                          tr.inviteProfessionalContinue.toUpperCase(),
                          style: AppTextStyles.button(
                            color: AppColors.darkText,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
