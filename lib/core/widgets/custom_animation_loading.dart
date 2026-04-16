import 'package:masr_al_qsariya/core/config/app_colors.dart';
import 'package:masr_al_qsariya/core/config/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CustomAnimationLoading extends StatelessWidget {
  const CustomAnimationLoading({super.key});
  
  @override
  Widget build(BuildContext context) {
    return  Material(
      color: AppColors.transparent,
      child: Center(
        child: Image.asset(
          AppImages.logo,
          width: MediaQuery.sizeOf(context).width*0.4,
          color: Theme.of(context).cardColor,
        ).animate(delay: 400.ms, onPlay: (controller) => controller.repeat(reverse: true)).shimmer(duration: 2.seconds, colors: [Theme.of(context).primaryColor, Theme.of(context).cardColor, Theme.of(context).primaryColor,]),
      ),
    );
  }
}