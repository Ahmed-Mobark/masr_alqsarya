import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/config/app_icons.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';

class AuthSocialButton extends StatelessWidget {
  const AuthSocialButton({
    super.key,
    required this.label,
    required this.iconPath,
    required this.onTap,
    this.height,
  });

  final String label;
  final String iconPath;
  final VoidCallback onTap;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height ?? 52.h,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.white,
          side: BorderSide(color: AppColors.border.withValues(alpha: 0.85)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcons.icon(icon: iconPath, size: 20.sp),
            SizedBox(width: 12.w),
            Text(
              label,
              style: AppTextStyles.bodyMedium(
                color: AppColors.darkText,
              ).copyWith(fontSize: 15.sp),
            ),
          ],
        ),
      ),
    );
  }
}
