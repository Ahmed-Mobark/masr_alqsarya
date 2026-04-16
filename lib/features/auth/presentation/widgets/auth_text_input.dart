import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/widgets/app_text_form_field.dart';

class AuthTextInput extends StatelessWidget {
  const AuthTextInput({
    super.key,
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.suffixWidget,
    this.prefix,
    this.contentPadding,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Widget? suffixWidget;
  final Widget? prefix;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: controller,
      hintText: hint,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      suffixWidget: suffixWidget,
      prefix: prefix,
      cardColor: AppColors.white,
      hintStyle: AppTextStyles.body(
        color: AppColors.captionText,
      ).copyWith(fontSize: 14.sp),
      borderColor: AppColors.border.withValues(alpha: 0.75),
      focusedBorderColor: AppColors.primary.withValues(alpha: 0.95),
      errorBorderColor: AppColors.error.withValues(alpha: 0.9),
      borderRadius: 18,
      contentPadding:
          contentPadding ??
          EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
    );
  }
}
