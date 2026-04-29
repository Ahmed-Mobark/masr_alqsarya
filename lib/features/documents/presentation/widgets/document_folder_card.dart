import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/features/documents/domain/entities/uploaded_file.dart';
import 'package:masr_al_qsariya/features/documents/presentation/model/document_models.dart';

class DocumentFolderCard extends StatelessWidget {
  final DocumentFolder folder;
  final VoidCallback onTap;
  final VoidCallback onMoreTap;

  const DocumentFolderCard({
    super.key,
    required this.folder,
    required this.onTap,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsetsDirectional.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColors.border, width: 1.w),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(16.r),
              ),
              alignment: Alignment.center,
              child: Icon(
                folder.type == DocumentsFolderType.calls
                    ? Iconsax.call
                    : folder.type == DocumentsFolderType.chats
                    ? Iconsax.message
                    : Iconsax.document,
                size: 24.sp,
                color: AppColors.yellow,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          folder.title,
                          style: AppTextStyles.bodyMedium().copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkText,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: onMoreTap,
                        borderRadius: BorderRadius.circular(10.r),
                        child: Padding(
                          padding: EdgeInsetsDirectional.all(4.w),
                          child: Icon(
                            Iconsax.more,
                            size: 18.sp,
                            color: AppColors.greyText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  // _MetaRow(icon: Iconsax.calendar_1, text: folder.createdAt),
                  // SizedBox(height: 6.h),
                  _MetaRow(icon: Iconsax.user, text: folder.addedBy),
                  // SizedBox(height: 6.h),
                  // _MetaRow(icon: Iconsax.security_safe, text: folder.access),
                  if (folder.lastUpdatedBy != null) ...[
                    SizedBox(height: 6.h),
                    _MetaRow(
                      icon: Iconsax.refresh,
                      text: folder.lastUpdatedBy!,
                    ),
                  ],
                  if (folder.lastUpdatedAt != null) ...[
                    SizedBox(height: 6.h),
                    _MetaRow(icon: Iconsax.clock, text: folder.lastUpdatedAt!),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: AppColors.captionText),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption(
              color: AppColors.captionText,
            ).copyWith(fontSize: 11.sp),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
