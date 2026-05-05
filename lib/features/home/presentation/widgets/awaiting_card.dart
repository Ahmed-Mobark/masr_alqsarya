import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';

class AwaitingCard extends StatelessWidget {
  const AwaitingCard({
    super.key,
    required this.subtitle,
    this.onJoin,
    this.joinLoading = false,
  });

  final String subtitle;
  final VoidCallback? onJoin;
  final bool joinLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340.w,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.5),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top row: icon + info + badge
          Row(
            children: [
              // Phone icon in yellow-bordered circle
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.phone_outlined,
                  size: 20.sp,
                  color: AppColors.yellow,
                ),
              ),
              SizedBox(width: 12.w),
              // Title + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr.homeUpcomingCall,
                      style: AppTextStyles.bodyMedium(
                        color: AppColors.darkText,
                      ).copyWith(
                          fontSize: 15.sp, fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption(
                        color: AppColors.greyText,
                      ).copyWith(fontSize: 12.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              // Badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 5.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  context.tr.homeReminder,
                  style: AppTextStyles.small(
                    color: AppColors.yellow,
                  ).copyWith(
                      fontSize: 11.sp, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          SizedBox(
            width: double.infinity,
            height: 40.h,
            child: ElevatedButton(
              onPressed: joinLoading ? null : onJoin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.darkText,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
              child: joinLoading
                  ? SizedBox(
                      width: 16.r,
                      height: 16.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.darkText,
                      ),
                    )
                  : Text(
                      context.tr.scheduleJoin,
                      style: AppTextStyles.smallMedium(
                        color: AppColors.darkText,
                      ).copyWith(fontSize: 12.sp, fontWeight: FontWeight.w700),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
