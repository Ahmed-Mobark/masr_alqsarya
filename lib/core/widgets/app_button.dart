import 'package:masr_al_qsariya/core/config/app_colors.dart';
import 'package:masr_al_qsariya/core/config/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  final Function()? onTap;
  final Widget? child;
  final Color? color;
  final Color? textColor;
  final bool flexableHeight;
  final bool isBackIcon;
  final String? text;
  final Color? borderColor;
  final Gradient? gradient;
  final double? width;
  final double? heigh;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? radius;
  final List<BoxShadow>? boxShadow;
  final TextStyle? style;

  const AppButton({
    this.onTap,
    this.child,
    this.alignment,
    this.margin,
    this.padding,
    this.color,
    this.style,
    this.textColor,
    this.text,
    this.boxShadow,
    this.flexableHeight = false,
    this.isBackIcon = false,
    this.borderColor,
    this.radius,
    this.gradient,
    this.width,
    this.heigh,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: AppColors.transparent,
        highlightColor: AppColors.transparent,
        onTap: onTap,
        child: Container(
          width: width ?? double.infinity,
          height: flexableHeight ? null : heigh ?? 50.h,
          padding: padding ?? EdgeInsets.symmetric(horizontal: 15.w),
          alignment: alignment ?? Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius ?? 12.r),
            border: Border.all(
              color: borderColor ?? AppColors.transparent,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
            color: color ?? Theme.of(context).primaryColor,
            gradient: gradient,
            boxShadow: boxShadow,
          ),
          child: text != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text!,
                      style:
                          style ??
                          TextStyles.textViewSemiBold16.copyWith(
                            color: textColor ?? AppColors.cardColorLight,
                          ),
                    ),
                    if (isBackIcon) SizedBox(width: 8.w),
                    if (isBackIcon)
                      Icon(
                        Icons.arrow_forward,
                        color: textColor ?? AppColors.cardColorLight,
                        size: 16.w,
                      ),
                  ],
                )
              : child,
        ),
      ),
    );
  }
}
