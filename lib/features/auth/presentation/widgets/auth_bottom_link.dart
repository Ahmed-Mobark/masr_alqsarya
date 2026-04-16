import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';

class AuthBottomLink extends StatelessWidget {
  const AuthBottomLink({
    super.key,
    required this.prefixText,
    required this.linkText,
    required this.onTap,
  });

  final String prefixText;
  final String linkText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          prefixText,
          style: AppTextStyles.caption(
            color: AppColors.captionText,
          ).copyWith(fontSize: 12.sp),
          textAlign: TextAlign.center,
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            linkText,
            style: AppTextStyles.caption(
              color: AppColors.primary,
            ).copyWith(fontSize: 12.sp, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
