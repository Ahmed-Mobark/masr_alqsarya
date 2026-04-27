import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color primary = Color(0xFFFEDB65);
  static const Color scaffoldColorLight = Color(0xFFF8F8F8);
  static const Color cardColorLight = Color(0xFFffffff);
  static const Color textColorLight = Color(0xFF2B2B2B);
  static const Color greyTextColorLight = Color(0xFF555555);
  static const Color hintColorLight = Color(0xFFA5A5A5);
  static const Color borderColorLight = Color(0xFFE8E4E4);
  static const Color disableColorLight = Color(0xFFA6BBBE);

  static const Color primaryDark = Color(0xFF645A9E);
  static const Color purpleColor = Color(0xFF5D5FEF);
  static const Color purpleColorLight = Color(0xFFE8E9FF);
  static const Color scaffoldColorDark = Color(0xFF121212);
  static const Color cardColorDark = Color(0xFF1E1E1E);
  static const Color textColorDark = Color(0xFFFFFFFF);
  static const Color greyTextColorDark = Color(0xFFB3B3B3);
  static const Color hintColorDark = Color(0xFF8C8C8C);
  static const Color borderColorDark = Color(0xFF333333);
  static const Color disableColorDark = Color(0xFF556E73);

  static const Color red = Color(0xFFD00416);
  static const Color yellow = Color(0xFFDFB400);
  static const Color green = Color(0xFF1FC16B);
  static const Color blue = Color(0xFF2F80ED);

  static const Color transparent = Colors.transparent;

  // ---------------------------------------------------------------------------
  // Compatibility aliases used across feature widgets/screens
  // ---------------------------------------------------------------------------
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  static const Color darkText = textColorLight;
  static const Color greyText = greyTextColorLight;
  static const Color captionText = hintColorLight;
  static const Color lightGreyText = hintColorLight;
  static const Color bodyText = textColorLight;

  static const Color border = borderColorLight;
  static const Color inputBg = Color(0xFFF2F2F2);

  static const Color scaffoldBg = scaffoldColorLight;
  static const Color background = cardColorLight;
  static const Color cardBg = cardColorLight;

  static const Color statusBadge = Color(0xFFC89563);
  static const Color tabActive = primary;
  static const Color tabInactive = hintColorLight;

  static const Color error = red;
  static const Color success = green;
  static const Color warning = yellow;

  // Social buttons
  static const Color google = Color(0xFFDB4437);
  static const Color apple = Color(0xFF000000);
}
