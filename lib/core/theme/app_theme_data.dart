import 'package:masr_al_qsariya/core/config/app_colors.dart';
import 'package:masr_al_qsariya/core/config/styles/font_utils.dart';
import 'package:masr_al_qsariya/core/config/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppThemeData {
  static PageTransitionsTheme pageTransitionsTheme = const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  );

  static AppBarTheme appBarTheme({required Color texColor, backgroundColor}) =>
      AppBarTheme(
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        titleTextStyle: TextStyles.textViewMedium14.copyWith(
          color: texColor,
          fontFamily: AppFont.fontFamily,
        ),
        backgroundColor: backgroundColor,
        surfaceTintColor: backgroundColor,
        shadowColor: AppColors.transparent,
        iconTheme: IconThemeData(color: texColor, size: 20.r),
      );

  static InputDecorationTheme inputDecorationTheme({
    required Color fillColor,
    hintColor,
    textColor,
    borderColor,
    primaryColor,
  }) => InputDecorationTheme(
    filled: false,
    fillColor: fillColor,
    suffixIconColor: hintColor,
    prefixIconColor: hintColor,
    contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
    hintStyle: TextStyle(
      color: hintColor,
      fontSize: 12.sp,
      fontWeight: AppFont.medium,
      fontFamily: AppFont.fontFamily,
    ),
    labelStyle: TextStyle(
      color: textColor,
      fontSize: 12.sp,
      fontWeight: AppFont.medium,
      fontFamily: AppFont.fontFamily,
    ),
    floatingLabelStyle: TextStyle(
      color: hintColor,
      fontSize: 12.sp,
      fontWeight: AppFont.medium,
      fontFamily: AppFont.fontFamily,
    ),
    errorStyle: TextStyle(
      color: AppColors.red,
      fontSize: 12.sp,
      fontWeight: AppFont.medium,
      fontFamily: AppFont.fontFamily,
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: borderColor, width: 1.5.r),
      borderRadius: BorderRadius.circular(15.r),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: borderColor, width: 1.5.r),
      borderRadius: BorderRadius.circular(15.r),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: primaryColor, width: 1.5.r),
      borderRadius: BorderRadius.circular(15.r),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: borderColor, width: 1.5.r),
      borderRadius: BorderRadius.circular(15.r),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.red, width: 1.5.r),
      borderRadius: BorderRadius.circular(15.r),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.red, width: 1.5.r),
      borderRadius: BorderRadius.circular(15.r),
    ),
  );

  static ElevatedButtonThemeData elevatedButtonThemeData({
    required Color primaryColor,
  }) => ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      shadowColor: AppColors.transparent,
      overlayColor: AppColors.transparent,
      splashFactory: NoSplash.splashFactory,
      surfaceTintColor: AppColors.transparent,
      alignment: Alignment.center,
      padding: EdgeInsets.zero,
      elevation: 0,
    ),
  );

  static CheckboxThemeData checkboxThemeData({required Color primaryColor}) =>
      CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (Set<WidgetState> states) => states.contains(WidgetState.selected)
              ? primaryColor
              : AppColors.transparent,
        ),
        side: WidgetStateBorderSide.resolveWith(
          (Set<WidgetState> states) => states.contains(WidgetState.selected)
              ? BorderSide.none
              : BorderSide(color: primaryColor, width: 1.5.r),
        ),
        checkColor: WidgetStateProperty.all(AppColors.cardColorLight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
      );

  static TabBarThemeData tabBarThemeData({
    required Color primaryColor,
    borderColor,
  }) => TabBarThemeData(
    labelColor: primaryColor,
    indicatorColor: borderColor,
    unselectedLabelColor: primaryColor.withValues(alpha: 0.2),
    indicatorSize: TabBarIndicatorSize.tab,
    labelStyle: TextStyle(
      color: AppColors.scaffoldColorLight,
      fontWeight: AppFont.medium,
      fontSize: 14.sp,
      fontFamily: AppFont.fontFamily,
    ),
    unselectedLabelStyle: TextStyle(
      color: primaryColor,
      fontWeight: AppFont.medium,
      fontSize: 14.sp,
      fontFamily: AppFont.fontFamily,
    ),
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: primaryColor),
      insets: EdgeInsetsDirectional.symmetric(horizontal: 25.w),
    ),
    dividerColor: AppColors.transparent,
  );

  static TextTheme textTheme({required Color textColor}) => TextTheme(
    // Display styles - for large headlines
    displayLarge: TextStyle(
      color: textColor,
      fontSize: FontSizes.s24,
      fontWeight: AppFont.bold,
      fontFamily: AppFont.fontFamily,
    ),
    displayMedium: TextStyle(
      color: textColor,
      fontSize: FontSizes.s22,
      fontWeight: AppFont.semiBold,
      fontFamily: AppFont.fontFamily,
    ),
    displaySmall: TextStyle(
      color: textColor,
      fontSize: FontSizes.s20,
      fontWeight: AppFont.semiBold,
      fontFamily: AppFont.fontFamily,
    ),

    // Headline styles - for section headers
    headlineLarge: TextStyle(
      color: textColor,
      fontSize: FontSizes.s18,
      fontWeight: AppFont.semiBold,
      fontFamily: AppFont.fontFamily,
    ),
    headlineMedium: TextStyle(
      color: textColor,
      fontSize: FontSizes.s16,
      fontWeight: AppFont.semiBold,
      fontFamily: AppFont.fontFamily,
    ),
    headlineSmall: TextStyle(
      color: textColor,
      fontSize: FontSizes.s14,
      fontWeight: AppFont.medium,
      fontFamily: AppFont.fontFamily,
    ),

    // Title styles - for card titles, buttons
    titleLarge: TextStyle(
      color: textColor,
      fontSize: FontSizes.s16,
      fontWeight: AppFont.semiBold,
      fontFamily: AppFont.fontFamily,
    ),
    titleMedium: TextStyle(
      color: textColor,
      fontSize: FontSizes.s14,
      fontWeight: AppFont.medium,
      fontFamily: AppFont.fontFamily,
    ),
    titleSmall: TextStyle(
      color: textColor,
      fontSize: FontSizes.s12,
      fontWeight: AppFont.medium,
      fontFamily: AppFont.fontFamily,
    ),

    // Body styles - for main content
    bodyLarge: TextStyle(
      color: textColor,
      fontSize: FontSizes.s16,
      fontWeight: AppFont.regular,
      fontFamily: AppFont.fontFamily,
    ),
    bodyMedium: TextStyle(
      color: textColor,
      fontSize: FontSizes.s14,
      fontWeight: AppFont.regular,
      fontFamily: AppFont.fontFamily,
    ),
    bodySmall: TextStyle(
      color: textColor,
      fontSize: FontSizes.s12,
      fontWeight: AppFont.regular,
      fontFamily: AppFont.fontFamily,
    ),

    // Label styles - for form labels, captions
    labelLarge: TextStyle(
      color: textColor,
      fontSize: FontSizes.s14,
      fontWeight: AppFont.medium,
      fontFamily: AppFont.fontFamily,
    ),
    labelMedium: TextStyle(
      color: textColor,
      fontSize: FontSizes.s12,
      fontWeight: AppFont.medium,
      fontFamily: AppFont.fontFamily,
    ),
    labelSmall: TextStyle(
      color: textColor,
      fontSize: FontSizes.s10,
      fontWeight: AppFont.medium,
      fontFamily: AppFont.fontFamily,
    ),
  );
}
