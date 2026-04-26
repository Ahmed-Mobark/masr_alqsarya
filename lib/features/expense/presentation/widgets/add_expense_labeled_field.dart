import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/features/expense/presentation/widgets/add_expense_field_container.dart';

class AddExpenseLabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final FocusNode? focusNode;

  const AddExpenseLabeledField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption(color: AppColors.greyText)
              .copyWith(fontSize: 12.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10.h),
        AddExpenseFieldContainer(
          focusNode: focusNode,
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            textAlignVertical: TextAlignVertical.center,
            style: AppTextStyles.bodyMedium().copyWith(fontSize: 12.sp),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.caption(color: AppColors.captionText)
                  .copyWith(fontSize: 12.sp),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              isCollapsed: true,
              contentPadding: EdgeInsetsDirectional.zero,
            ),
          ),
        ),
      ],
    );
  }
}

