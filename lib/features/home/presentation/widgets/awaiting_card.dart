import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/data/dummy_data.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/features/home/presentation/widgets/reschedule_bottom_sheet.dart';

class AwaitingCard extends StatelessWidget {
  const AwaitingCard({
    super.key,
    required this.item,
    this.onTap,
  });

  final AwaitingItem item;
  final VoidCallback? onTap;

  String _title(BuildContext context) {
    return switch (item.titleKey) {
      'upcomingCall' => context.tr.homeUpcomingCall,
      _ => item.titleKey,
    };
  }

  String _badge(BuildContext context) {
    return switch (item.badgeKey) {
      'reminder' => context.tr.homeReminder,
      _ => item.badgeKey,
    };
  }

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
                  item.icon,
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
                      _title(context),
                      style: AppTextStyles.bodyMedium(
                        color: AppColors.darkText,
                      ).copyWith(
                          fontSize: 15.sp, fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      item.subtitle,
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
                  _badge(context),
                  style: AppTextStyles.small(
                    color: AppColors.yellow,
                  ).copyWith(
                      fontSize: 11.sp, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          // Bottom: action buttons
          Row(
            children: [
              // Confirm button (filled yellow)
              Expanded(
                child: SizedBox(
                  height: 40.h,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.darkText,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                    ),
                    child: Text(
                      context.tr.homeConfirm,
                      style: AppTextStyles.smallMedium(
                        color: AppColors.darkText,
                      ).copyWith(
                          fontSize: 12.sp, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              // Request Reschedule button (outlined)
              Expanded(
                child: SizedBox(
                  height: 40.h,
                  child: OutlinedButton(
                    onPressed: () => RescheduleBottomSheet.show(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.darkText,
                      side: BorderSide(
                          color: AppColors.darkText, width: 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                    ),
                    child: FittedBox(
                      child: Text(
                        context.tr.homeRequestReschedule,
                        style: AppTextStyles.smallMedium(
                          color: AppColors.darkText,
                        ).copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700),
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
