import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppFont {
  static String fontFamily = "ReadexPro";

  static void setLocale(String langCode) {
    fontFamily = langCode == 'ar' ? 'Almarai' : 'ReadexPro';
  }

  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.normal;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}

class FontSizes {
  static double get s8 => 8.sp;
  static double get s10 => 10.sp;
  static double get s12 => 12.sp;
  static double get s13 => 13.sp;
  static double get s14 => 14.sp;
  static double get s16 => 16.sp;
  static double get s18 => 18.sp;
  static double get s20 => 20.sp;
  static double get s22 => 22.sp;
  static double get s24 => 24.sp;
  static double get s26 => 26.sp;
  static double get s27 => 27.sp;
  static double get s28 => 28.sp;
}
