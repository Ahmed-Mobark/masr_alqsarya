import 'package:flutter/material.dart';
import 'package:masr_al_qsariya/core/data/dummy_data.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';

class AwaitingCard extends StatelessWidget {
  const AwaitingCard({
    super.key,
    required this.item,
    this.onTap,
  });

  final AwaitingItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 344,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary, // #FEDB65
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: avatar + info + status badge
            Row(
              children: [
                // Avatar placeholder
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.white,
                  child: Icon(
                    Icons.person,
                    size: 20,
                    color: AppColors.greyText,
                  ),
                ),
                const SizedBox(width: 12),
                // Name and details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.darkText,
                        ).copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'From: ${item.from}',
                        style: AppTextStyles.caption(
                          color: AppColors.darkText.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.statusBadge, // #C89563
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    item.status,
                    style: AppTextStyles.small(
                      color: AppColors.white,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Bottom: time info
            Row(
              children: [
                Text(
                  item.time,
                  style: AppTextStyles.caption(
                    color: AppColors.darkText.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
