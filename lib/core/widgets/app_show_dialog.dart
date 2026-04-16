import 'package:masr_al_qsariya/core/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppShowDialog extends StatelessWidget {
  final List<Widget> children;
  const AppShowDialog({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: AppColors.transparent,
        child: IntrinsicHeight(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30.w),
            padding: EdgeInsets.all(15.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: Theme.of(context).dividerColor),
              color: Theme.of(context).cardColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}