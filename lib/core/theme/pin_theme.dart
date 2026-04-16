import 'package:masr_al_qsariya/core/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class FormFieldTheme {
  static PinTheme pinTheme(BuildContext context) => PinTheme(
    shape: PinCodeFieldShape.box,
    borderRadius: BorderRadius.circular(10.r),
    fieldOuterPadding: EdgeInsets.symmetric(horizontal: 5.w),
    fieldHeight: 50.h,
    fieldWidth: 50.w,
    borderWidth: 1,
    activeColor: Theme.of(context).primaryColor,
    selectedColor: Theme.of(context).dividerColor,
    inactiveColor: Theme.of(context).dividerColor,
    activeFillColor: AppColors.transparent,
    selectedFillColor: Theme.of(context).scaffoldBackgroundColor,
    inactiveFillColor: Theme.of(context).scaffoldBackgroundColor,
  );
}