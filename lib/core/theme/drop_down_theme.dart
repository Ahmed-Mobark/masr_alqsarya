import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:masr_al_qsariya/core/config/app_colors.dart';
import 'package:masr_al_qsariya/core/config/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DropdownTheme {
  static CustomDropdownDecoration dropdownMultiSelectDecoration({required BuildContext context, Color? color, Color? borderColor}) {
    return CustomDropdownDecoration(       
      hintStyle: TextStyles.textViewRegular12.copyWith(color: Theme.of(context).hintColor),
      headerStyle: TextStyles.textViewBold14,
      listItemDecoration: ListItemDecoration(
        splashColor: Theme.of(context).primaryColor.withValues(alpha: 0.25),
        highlightColor: Theme.of(context).primaryColor.withValues(alpha: 0.25),
        selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.15),
        selectedIconShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.r),
          side: BorderSide(color: Theme.of(context).primaryColor)
        )
      ), 
      closedBorder: Border.all(color: Theme.of(context).dividerColor, width: 1.5.r),
      closedErrorBorder: Border.all(color: AppColors.red, width: 1.5.r),
      expandedBorder: Border.all(color: Theme.of(context).dividerColor, width: 1.5.r),
      closedSuffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: Theme.of(context).hintColor, size: 20.r,),
      expandedSuffixIcon: Icon(Icons.keyboard_arrow_up_rounded, color: Theme.of(context).hintColor, size: 20.r,),
      closedErrorBorderRadius: BorderRadius.circular(15.r),
      searchFieldDecoration: SearchFieldDecoration(
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        prefixIcon: Icon(
          Icons.search,
          color: Theme.of(context).primaryColor,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: Theme.of(context).primaryColor)
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: Theme.of(context).dividerColor)
        ),
      ),
      errorStyle: TextStyles.textViewRegular12.copyWith(color: AppColors.red, fontWeight: FontWeight.w500),
      expandedBorderRadius: BorderRadius.circular(15.r),
      closedBorderRadius: BorderRadius.circular(15.r),
      expandedFillColor: color ?? Theme.of(context).scaffoldBackgroundColor,
      closedFillColor: color ?? Theme.of(context).scaffoldBackgroundColor,
    );
  }
}