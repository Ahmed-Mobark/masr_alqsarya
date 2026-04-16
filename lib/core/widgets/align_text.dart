import 'package:masr_al_qsariya/core/config/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlignText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Color? textColor;
  const AlignText({this.textColor, this.style, this.alignment, this.padding, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding?? EdgeInsetsDirectional.only(top: 15.h, bottom: 5.h, start: 5.w),
      child: Align(
        alignment: alignment ?? AlignmentDirectional.centerStart,
        child: Text(text, style: style ??  TextStyles.textViewRegular12.copyWith(color: textColor)),
      ),
    );
  }
}