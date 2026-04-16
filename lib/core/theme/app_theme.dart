import 'package:masr_al_qsariya/core/config/app_colors.dart';
import 'package:masr_al_qsariya/core/config/styles/font_utils.dart';
import 'package:masr_al_qsariya/core/theme/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static ThemeData appLightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.scaffoldColorLight,
    primaryColor: AppColors.primary,
    canvasColor: AppColors.cardColorLight,
    cardColor: AppColors.cardColorLight,
    disabledColor: AppColors.primary.withValues(alpha: 0.2),
    hintColor: AppColors.hintColorLight,
    dividerTheme: DividerThemeData(
      color: AppColors.borderColorLight,
      space: 20.h,
      thickness: 1.25.r,
    ),
    unselectedWidgetColor: AppColors.primary.withValues(alpha: 0.2),
    dividerColor: AppColors.borderColorLight,
    fontFamily: AppFont.fontFamily,
    pageTransitionsTheme: AppThemeData.pageTransitionsTheme,
    appBarTheme: AppThemeData.appBarTheme(
      texColor: AppColors.textColorLight,
      backgroundColor: AppColors.scaffoldColorLight,
    ),
    colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.cardColorLight,
      surface: AppColors.textColorLight,
      shadow: AppColors.borderColorLight,
      outline: AppColors.borderColorLight,
      onError: AppColors.red,
      onPrimary: AppColors.cardColorLight,
    ),
    inputDecorationTheme: AppThemeData.inputDecorationTheme(
      fillColor: AppColors.scaffoldColorLight,
      borderColor: AppColors.borderColorLight,
      hintColor: AppColors.hintColorLight,
      primaryColor: AppColors.primary,
      textColor: AppColors.textColorLight,
    ),
    elevatedButtonTheme: AppThemeData.elevatedButtonThemeData(
      primaryColor: AppColors.primary,
    ),
    checkboxTheme: AppThemeData.checkboxThemeData(
      primaryColor: AppColors.primary,
    ),
    iconTheme: IconThemeData(color: AppColors.hintColorLight, size: 25.r),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionHandleColor: AppColors.primary,
    ),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.cardColorLight,
      surfaceTintColor: AppColors.textColorLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.cardColorLight,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.hintColorLight,
    ),
    tabBarTheme: AppThemeData.tabBarThemeData(
      primaryColor: AppColors.primary,
      borderColor: AppColors.borderColorLight,
    ),
    textTheme: AppThemeData.textTheme(textColor: AppColors.textColorLight),
    cardTheme: CardThemeData(
      elevation: 0.25,
      color: AppColors.cardColorLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textColorDark,
    ),
    listTileTheme: const ListTileThemeData(
      horizontalTitleGap: 2,
      minLeadingWidth: 0,
      minVerticalPadding: 0,
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      dense: true,
    ),
  );

  static ThemeData appDarkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.scaffoldColorDark,
    primaryColor: AppColors.primaryDark,
    canvasColor: AppColors.cardColorDark,
    cardColor: AppColors.cardColorDark,
    disabledColor: AppColors.primaryDark.withValues(alpha: 0.2),
    hintColor: AppColors.hintColorDark,
    dividerTheme: DividerThemeData(
      color: AppColors.borderColorDark,
      space: 20.h,
      thickness: 1.25.r,
    ),
    unselectedWidgetColor: AppColors.primaryDark.withValues(alpha: 0.2),
    dividerColor: AppColors.borderColorDark,
    fontFamily: AppFont.fontFamily,
    pageTransitionsTheme: AppThemeData.pageTransitionsTheme,
    appBarTheme: AppThemeData.appBarTheme(
      texColor: AppColors.textColorDark,
      backgroundColor: AppColors.scaffoldColorDark,
    ),
    colorScheme: const ColorScheme.dark(
      brightness: Brightness.dark,
      primary: AppColors.primaryDark,
      secondary: AppColors.cardColorDark,
      surface: AppColors.textColorDark,
      shadow: AppColors.borderColorDark,
      outline: AppColors.borderColorDark,
      onError: AppColors.red,
      onPrimary: AppColors.cardColorDark,
    ),
    inputDecorationTheme: AppThemeData.inputDecorationTheme(
      fillColor: AppColors.scaffoldColorDark,
      borderColor: AppColors.borderColorDark,
      hintColor: AppColors.hintColorDark,
      primaryColor: AppColors.primaryDark,
      textColor: AppColors.textColorDark,
    ),
    elevatedButtonTheme: AppThemeData.elevatedButtonThemeData(
      primaryColor: AppColors.primaryDark,
    ),
    checkboxTheme: AppThemeData.checkboxThemeData(
      primaryColor: AppColors.primaryDark,
    ),
    iconTheme: IconThemeData(color: AppColors.hintColorDark, size: 25.r),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primaryDark,
      selectionHandleColor: AppColors.primaryDark,
    ),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.cardColorDark,
      surfaceTintColor: AppColors.textColorDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.cardColorDark,
      selectedItemColor: AppColors.primaryDark,
      unselectedItemColor: AppColors.hintColorDark,
    ),
    tabBarTheme: AppThemeData.tabBarThemeData(
      primaryColor: AppColors.primaryDark,
      borderColor: AppColors.borderColorDark,
    ),
    textTheme: AppThemeData.textTheme(textColor: AppColors.textColorDark),
    cardTheme: CardThemeData(
      elevation: 0,
      color: AppColors.cardColorDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryDark,
      foregroundColor: AppColors.textColorDark,
    ),
    listTileTheme: const ListTileThemeData(
      horizontalTitleGap: 2,
      minLeadingWidth: 0,
      minVerticalPadding: 0,
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      dense: true,
    ),
  );
}
