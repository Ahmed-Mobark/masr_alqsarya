import 'package:masr_al_qsariya/core/config/app_colors.dart';
import 'package:masr_al_qsariya/core/config/styles/styles.dart';
import 'package:masr_al_qsariya/core/toast/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomToast extends StatefulWidget {
  final AnimationController? controller;
  final ToastType type;
  final String message;
  final String? description;
  final TextStyle? messageStyle;
  final TextStyle? descriptionStyle;
  final Function()? onTap;
  final Curve? curve;
  final bool? isClosable;
  final bool isInFront;
  final VoidCallback? onClose;

  const CustomToast({
    required this.controller,
    required this.message,
    required this.type,
    required this.isInFront,
    this.onTap,
    this.onClose,
    this.description,
    this.descriptionStyle,
    this.messageStyle,
    this.isClosable,
    this.curve,
    super.key,
  });

  @override
  State<CustomToast> createState() => _CustomToastState();
}

class _CustomToastState extends State<CustomToast> {
  Color getColor() => switch (widget.type) {
    ToastType.success => Colors.green,
    ToastType.warning => AppColors.yellow,
    ToastType.error => AppColors.red,
  };

  IconData getIcon() => switch (widget.type) {
    ToastType.success => Icons.check_circle_outline,
    ToastType.warning => Icons.warning_amber_rounded,
    ToastType.error => Icons.error_outline,
  };

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller!,
      builder: (context, _) {
        return Material(
          color: Colors.transparent,
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: const Offset(0.0, 0.0),
                ).animate(
                  CurvedAnimation(
                    parent: widget.controller!,
                    curve: widget.curve ?? Curves.elasticOut,
                    reverseCurve: widget.curve ?? Curves.elasticOut,
                  ),
                ),
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              padding: EdgeInsetsDirectional.only(start: 3.w),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: getColor(),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  gradient: LinearGradient(
                    colors: [Theme.of(context).cardColor, getColor()],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 35.w,
                      height: 35.h,
                      margin: EdgeInsetsDirectional.only(end: 10.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSurface,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(getIcon(), color: getColor(), size: 20.sp),
                    ),
                    // getIcon(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 5.h,
                        children: [
                          Text(
                            widget.message,
                            style:
                                widget.messageStyle ??
                                TextStyles.textViewBold14,
                          ),
                          if (widget.description != null)
                            Text(
                              widget.description!,
                              style:
                                  widget.descriptionStyle ??
                                  TextStyles.textViewRegular14.copyWith(
                                    color: Theme.of(context).hintColor,
                                  ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
