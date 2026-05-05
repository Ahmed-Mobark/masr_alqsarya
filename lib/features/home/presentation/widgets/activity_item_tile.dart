import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/features/home/domain/entities/recent_activity.dart';

class ActivityItemTile extends StatelessWidget {
  const ActivityItemTile({
    super.key,
    required this.item,
    this.onTap,
  });

  final RecentActivity item;
  final VoidCallback? onTap;

  IconData _iconForKind(String kind) {
    switch (kind) {
      case 'live_session':
        return Icons.videocam_outlined;
      case 'session_library_item':
        return Icons.play_circle_outline_rounded;
      case 'news_feed':
        return Icons.article_outlined;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  String _subtitle() {
    final details = item.description.trim().isNotEmpty
        ? item.description.trim()
        : (item.personaName?.trim().isNotEmpty ?? false)
            ? item.personaName!.trim()
            : '';
    if (details.isEmpty) return item.occurredAt;
    return '${item.occurredAt} - $details';
  }

  @override
  Widget build(BuildContext context) {
    final actionLabel = item.actionLabel;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon in light yellow container
              Container(
                width: 46.w,
                height: 46.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  _iconForKind(item.kind),
                  size: 22.sp,
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
                      item.title,
                      style: AppTextStyles.bodyMedium(
                        color: AppColors.darkText,
                      ).copyWith(
                          fontSize: 15.sp, fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      _subtitle(),
                      style: AppTextStyles.caption(
                        color: AppColors.greyText,
                      ).copyWith(fontSize: 12.sp, height: 1.3),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Action badge (optional)
              if (actionLabel != null) ...[
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    actionLabel,
                    style: AppTextStyles.smallMedium(
                      color: AppColors.darkText,
                    ).copyWith(
                        fontSize: 12.sp, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
