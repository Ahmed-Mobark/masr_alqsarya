import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';

class AwaitingCard extends StatelessWidget {
  const AwaitingCard({
    super.key,
    required this.subtitle,
    this.onConfirm,
    this.onRequestReschedule,
    this.confirmLoading = false,
    this.requestLoading = false,
  });

  final String subtitle;
  final VoidCallback? onConfirm;
  final VoidCallback? onRequestReschedule;
  final bool confirmLoading;
  final bool requestLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F4EC),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.55),
          width: 1.1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top row: icon + info + badge
          Row(
            children: [
              // Phone icon box
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(color: AppColors.border, width: 1.0),
                ),
                child: Icon(
                  Icons.phone_outlined,
                  size: 28.sp,
                  color: const Color(0xFFC9A776),
                ),
              ),
              SizedBox(width: 8.w),
              // Title + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr.homeUpcomingCall,
                      style: AppTextStyles.bodyMedium(
                        color: AppColors.darkText,
                      ).copyWith(fontSize: 14.sp, fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption(
                        color: AppColors.greyText,
                      ).copyWith(fontSize: 9.sp, fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              // Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFECDDCA),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  context.tr.homeReminder,
                  style: AppTextStyles.small(
                    color: const Color(0xFFC29A6B),
                  ).copyWith(fontSize: 10.sp, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              SizedBox(
                width: 155.w,
                height: 36.h,
                child: ElevatedButton(
                  onPressed: confirmLoading ? null : onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.darkText,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  ),
                  child: confirmLoading
                      ? SizedBox(
                          width: 16.r,
                          height: 16.r,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.darkText,
                          ),
                        )
                      : Text(
                          context.tr.homeConfirm,
                          style:
                              AppTextStyles.smallMedium(
                                color: AppColors.darkText,
                              ).copyWith(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: SizedBox(
                  height: 36.h,
                  child: OutlinedButton(
                    onPressed: requestLoading ? null : onRequestReschedule,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primary, width: 1.3.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                    ),
                    child: requestLoading
                        ? SizedBox(
                            width: 16.r,
                            height: 16.r,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.darkText,
                            ),
                          )
                        : Text(
                            context.tr.homeRequestReschedule,
                            textAlign: TextAlign.center,
                            style:
                                AppTextStyles.smallMedium(
                                  color: AppColors.darkText,
                                ).copyWith(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
