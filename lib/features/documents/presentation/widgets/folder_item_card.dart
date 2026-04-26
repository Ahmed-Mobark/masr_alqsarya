import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/features/documents/presentation/model/document_models.dart';

class FolderItemCard extends StatelessWidget {
  final FolderItem item;
  const FolderItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.border, width: 1.w),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.r),
              child: _Preview(type: item.type),
            ),
          ),
          PositionedDirectional(
            top: 10.h,
            start: 10.w,
            child: _SmallCircleButton(
              icon: Iconsax.info_circle,
              onTap: () {},
            ),
          ),
          PositionedDirectional(
            top: 10.h,
            end: 10.w,
            child: _SmallCircleButton(
              icon: Iconsax.shield_tick,
              onTap: () {},
            ),
          ),
          if (item.type == FolderItemType.video)
            PositionedDirectional(
              top: 44.h,
              start: 16.w,
              child: _PlayButton(),
            ),
          PositionedDirectional(
            start: 14.w,
            end: 14.w,
            bottom: 12.h,
            child: Row(
              children: [
                if (item.type == FolderItemType.document)
                  Icon(Iconsax.document, size: 16.sp, color: AppColors.error),
                if (item.type == FolderItemType.document) SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    item.title,
                    style: AppTextStyles.bodyMedium(color: AppColors.darkText).copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: item.type == FolderItemType.document
                        ? TextAlign.start
                        : TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  final FolderItemType type;
  const _Preview({required this.type});

  @override
  Widget build(BuildContext context) {
    // No assets yet; mimic screenshots with neutral preview tiles.
    if (type == FolderItemType.document) {
      return Container(
        color: AppColors.white,
        child: Center(
          child: Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: AppColors.inputBg,
              borderRadius: BorderRadius.circular(14.r),
            ),
            alignment: Alignment.center,
            child: Icon(Iconsax.document, size: 34.sp, color: AppColors.error),
          ),
        ),
      );
    }

    return Container(
      color: AppColors.inputBg,
      child: Center(
        child: Icon(
          type == FolderItemType.photo ? Iconsax.gallery : Iconsax.video_play,
          size: 34.sp,
          color: AppColors.captionText,
        ),
      ),
    );
  }
}

class _SmallCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SmallCircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999.r),
      child: Container(
        width: 28.w,
        height: 28.w,
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 16.sp, color: AppColors.greyText),
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34.w,
      height: 34.w,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12.r),
      ),
      alignment: Alignment.center,
      child: Icon(Iconsax.play, size: 16.sp, color: AppColors.greyText),
    );
  }
}

