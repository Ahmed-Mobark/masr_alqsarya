import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';

class SessionsLibraryRecordingCard extends StatelessWidget {
  const SessionsLibraryRecordingCard({
    super.key,
    required this.tagLabel,
    required this.title,
    required this.durationLabel,
    required this.watchLabel,
    required this.onWatch,
    this.expertLine,
    this.participantsLine,
    this.archivedLine,
    this.thumbnailLocked = false,
    this.thumbnailImageUrl,
  });

  final String tagLabel;
  final String title;
  final String durationLabel;
  final String watchLabel;
  final VoidCallback onWatch;
  final String? expertLine;
  final String? participantsLine;
  final String? archivedLine;
  final bool thumbnailLocked;
  final String? thumbnailImageUrl;

  @override
  Widget build(BuildContext context) {
    final thumb = thumbnailImageUrl?.trim();
    final showNetworkThumb = !thumbnailLocked && thumb != null && thumb.isNotEmpty;
    final imageUrl = thumb ?? '';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (showNetworkThumb)
                    CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => ColoredBox(
                        color: AppColors.inputBg,
                        child: Center(
                          child: SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: const CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                      errorWidget: (_, __, ___) => ColoredBox(
                        color: AppColors.inputBg,
                        child: Icon(
                          Iconsax.video_play,
                          size: 48.sp,
                          color: AppColors.greyText,
                        ),
                      ),
                    )
                  else
                    ColoredBox(
                      color: thumbnailLocked
                          ? AppColors.sessionSlotsSurface
                          : AppColors.inputBg,
                      child: Center(
                        child: thumbnailLocked
                            ? Icon(
                                Iconsax.lock,
                                size: 40.sp,
                                color: AppColors.greyText,
                              )
                            : Icon(
                                Iconsax.video_play,
                                size: 48.sp,
                                color: AppColors.greyText,
                              ),
                      ),
                    ),
                  PositionedDirectional(
                    start: 10.w,
                    top: 10.h,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        tagLabel,
                        style: AppTextStyles.caption(
                          color: AppColors.yellow,
                        ).copyWith(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    end: 10.w,
                    bottom: 10.h,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        durationLabel,
                        style: AppTextStyles.caption(
                          color: AppColors.white,
                        ).copyWith(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(14.w, 12.h, 14.w, 4.h),
            child: Text(
              title,
              style: AppTextStyles.heading2(
                color: AppColors.darkText,
              ).copyWith(fontSize: 15.sp, fontWeight: FontWeight.w700),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (expertLine != null) ...[
            Padding(
              padding: EdgeInsetsDirectional.only(start: 14.w, top: 6.h),
              child: _MetaRow(icon: Iconsax.user, text: expertLine!),
            ),
          ],
          if (participantsLine != null) ...[
            Padding(
              padding: EdgeInsetsDirectional.only(start: 14.w, top: 6.h),
              child: _MetaRow(icon: Iconsax.people, text: participantsLine!),
            ),
          ],
          if (archivedLine != null) ...[
            Padding(
              padding: EdgeInsetsDirectional.only(start: 14.w, top: 6.h),
              child: _MetaRow(icon: Iconsax.calendar, text: archivedLine!),
            ),
          ],
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(14.w, 14.h, 14.w, 14.h),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onWatch,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.darkText,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: Text(
                  watchLabel,
                  style: AppTextStyles.button(
                    color: AppColors.darkText,
                  ).copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16.sp, color: AppColors.greyText),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption(
              color: AppColors.greyText,
            ).copyWith(fontSize: 12.sp),
          ),
        ),
      ],
    );
  }
}
