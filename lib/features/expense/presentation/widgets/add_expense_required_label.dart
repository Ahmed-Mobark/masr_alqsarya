import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';

class AddExpenseRequiredLabel extends StatelessWidget {
  final String text;

  const AddExpenseRequiredLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: AppTextStyles.bodyMedium().copyWith(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.darkText,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          '*',
          style: AppTextStyles.bodyMedium(color: AppColors.yellow).copyWith(
            fontSize: 13.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

