import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';

class PhonePrefix extends StatelessWidget {
  const PhonePrefix({
    super.key,
    required this.selectedDialCode,
    required this.onChanged,
  });

  final String selectedDialCode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 2.w, end: 10.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Theme(
            data: Theme.of(context).copyWith(canvasColor: AppColors.white),
            child: CountryCodePicker(
              onChanged: (countryCode) {
                onChanged(countryCode.dialCode ?? '+20');
              },
              initialSelection: selectedDialCode,
              favorite: const ['EG', '+20'],
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
              showDropDownButton: false,
              alignLeft: false,
              padding: EdgeInsets.zero,
              textStyle: AppTextStyles.bodyMedium(
                color: AppColors.darkText,
              ).copyWith(fontSize: 14.sp),
              dialogTextStyle: AppTextStyles.body(
                color: AppColors.darkText,
              ).copyWith(fontSize: 14.sp),
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
            size: 18.sp,
          ),
          Container(
            width: 1.w,
            height: 20.h,
            margin: EdgeInsetsDirectional.only(start: 8.w, end: 10.w),
            color: AppColors.border,
          ),
        ],
      ),
    );
  }
}
