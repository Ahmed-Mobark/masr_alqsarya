import 'package:flutter/material.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.heading2()),
        if (actionText != null)
          GestureDetector(
            onTap: onActionTap ?? () {},
            child: Text(
              actionText!,
              style: AppTextStyles.subtitle(color: AppColors.primaryDark),
            ),
          ),
      ],
    );
  }
}
