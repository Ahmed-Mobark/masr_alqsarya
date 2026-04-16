import 'package:masr_al_qsariya/core/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleContainer extends StatelessWidget {
  final double size;
  final Color? color;
  final Widget? child;
  final BoxBorder? border;
  final Clip clipBehavior;
  final Color? borderColor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final bool noAlignment;
  final Function()? onTap;
  final double? borderRadius;
  const CircleContainer({
    this.borderColor,
    this.noAlignment = false,
    this.clipBehavior = Clip.hardEdge,
    this.onTap,
    this.child,
    this.alignment,
    this.margin,
    this.padding,
    this.color,
    this.border,
    this.size = 100,
    this.borderRadius,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: AppColors.transparent,
      splashColor: AppColors.transparent,
      splashFactory: NoSplash.splashFactory,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: size.w,
        height: size.h,
        clipBehavior: clipBehavior,
        alignment: noAlignment ? null : alignment ?? Alignment.center,
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          shape: borderRadius != null ? BoxShape.rectangle : BoxShape.circle,
          borderRadius: borderRadius != null
              ? BorderRadius.circular(borderRadius!)
              : null,
          border:
              border ??
              (borderColor != null
                  ? Border.all(
                      color: borderColor!,
                      strokeAlign: BorderSide.strokeAlignOutside,
                      width: 1.5.r,
                    )
                  : null),
        ),
        child: child,
      ),
    );
  }
}
