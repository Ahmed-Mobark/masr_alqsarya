import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDivider extends StatelessWidget {
  final DividerType type;
  final double length;
  final Color? color;
  final double margin;
  final double thickness;
  final double radius;
  const AppDivider({required this.type, required this.length, this.color, this.margin = 15, this.thickness = 1.5, this.radius = 5, super.key});
  
  bool isHorizontal() => type == DividerType.horizontal;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: !isHorizontal() ? thickness.w : length.w,
      height: isHorizontal() ? thickness.h : length.h,
      margin: EdgeInsets.symmetric(horizontal: isHorizontal()?0:margin.w , vertical: !isHorizontal()?0:margin.h),
      decoration: BoxDecoration(
        color: color?? Theme.of(context).dividerColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(radius.r)
      ),
    );
  }
}

enum DividerType {
  horizontal,
  vertical
}