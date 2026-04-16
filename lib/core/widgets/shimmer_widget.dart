import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/config/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class AppShimmer extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration? duration;
  final bool enabled;

  const AppShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return Shimmer.fromColors(
      baseColor:
          baseColor ?? AppColors.greyTextColorLight.withValues(alpha: 0.3),
      highlightColor: highlightColor ?? Colors.white.withValues(alpha: 0.8),
      period: duration ?? const Duration(milliseconds: 1500),
      direction: ShimmerDirection.ltr,
      child: child,
    );
  }
}

class ShimmerContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const ShimmerContainer({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.color,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppColors.greyTextColorLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
      ),
    );
  }
}

class ShimmerText extends StatelessWidget {
  final double? width;
  final double? height;
  final double? fontSize;
  final EdgeInsetsGeometry? margin;

  const ShimmerText({
    super.key,
    this.width,
    this.height,
    this.fontSize,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? (fontSize != null ? fontSize! * 1.2 : 16.h),
      margin: margin,
      decoration: BoxDecoration(
        color: AppColors.greyTextColorLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}

class ShimmerCircle extends StatelessWidget {
  final double? size;
  final EdgeInsetsGeometry? margin;

  const ShimmerCircle({super.key, this.size, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? 40.w,
      height: size ?? 40.h,
      margin: margin,
      decoration: BoxDecoration(
        color: AppColors.greyTextColorLight.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
    );
  }
}
