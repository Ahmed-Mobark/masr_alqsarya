import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/theme/calendar_theme.dart';
import 'package:masr_al_qsariya/core/widgets/app_text_form_field.dart';

class AuthPhoneNumberField extends StatelessWidget {
  const AuthPhoneNumberField({
    super.key,
    required this.controller,
    required this.hint,
    required this.selectedDialCode,
    required this.onDialCodeChanged,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final String selectedDialCode;
  final ValueChanged<String> onDialCodeChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: controller,
      hintText: hint,
      keyboardType: TextInputType.phone,
      validator: validator,
      cardColor: AppColors.white,
      hintStyle: AppTextStyles.body(
        color: AppColors.captionText,
      ).copyWith(fontSize: 14.sp),
      borderColor: AppColors.border.withValues(alpha: 0.75),
      focusedBorderColor: AppColors.primary.withValues(alpha: 0.95),
      errorBorderColor: AppColors.error.withValues(alpha: 0.9),
      borderRadius: 18,
      // Prefix lives in prefixIcon slot; remove left padding.
      contentPadding: EdgeInsetsDirectional.fromSTEB(0, 16.h, 16.w, 16.h),
      prefixWidget: _CountryPrefix(
        selectedDialCode: selectedDialCode,
        onDialCodeChanged: onDialCodeChanged,
      ),
    );
  }
}

class _CountryPrefix extends StatelessWidget {
  const _CountryPrefix({
    required this.selectedDialCode,
    required this.onDialCodeChanged,
  });

  final String selectedDialCode;
  final ValueChanged<String> onDialCodeChanged;

  @override
  Widget build(BuildContext context) {
    // The prefixIcon slot gets its own constraints; keep it deterministic.
    return SizedBox(
      width: 132.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              brightness: Brightness.light,
              canvasColor: AppColors.white,
              dialogTheme: CalendarTheme.getCalendarTheme(context).dialogTheme,
            ),
            child: CountryCodePicker(
              onChanged: (countryCode) {
                onDialCodeChanged(countryCode.dialCode ?? '+20');
              },
              initialSelection: selectedDialCode,
              favorite: const ['EG', '+20'],
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
              showDropDownButton: false,
              alignLeft: false,
              padding: EdgeInsets.zero,
              dialogSize: Size(340.w, 520.h),
              textStyle: AppTextStyles.bodyMedium(
                color: AppColors.darkText,
              ).copyWith(fontSize: 14.sp),
              dialogTextStyle: AppTextStyles.body(
                color: AppColors.darkText,
              ).copyWith(fontSize: 14.sp),
              searchDecoration: InputDecoration(
                hintText: 'Search',
                hintStyle: AppTextStyles.body(
                  color: AppColors.captionText,
                ).copyWith(fontSize: 13.sp),
                filled: true,
                fillColor: AppColors.white,
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: AppColors.greyText,
                  size: 18.sp,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 12.h,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide(
                    color: AppColors.border.withValues(alpha: 0.85),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.95),
                  ),
                ),
              ),
              flagWidth: 18.w,
              boxDecoration: const BoxDecoration(),
              barrierColor: AppColors.black.withValues(alpha: 0.25),
              closeIcon: Icon(
                Icons.close_rounded,
                color: AppColors.darkText,
                size: 18.sp,
              ),
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.greyText,
            size: 16.sp,
          ),
          Container(
            width: 1.w,
            height: 20.h,
            margin: EdgeInsetsDirectional.only(start: 4.w),
            color: AppColors.border,
          ),
        ],
      ),
    );
  }
}
