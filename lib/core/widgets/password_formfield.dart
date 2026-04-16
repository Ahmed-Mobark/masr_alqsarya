import 'package:masr_al_qsariya/core/config/app_colors.dart';
import 'package:masr_al_qsariya/core/config/app_icons.dart';
import 'package:masr_al_qsariya/core/widgets/app_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordFormField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final String hintText;
  final TextInputType? keyboardType;
  final String? label;
  final String? Function(String?)? validator;
  const PasswordFormField({
    super.key,
    required this.controller,
    this.onChanged,
    required this.hintText,
    this.label,
    this.keyboardType,
    this.validator,
  });
  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool visiblePassword = false;

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      obscureText: !visiblePassword,
      obscuringCharacter: "●",
      validator: widget.validator,
      suffixWidget: Padding(
        padding: EdgeInsets.all(15.r),
        child: InkWell(
          onTap: () {
            setState(() {
              visiblePassword = !visiblePassword;
            });
          },
          overlayColor: const WidgetStatePropertyAll(AppColors.transparent),
          child: AppIcons.icon(
            size: visiblePassword ? 16 : 14,
            icon: visiblePassword ? AppIcons.unseen : AppIcons.seen,
            color: visiblePassword
                ? Theme.of(context).primaryColor
                : Theme.of(context).hintColor,
          ),
        ),
      ),
      hintText: widget.hintText,
      label: widget.label,
    );
  }
}
