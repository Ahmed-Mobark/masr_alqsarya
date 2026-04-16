import 'package:masr_al_qsariya/core/theme/calendar_theme.dart';
import 'package:masr_al_qsariya/core/utils/validator.dart';
import 'package:masr_al_qsariya/core/widgets/app_text_form_field.dart';
import 'package:flutter/material.dart';

class DateFormfield extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;

  const DateFormfield({
    required this.controller,
    this.hintText,
    this.labelText,
    super.key,
  });

  DateTime? initialDate(String? date) {
    if (date == null || date.isEmpty) return DateTime.now();
    return DateTime.parse(date);
  }

  void onTapDate({required BuildContext context}) {
    showDatePicker(
      context: context,
      initialDate: initialDate(controller.text),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 100)),
      builder: (context, child) =>
          Theme(data: CalendarTheme.getCalendarTheme(context), child: child!),
    ).then((value) {
      if (value != null) {
        controller.text = value.toString().split(' ').first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      readOnly: true,
      onTap: () {
        onTapDate(context: context);
      },
      controller: controller,
      hintText: hintText,
      label: labelText,
      validator: (value) => Validator.defaultValidator(value),
    );
  }
}
