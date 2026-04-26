import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/features/expense/presentation/widgets/dashed_border_painter.dart';

class AddExpenseDashedCard extends StatelessWidget {
  final Widget child;

  const AddExpenseDashedCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedBorderPainter(
        color: AppColors.border,
        strokeWidth: 1.w,
        dashLength: 7.w,
        gapLength: 6.w,
        radius: 18.r,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsetsDirectional.symmetric(horizontal: 18.w, vertical: 22.h),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Center(child: child),
      ),
    );
  }
}

