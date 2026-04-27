import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/widgets/app_cached_network_image.dart';
import 'package:masr_al_qsariya/features/news/domain/entities/news_feed.dart';

class NewsFeedCard extends StatefulWidget {
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

  @override
  State<NewsFeedCard> createState() => _NewsFeedCardState();
}

class _NewsFeedCardState extends State<NewsFeedCard> {
  bool _isExpanded = false;

  NewsFeedItem get item => widget.item;

  List<String> get _imageUrls {
    final urls = <String>[];
    for (final a in item.attachments) {
      if (a.attachmentType == 'image' && (a.url?.isNotEmpty ?? false)) {
        urls.add(a.url!);
      }
    }
    return urls;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrls = _imageUrls;
    final headerTitle =
        (item.persona?.name.trim().isNotEmpty ?? false)
            ? item.persona!.name
            : (item.postedByUser?.fullName ?? item.title);

    final metaText = item.publishDate.trim();

    final topicLabel =
        item.type.trim().isNotEmpty ? item.type.trim() : null;
    final totalReactions = item.likesCount + item.helpfulCount;
    final isLiked = item.myReaction == NewsReaction.like;
    final isHelpful = item.myReaction == NewsReaction.helpful;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 46.w,
                height: 46.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EDE6),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Icon(Iconsax.user,
                    color: AppColors.greyText, size: 22.sp),
              ),
              SizedBox(width: 12.w),
              // Title + meta + topic
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
                            ).copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          metaText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption(
                            color: AppColors.lightGreyText,
                          ).copyWith(fontSize: 12.sp),
                        ),
                      ],
                    ),
                    if (topicLabel != null) ...[
                      SizedBox(height: 4.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.18),
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
            ],
          ),

          SizedBox(height: 14.h),

          // ── Body text with inline see more ──
          LayoutBuilder(
            builder: (context, constraints) {
              final textStyle =
                  AppTextStyles.body(color: AppColors.darkText).copyWith(
                height: 1.5,
                fontSize: 14.sp,
              );
              final seeMoreStyle =
                  AppTextStyles.body(color: AppColors.lightGreyText).copyWith(
                height: 1.5,
                fontSize: 14.sp,
              );

              if (_isExpanded) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.content, style: textStyle),
                    SizedBox(height: 2.h),
                    GestureDetector(
                      onTap: () => setState(() => _isExpanded = false),
                      child: Text(context.tr.newsShowLess, style: seeMoreStyle),
                    ),
                  ],
                );
              }

              final textSpan = TextSpan(text: item.content, style: textStyle);
              final tp = TextPainter(
                text: textSpan,
                maxLines: 3,
                textDirection: Directionality.of(context),
              )..layout(maxWidth: constraints.maxWidth);

              final isOverflowing = tp.didExceedMaxLines;

              if (!isOverflowing) {
                return Text(item.content, style: textStyle);
              }

              return GestureDetector(
                onTap: () => setState(() => _isExpanded = true),
                child: RichText(
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: item.content,
                    style: textStyle,
                    children: [
                      TextSpan(text: '....', style: seeMoreStyle),
                      TextSpan(text: context.tr.newsSeeMore, style: seeMoreStyle),
                    ],
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 14.h),

          // ── Media ──
          if (imageUrls.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: SizedBox(
                height: 200.h,
                width: double.infinity,
                child: _AttachmentsSlider(imageUrls: imageUrls),
              ),
            ),
            SizedBox(height: 14.h),
          ],

          // ── Reactions count ──
          Row(
            children: [
              _ReactionBadge(),
              SizedBox(width: 6.w),
              Text(
                '$totalReactions',
                style: AppTextStyles.bodyMedium(color: AppColors.darkText)
                    .copyWith(fontSize: 14.sp),
              ),
            ],
          ),

          SizedBox(height: 10.h),
          Divider(height: 1, color: AppColors.border.withValues(alpha: 0.5)),
          SizedBox(height: 4.h),

          // ── Actions ──
          Row(
            children: [
              _ActionButton(
                icon: Iconsax.like_1,
                label: context.tr.newsLike,
                isSelected: isLiked,
                isLoading: widget.isLikeLoading,
                selectedColor: AppColors.blue,
                onTap: widget.onLike,
              ),
              SizedBox(width: 24.w),
              _ActionButton(
                icon: Iconsax.lovely,
                label: context.tr.newsHelpful,
                isSelected: isHelpful,
                isLoading: widget.isHelpfulLoading,
                selectedColor: AppColors.error,
                onTap: widget.onHelpful,
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
      width: 36.w,
      height: 22.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 22.w,
              height: 22.w,
              decoration: const BoxDecoration(
                color: Color(0xFF2F80ED),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.thumb_up, color: Colors.white, size: 12.sp),
            ),
          ),
          Positioned(
            left: 14.w,
            top: 0,
            child: Container(
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                color: const Color(0xFFEB5757),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.background, width: 1.5),
              ),
              child: Icon(Icons.favorite, color: Colors.white, size: 12.sp),
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
    this.selectedColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isLoading;
  final Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    final color =
        isSelected ? (selectedColor ?? AppColors.primaryDark) : AppColors.greyText;
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              SizedBox(
                width: 18.w,
                height: 18.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: color,
                ),
              )
            else
              Icon(icon, size: 20.sp, color: color),
            SizedBox(width: 6.w),
            Text(
              label,
              style: AppTextStyles.bodyMedium(color: color)
                  .copyWith(fontSize: 14.sp),
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
          Positioned(
            bottom: 10.h,
            left: 0,
            right: 0,
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
