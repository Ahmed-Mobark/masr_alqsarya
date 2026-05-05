import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';

class SessionOfferSlotData {
  const SessionOfferSlotData({
    required this.dayLabel,
    required this.timeLabel,
  });

  final String dayLabel;
  final String timeLabel;
}

class SessionOfferCard extends StatelessWidget {
  const SessionOfferCard({
    super.key,
    required this.sessionTypeLabel,
    required this.expertName,
    required this.expertRole,
    required this.ratingLabel,
    required this.primaryLabel,
    required this.onPrimaryPressed,
    this.networkImageUrl,
    this.slots = const [],
    this.nextAvailableTitle,
    this.selectedSlotIndex = 0,
    this.onSlotSelected,
    this.scheduleDateLabel,
    this.scheduleTimeLabel,
    this.scheduleDurationLabel,
    this.showPrimaryButton = true,
  });

  final String sessionTypeLabel;
  final String expertName;
  final String expertRole;
  final String ratingLabel;
  final String primaryLabel;
  final VoidCallback onPrimaryPressed;
  final String? networkImageUrl;
  final List<SessionOfferSlotData> slots;
  final String? nextAvailableTitle;
  final int selectedSlotIndex;
  final ValueChanged<int>? onSlotSelected;
  final String? scheduleDateLabel;
  final String? scheduleTimeLabel;
  final String? scheduleDurationLabel;
  final bool showPrimaryButton;

  static const String _dash = '\u2014';

  bool get _useSlotPicker => slots.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final dateLine = scheduleDateLabel?.trim().isNotEmpty == true
        ? scheduleDateLabel!.trim()
        : _dash;
    final timeLine = scheduleTimeLabel?.trim().isNotEmpty == true
        ? scheduleTimeLabel!.trim()
        : _dash;
    final durationLine = scheduleDurationLabel?.trim().isNotEmpty == true
        ? scheduleDurationLabel!.trim()
        : _dash;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 16.h, 16.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Avatar(networkImageUrl: networkImageUrl),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            expertName,
                            style: AppTextStyles.heading2(
                              color: AppColors.darkText,
                            ).copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (expertRole.trim().isNotEmpty) ...[
                            SizedBox(height: 4.h),
                            Text(
                              expertRole,
                              style: AppTextStyles.caption(
                                color: AppColors.greyText,
                              ).copyWith(fontSize: 12.sp),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          if (ratingLabel.trim().isNotEmpty) ...[
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Icon(
                                  Iconsax.star1,
                                  size: 16.sp,
                                  color: AppColors.yellow,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  ratingLabel,
                                  style: AppTextStyles.smallMedium(
                                    color: AppColors.darkText,
                                  ).copyWith(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(width: 56.w),
                  ],
                ),
                SizedBox(height: 16.h),
                if (_useSlotPicker)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsetsDirectional.fromSTEB(
                      12.w,
                      12.h,
                      12.w,
                      14.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.sessionSlotsSurface,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if ((nextAvailableTitle ?? '').trim().isNotEmpty) ...[
                          Text(
                            nextAvailableTitle!.trim(),
                            style: AppTextStyles.smallMedium(
                              color: AppColors.darkText,
                            ).copyWith(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 10.h),
                        ],
                        Row(
                          children: [
                            for (var i = 0; i < slots.length; i++) ...[
                              if (i > 0) SizedBox(width: 8.w),
                              Expanded(
                                child: _TimeSlotChip(
                                  slot: slots[i],
                                  selected: i == selectedSlotIndex,
                                  onTap: () => onSlotSelected?.call(i),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: EdgeInsetsDirectional.fromSTEB(
                      12.w,
                      12.h,
                      12.w,
                      14.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.sessionSlotsSurface,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.tr.sessionLobbyStartDateLabel,
                                style: AppTextStyles.caption(
                                  color: AppColors.greyText,
                                ).copyWith(fontSize: 11.sp, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                dateLine,
                                style: AppTextStyles.smallMedium(
                                  color: AppColors.darkText,
                                ).copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40.h,
                          child: VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: AppColors.border,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.tr.sessionLobbyStartTimeLabel,
                                style: AppTextStyles.caption(
                                  color: AppColors.greyText,
                                ).copyWith(fontSize: 11.sp, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                timeLine,
                                style: AppTextStyles.smallMedium(
                                  color: AppColors.darkText,
                                ).copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40.h,
                          child: VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: AppColors.border,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.tr.sessionLobbyDurationLabel,
                                style: AppTextStyles.caption(
                                  color: AppColors.greyText,
                                ).copyWith(fontSize: 11.sp, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                durationLine,
                                style: AppTextStyles.smallMedium(
                                  color: AppColors.darkText,
                                ).copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                if (showPrimaryButton) ...[
                  SizedBox(height: 14.h),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: onPrimaryPressed,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.darkText,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                      child: Text(
                        primaryLabel,
                        style: AppTextStyles.button(
                          color: AppColors.darkText,
                        ).copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          PositionedDirectional(
            top: 12.h,
            end: 12.w,
            child: Text(
              sessionTypeLabel,
              style: AppTextStyles.smallMedium(
                color: AppColors.yellow,
              ).copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.networkImageUrl});

  final String? networkImageUrl;

  @override
  Widget build(BuildContext context) {
    final url = networkImageUrl?.trim();
    if (url != null && url.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: SizedBox(
          width: 56.w,
          height: 56.w,
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
            placeholder: (_, __) => ColoredBox(
              color: AppColors.inputBg,
              child: Center(
                child: SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            errorWidget: (_, __, ___) => ColoredBox(
              color: AppColors.inputBg,
              child: Icon(
                Iconsax.user,
                size: 28.sp,
                color: AppColors.greyText,
              ),
            ),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: ColoredBox(
        color: AppColors.inputBg,
        child: SizedBox(
          width: 56.w,
          height: 56.w,
          child: Icon(
            Iconsax.user,
            size: 28.sp,
            color: AppColors.greyText,
          ),
        ),
      ),
    );
  }
}

class _TimeSlotChip extends StatelessWidget {
  const _TimeSlotChip({
    required this.slot,
    required this.selected,
    required this.onTap,
  });

  final SessionOfferSlotData slot;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 6.w),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.white
                : AppColors.sessionSlotInactiveBg,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: selected ? AppColors.yellow : AppColors.transparent,
              width: selected ? 1.5 : 0,
            ),
          ),
          child: Column(
            children: [
              Text(
                slot.dayLabel,
                style: AppTextStyles.caption(
                  color: selected ? AppColors.yellow : AppColors.greyText,
                ).copyWith(fontSize: 11.sp, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              Text(
                slot.timeLabel,
                style: AppTextStyles.smallMedium(
                  color: AppColors.darkText,
                ).copyWith(fontSize: 12.sp, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
