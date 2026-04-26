import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';

class AddExpenseFieldContainer extends StatelessWidget {
  final Widget child;
  final FocusNode? focusNode;

  const AddExpenseFieldContainer({
    super.key,
    required this.child,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final node = focusNode;

    if (node == null) {
      return _decoratedBox(
        isFocused: false,
        child: child,
      );
    }

    return AnimatedBuilder(
      animation: node,
      builder: (context, _) {
        return _decoratedBox(
          isFocused: node.hasFocus,
          child: child,
        );
      },
    );
  }

  Widget _decoratedBox({required bool isFocused, required Widget child}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOut,
      width: double.infinity,
      height: 54.h,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isFocused ? AppColors.yellow : Colors.transparent,
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 16.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: child,
    );
  }
}

