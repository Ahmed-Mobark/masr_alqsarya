import 'package:masr_al_qsariya/core/config/app_colors.dart';
import 'package:masr_al_qsariya/core/config/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckboxFormfield extends FormField<bool> {
  final EdgeInsetsGeometry? margin;
  final CrossAxisAlignment? crossAxisAlignment;
  CheckboxFormfield({
    double? size,
    Widget? child,
    BorderSide? side,
    this.crossAxisAlignment,
    Color? activeColor,
    OutlinedBorder? shape,
    this.margin,
    super.onSaved,
    super.validator,
    bool super.initialValue = true,
    bool autovalidate = false,
    super.key
  })
  :super(
    builder: (FormFieldState<bool> state) {
      return Padding(
        padding: margin?? EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: crossAxisAlignment??CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: size?? 30.w,
                  height: size?? 30.h,
                  child: Checkbox(
                    activeColor: activeColor,
                    value: state.value,
                    onChanged: state.didChange,
                    shape: shape,
                    side: side,
                  ),
                ),
                if(child != null) Padding(
                  padding: EdgeInsetsDirectional.only(start: 3.w),
                  child: child,
                )
              ],
            ),
            if(state.hasError) Builder(
              builder: (BuildContext context) => Padding(
                padding: EdgeInsetsDirectional.only(top: 3.h, start: 10.w),
                child: Text(
                  state.errorText??'',
                  style: TextStyles.textViewRegular14.copyWith(color: AppColors.red),
                ),
              ),
            ),
          ],
        ),
      );
    }
  );
}