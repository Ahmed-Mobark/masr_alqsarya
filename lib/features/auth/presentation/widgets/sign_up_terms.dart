import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';

class SignUpTerms extends StatelessWidget {
  const SignUpTerms({
    super.key,
    required this.value,
    required this.onChanged,
    required this.showError,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final bool showError;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 20.w,
              height: 20.w,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                checkColor: AppColors.darkText,
                fillColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.primary;
                  }
                  return AppColors.white;
                }),
                side: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.9),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.caption(
                      color: AppColors.captionText,
                    ).copyWith(fontSize: 12.sp, height: 1.4),
                    children: [
                      TextSpan(text: context.tr.authAgreeTermsPrefix),
                      TextSpan(
                        text: context.tr.authTermsAndConditions,
                        style: AppTextStyles.caption(color: AppColors.darkText)
                            .copyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      TextSpan(text: context.tr.authAgreeTermsSuffix),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (showError) ...[
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 28.w),
            child: Text(
              context.tr.authAgreeTermsToContinue,
              style: AppTextStyles.caption(
                color: AppColors.error,
              ).copyWith(fontSize: 11.sp),
            ),
          ),
        ],
      ],
    );
  }
}
