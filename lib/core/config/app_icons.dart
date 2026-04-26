import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIcons {
  AppIcons._();

  static const String _path = 'assets/icons/';

  // Icon paths
  static const String unseen = '${_path}unseen.svg';
  static const String seen = '${_path}seen.svg';
  static const String close = '${_path}close.svg';
  static const String camera = '${_path}camera.svg';
  static const String gallery = '${_path}gallery.svg';
  static const String file = '${_path}file.svg';
  static const String basket = '${_path}basket.png';
  static const String filter = '${_path}filter.png';
  static const String homeIcon = '${_path}home_icon.png';
  static const String productsIcon = '${_path}products_icon.png';
  static const String projectsIcon = '${_path}projects_icon.png';
  static const String contactIcon = '${_path}contact_us_icon.png';
  static const String languageIcon = '${_path}language_icon.png';
  static const String googleIcon = '${_path}google_icon.svg';
  static const String appleIcon = '${_path}apple_icon.svg';
  static const String documentsIcon = '${_path}docs.svg';

  // Method to render SVG as a widget
  static Widget icon({required String icon, double size = 24, Color? color}) {
    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.asset(
        icon,
        fit: BoxFit.contain,
        colorFilter: color == null
            ? null
            : ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
}
