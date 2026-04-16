import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  /// 18px Semibold - Section title (matches Figma "Select Language")
  static TextStyle heading1({Color? color}) => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.darkText,
      );

  /// 16px Semibold - Screen title / section header (matches Figma "Quick Actions")
  static TextStyle heading2({Color? color}) => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.darkText,
      );

  /// 17px Semibold - Nav bar title
  static TextStyle navTitle({Color? color}) => GoogleFonts.inter(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.darkText,
      );

  /// 15px Medium - Language card text
  static TextStyle cardTitle({Color? color}) => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.darkText,
      );

  /// 14px Semibold - Button text
  static TextStyle button({Color? color}) => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.darkText,
      );

  /// 14px Medium - Body
  static TextStyle bodyMedium({Color? color}) => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.bodyText,
      );

  /// 13px Medium - Subtitle
  static TextStyle subtitle({Color? color}) => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.greyText,
      );

  /// 13px Regular - Body text
  static TextStyle body({Color? color}) => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.darkText,
      );

  /// 12px Regular - Caption
  static TextStyle caption({Color? color}) => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.greyText,
      );

  /// 12px Medium - Small medium
  static TextStyle smallMedium({Color? color}) => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.darkText,
      );

  /// 11px Medium - Tab label / greeting
  static TextStyle tabLabel({Color? color}) => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.greyText,
      );

  /// 11px Regular - Small text
  static TextStyle small({Color? color}) => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.lightGreyText,
      );

  /// 10px Regular - Tiny text (footer links)
  static TextStyle tiny({Color? color}) => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.captionText,
      );

  /// 9px Regular - Extra small
  static TextStyle extraSmall({Color? color}) => GoogleFonts.inter(
        fontSize: 9,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.greyText,
      );
}
