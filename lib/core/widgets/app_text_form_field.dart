import 'package:masr_al_qsariya/core/config/app_icons.dart';
import 'package:masr_al_qsariya/core/config/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final bool onlyDigit;
  final String? hintText;
  final String? suffixIcon;
  final String? prefixIcon;
  final Widget? suffix;
  final Widget? prefix;
  final Widget? suffixWidget;
  final bool? alignLabelWithHint;
  final Widget? prefixWidget;
  final int? maxLength;
  final bool readOnly;
  final Color? cardColor;
  final Color? textColor;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry? contentPadding;
  final Function()? onTap;
  final void Function()? onSuffixPressed;
  final void Function(String)? onChanged;
  final bool? obscureText;
  final TextStyle? hintStyle;
  final String? label;
  final String? obscuringCharacter;
  final int? minLines;

  final double? borderRadius;
  final bool showBorder;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;

  const AppTextFormField({
    super.key,
    required this.controller,
    this.validator,
    this.autovalidateMode,
    this.onlyDigit = false,
    this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.suffix,
    this.prefix,
    this.suffixWidget,
    this.alignLabelWithHint,
    this.prefixWidget,
    this.maxLength,
    this.readOnly = false,
    this.cardColor,
    this.textColor,
    this.keyboardType,
    this.contentPadding,
    this.onTap,
    this.onSuffixPressed,
    this.onChanged,
    this.obscureText,
    this.hintStyle,
    this.label,
    this.obscuringCharacter,
    this.minLines,

    this.borderRadius,
    this.showBorder = true,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular((borderRadius ?? 12).r);

    OutlineInputBorder buildBorder(Color color) {
      return OutlineInputBorder(
        borderRadius: radius,
        borderSide: showBorder
            ? BorderSide(color: color, width: 1)
            : BorderSide.none,
      );
    }

    return TextFormField(
      controller: controller,
      obscureText: obscureText ?? false,
      minLines: minLines ?? 1,
      maxLines: minLines != null ? null : 1,
      validator: validator,
      onTap: onTap,
      readOnly: readOnly,
      style: TextStyles.textViewMedium14.copyWith(
        color: textColor ?? Colors.black,
      ),
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      obscuringCharacter: obscuringCharacter ?? "●",
      onChanged: onChanged,
      inputFormatters: onlyDigit
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      autovalidateMode: autovalidateMode ?? AutovalidateMode.onUserInteraction,
      cursorColor: Theme.of(context).primaryColor,
      keyboardType: keyboardType ?? TextInputType.text,
      maxLength: maxLength,
      maxLengthEnforcement: MaxLengthEnforcement.none,
      decoration: InputDecoration(
        filled: true,
        fillColor: cardColor ?? Theme.of(context).cardColor,
        hintText: hintText,
        hintStyle: hintStyle,
        labelText: label,
        labelStyle: hintStyle,
        contentPadding:
            contentPadding ??
            EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),

        prefixIcon:
            prefixWidget ??
            (prefixIcon == null
                ? null
                : AppIcons.icon(
                    size: 18,
                    icon: prefixIcon!,
                    color: Theme.of(context).hintColor,
                  )),
        suffixIcon:
            suffixWidget ??
            (suffixIcon == null
                ? null
                : AppIcons.icon(
                    size: 18,
                    icon: suffixIcon!,
                    color: Theme.of(context).hintColor,
                  )),
        prefix: prefix,
        suffix: suffix,

        enabledBorder: buildBorder(borderColor ?? Colors.grey.shade500),
        focusedBorder: buildBorder(
          focusedBorderColor ?? Theme.of(context).primaryColor,
        ),
        errorBorder: buildBorder(errorBorderColor ?? Colors.red),
        focusedErrorBorder: buildBorder(errorBorderColor ?? Colors.red),
      ),
    );
  }
}
