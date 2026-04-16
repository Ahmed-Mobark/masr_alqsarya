import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomLoading extends StatelessWidget {
  final double? size; 
  final double? top; 
  final double? bottom; 
  final Color? color;
  final double? strokeWidth;
  const CustomLoading({this.strokeWidth, this.top, this.bottom, this.size, this.color, super.key});
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.only(top: top?.h ?? 0 , bottom: bottom?.h ?? 0),
      child: Center(
        child: SizedBox(
          width: size?.w ?? 30.w,
          height: size?.h ?? 30.h,
          child: CircularProgressIndicator(color: color ?? Theme.of(context).primaryColor, strokeWidth: strokeWidth?.r ?? 5.r),
        ),
      ),
    );
  }
}