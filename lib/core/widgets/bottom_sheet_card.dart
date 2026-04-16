import 'package:masr_al_qsariya/core/config/app_colors.dart';
import 'package:masr_al_qsariya/core/config/app_icons.dart';
import 'package:masr_al_qsariya/core/config/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomSheetCard extends StatelessWidget {
  final String icon;
  final String text;
  final Function()? onTap;
  const BottomSheetCard({
    required this.icon,
    required this.text,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      overlayColor: const WidgetStatePropertyAll(AppColors.transparent),
      child: Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: Row(
          spacing: 15.w,
          children: [
            Container(
              width: 35.w,
              height: 35.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: AppIcons.icon(
                icon: icon,
                size: 16,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(text, style: TextStyles.textViewBold12),
          ],
        ),
      ),
    );
  }
}
