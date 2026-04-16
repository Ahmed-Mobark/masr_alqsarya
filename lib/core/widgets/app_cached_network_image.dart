import 'package:cached_network_image/cached_network_image.dart';
import 'package:masr_al_qsariya/core/config/app_colors.dart';
import 'package:masr_al_qsariya/core/config/app_images.dart';
import 'package:masr_al_qsariya/core/widgets/app_shimmer.dart';
import 'package:flutter/material.dart';

class AppCachedNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final BoxFit fit;
  final double? height;
  final double? width;
  const AppCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.height,
    this.width,
  });

  static ImageProvider getImageProvider(String imageUrl) {
    return CachedNetworkImageProvider(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return imageUrl == null
        ? Image.asset(AppImages.logo, fit: fit, height: height, width: width)
        : CachedNetworkImage(
            imageUrl: imageUrl!,
            fit: fit,
            errorWidget: (context, url, error) => Image.asset(AppImages.logo),
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                AppShimmer(child: Container(color: AppColors.primary)),
            placeholderFadeInDuration: const Duration(milliseconds: 300),
            fadeOutDuration: const Duration(milliseconds: 300),
            fadeInDuration: const Duration(milliseconds: 300),
            fadeInCurve: Curves.easeInOut,
            fadeOutCurve: Curves.easeInOut,
          );
  }
}
