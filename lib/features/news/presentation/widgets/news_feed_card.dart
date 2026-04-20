import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/widgets/app_cached_network_image.dart';
import 'package:masr_al_qsariya/features/news/domain/entities/news_feed.dart';

class NewsFeedCard extends StatelessWidget {
  const NewsFeedCard({
    super.key,
    required this.item,
    required this.isLikeLoading,
    required this.isHelpfulLoading,
    required this.onLike,
    required this.onHelpful,
  });

  final NewsFeedItem item;
  final bool isLikeLoading;
  final bool isHelpfulLoading;
  final VoidCallback onLike;
  final VoidCallback onHelpful;

  List<String> get _imageUrls {
    final urls = <String>[];
    for (final a in item.attachments) {
      if (a.attachmentType == 'image' && (a.url?.isNotEmpty ?? false)) {
        urls.add(a.url!);
      }
    }
    return urls;
  }

  bool get _isEdited {
    final created = item.createdAt;
    final updated = item.updatedAt;
    if (created == null || updated == null) return false;
    return created != updated;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrls = _imageUrls;
    final headerTitle =
        (item.category?.name.trim().isNotEmpty ?? false)
            ? item.category!.name
            : (item.persona?.name ?? item.title);

    final metaText = [
      if (item.publishDate.trim().isNotEmpty) item.publishDate.trim(),
      if (_isEdited) 'Edited',
    ].join('  •  ');

    final topicLabel =
        item.type.trim().isNotEmpty ? item.type.trim() : null;
    final totalReactions = item.likesCount + item.helpfulCount;
    final isLiked = item.myReaction == NewsReaction.like;
    final isHelpful = item.myReaction == NewsReaction.helpful;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
      ),
      padding: EdgeInsetsDirectional.fromSTEB(16.w, 16.h, 16.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF7DA7F7),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person_outline,
                    color: AppColors.white, size: 22.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            headerTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.heading2(
                              color: AppColors.darkText,
                            ).copyWith(fontSize: 16.sp),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Text(
                            metaText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption(
                              color: AppColors.lightGreyText,
                            ).copyWith(fontSize: 11.sp, height: 1.2),
                          ),
                        ),
                      ],
                    ),
                    if (topicLabel != null) ...[
                      SizedBox(height: 6.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Text(
                          topicLabel,
                          style: AppTextStyles.smallMedium(
                            color: AppColors.yellow,
                          ).copyWith(fontSize: 11.sp),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Icon(
                Icons.push_pin_outlined,
                color: AppColors.primary.withValues(alpha: 0.95),
                size: 20.sp,
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Body text
          Text(
            item.content,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body(color: AppColors.darkText).copyWith(
              height: 1.35,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            '...see more',
            style: AppTextStyles.caption(color: AppColors.lightGreyText)
                .copyWith(fontSize: 12.sp),
          ),

          SizedBox(height: 14.h),

          // Media
          ClipRRect(
            borderRadius: BorderRadius.circular(18.r),
            child: SizedBox(
              height: 150.h,
              width: double.infinity,
              child: imageUrls.isNotEmpty
                  ? _AttachmentsSlider(imageUrls: imageUrls)
                  : Container(
                      color: AppColors.inputBg,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.image_outlined,
                        color: AppColors.greyText.withValues(alpha: 0.55),
                        size: 30.sp,
                      ),
                    ),
            ),
          ),

          SizedBox(height: 12.h),

          // Reactions count
          Row(
            children: [
              _ReactionBadge(),
              SizedBox(width: 6.w),
              Text(
                '$totalReactions',
                style: AppTextStyles.caption(color: AppColors.greyText)
                    .copyWith(fontSize: 12.sp),
              ),
            ],
          ),

          SizedBox(height: 10.h),
          Divider(height: 1, color: AppColors.border.withValues(alpha: 0.7)),
          SizedBox(height: 6.h),

          // Actions
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.thumb_up_outlined,
                  label: 'Like',
                  isSelected: isLiked,
                  isLoading: isLikeLoading,
                  onTap: onLike,
                ),
              ),
              Expanded(
                child: _ActionButton(
                  icon: Icons.handshake_outlined,
                  label: 'Helpful',
                  isSelected: isHelpful,
                  isLoading: isHelpfulLoading,
                  onTap: onHelpful,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReactionBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22.w,
      height: 22.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          PositionedDirectional(
            start: 0,
            top: 2.h,
            child: Container(
              width: 18.w,
              height: 18.w,
              decoration: const BoxDecoration(
                color: Color(0xFF2F80ED),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.thumb_up, color: Colors.white, size: 10.sp),
            ),
          ),
          PositionedDirectional(
            start: 9.w,
            top: 2.h,
            child: Container(
              width: 18.w,
              height: 18.w,
              decoration: const BoxDecoration(
                color: Color(0xFFEB5757),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.favorite, color: Colors.white, size: 10.sp),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isSelected,
    required this.isLoading,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primaryDark : AppColors.greyText;
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: SizedBox(
        height: 40.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 16.w,
                height: 16.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: color,
                ),
              )
            else
              Icon(icon, size: 18.sp, color: color),
            SizedBox(width: 8.w),
            Text(
              label,
              style: AppTextStyles.bodyMedium(color: color)
                  .copyWith(fontSize: 13.sp),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttachmentsSlider extends StatefulWidget {
  const _AttachmentsSlider({required this.imageUrls});
  final List<String> imageUrls;

  @override
  State<_AttachmentsSlider> createState() => _AttachmentsSliderState();
}

class _AttachmentsSliderState extends State<_AttachmentsSlider> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final count = widget.imageUrls.length;
    return Stack(
      children: [
        PageView.builder(
          itemCount: count,
          onPageChanged: (i) => setState(() => _index = i),
          itemBuilder: (_, i) => AppCachedNetworkImage(
            imageUrl: widget.imageUrls[i],
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        if (count > 1)
          PositionedDirectional(
            bottom: 10.h,
            start: 0,
            end: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(count, (i) {
                final active = i == _index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  width: active ? 18.w : 6.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.primary
                        : Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}

