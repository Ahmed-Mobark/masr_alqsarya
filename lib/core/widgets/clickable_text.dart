import 'package:masr_al_qsariya/core/config/app_colors.dart';
import 'package:masr_al_qsariya/core/config/styles/styles.dart';
import 'package:flutter/material.dart';

class ClickableText extends StatelessWidget {
  final String? text;
  final Widget? child;
  final Color? color;
  final TextStyle? textStyle;
  final Function()? onTap;
  const ClickableText({this.color, this.child, this.text, this.textStyle, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.transparent,
      highlightColor: AppColors.transparent,
      splashFactory: NoSplash.splashFactory,
      child: text != null ? Text(text!, style: textStyle?? TextStyles.textViewRegular14.copyWith(color: color?? Theme.of(context).primaryColor)) : child
    );
  }
}