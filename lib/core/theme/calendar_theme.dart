import 'package:masr_al_qsariya/core/config/app_colors.dart';
import 'package:masr_al_qsariya/core/config/styles/styles.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalendarTheme {
  static ThemeData getCalendarTheme(
    BuildContext context,
  ) => Theme.of(context).copyWith(
    colorScheme: ColorScheme.dark(
      primary: Theme.of(context).primaryColor, // Selected date circle
      onPrimary: Colors.white, // Selected date text
      surface: Theme.of(context).scaffoldBackgroundColor, // Dialog background
      onSurface: Theme.of(context).colorScheme.onSurface, // General text color
    ),
    datePickerTheme: DatePickerThemeData(
      confirmButtonStyle: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
        foregroundColor: const WidgetStatePropertyAll(
          AppColors.scaffoldColorLight,
        ),
      ),
      cancelButtonStyle: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
        foregroundColor: const WidgetStatePropertyAll(
          AppColors.scaffoldColorLight,
        ),
      ),
      headerHelpStyle: TextStyles.textViewBold16.copyWith(
        color: Theme.of(context).primaryColor,
      ),
      dayStyle: TextStyles.textViewBold14,
      weekdayStyle: TextStyles.textViewBold14,
      yearStyle: TextStyles.textViewBold14,
      locale: Locale(sl<Storage>().getLang()),
      headerHeadlineStyle: TextStyles.textViewBold27,
    ),
    timePickerTheme: TimePickerThemeData(
      confirmButtonStyle: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
        foregroundColor: const WidgetStatePropertyAll(
          AppColors.scaffoldColorLight,
        ),
      ),
      cancelButtonStyle: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
        foregroundColor: const WidgetStatePropertyAll(
          AppColors.scaffoldColorLight,
        ),
      ),
      dayPeriodShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
        side: BorderSide(color: Theme.of(context).primaryColor),
      ),
      timeSelectorSeparatorColor: WidgetStatePropertyAll(
        Theme.of(context).primaryColor,
      ),
      hourMinuteTextStyle: TextStyles.textViewBold27,
      entryModeIconColor: Theme.of(context).primaryColor,

      helpTextStyle: TextStyles.textViewBold16.copyWith(
        color: Theme.of(context).primaryColor,
      ),
      dialTextStyle: TextStyles.textViewBold14,
      timeSelectorSeparatorTextStyle: WidgetStatePropertyAll(
        TextStyles.textViewBold16,
      ),
      dayPeriodColor: Theme.of(context).primaryColor,
      dayPeriodTextColor: Theme.of(context).hintColor,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    ),
  );
}
