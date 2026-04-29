import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/features/documents/presentation/model/document_models.dart';

class FolderItemCard extends StatelessWidget {
  final FolderItem item;
  final VoidCallback? onTap;
  final VoidCallback? onInfoTap;
  final VoidCallback? onPermissionTap;

  const FolderItemCard({
    super.key,
    required this.item,
    this.onTap,
    this.onInfoTap,
    this.onPermissionTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18.r),
      onTap: onTap,
      child: Container(
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
                child: _Preview(item: item),
              ),
            ),
            PositionedDirectional(
              top: 10.h,
              start: 42.w,
              child: _SmallCircleButton(
                icon: Iconsax.info_circle,
                onTap: onInfoTap ?? () {},
              ),
            ),
            PositionedDirectional(
              top: 10.h,
              start: 10.w,
              child: _SmallCircleButton(
                icon: Iconsax.shield,
                onTap: onPermissionTap ?? () {},
              ),
            ),
            if (item.type == FolderItemType.video)
              PositionedDirectional(
                top: 44.h,
                start: 16.w,
                child: _PlayButton(),
              ),
            PositionedDirectional(
              start: 0,
              end: 0,
              bottom: 0,
              child: Container(
                height: 56.h,
                padding: EdgeInsetsDirectional.only(
                  start: 14.w,
                  end: 14.w,
                  top: 10.h,
                  bottom: 10.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(18.r),
                  ),
                ),
                child: Row(
                  children: [
                    if (item.type == FolderItemType.document)
                      Icon(
                        Iconsax.document,
                        size: 16.sp,
                        color: AppColors.error,
                      )
                    else if (item.type == FolderItemType.photo)
                      Icon(
                        Iconsax.gallery,
                        size: 16.sp,
                        color: AppColors.captionText,
                      )
                    else if (item.type == FolderItemType.video)
                      Icon(
                        Iconsax.video_play,
                        size: 16.sp,
                        color: AppColors.captionText,
                      ),

                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        item.title,
                        style:
                            AppTextStyles.bodyMedium(
                              color: AppColors.darkText,
                            ).copyWith(
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
            ),
          ],
        ),
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  final FolderItem item;
  const _Preview({required this.item});

  @override
  Widget build(BuildContext context) {
    final (IconData icon, Color color) = switch (item.type) {
      FolderItemType.photo => (Iconsax.gallery, AppColors.captionText),
      FolderItemType.video => (Iconsax.video_play, AppColors.captionText),
      FolderItemType.document => (Iconsax.document, AppColors.error),
    };

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
          child: Icon(icon, size: 34.sp, color: color),
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
