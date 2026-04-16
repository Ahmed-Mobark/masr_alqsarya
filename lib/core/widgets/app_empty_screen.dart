import 'package:masr_al_qsariya/core/config/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';

class AppEmptyScreen extends StatelessWidget {
  final String? title;
  final String? description;
  final String? icon;
  const AppEmptyScreen({super.key, this.title, this.description, this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 25.h),
          Text(
            title ?? context.tr.sorryMessage,
            style: TextStyles.textViewRegular22,
          ),
          Text(
            description ?? context.tr.nothingFound,
            style: TextStyles.textViewLight14.copyWith(
              color: Theme.of(context).hintColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 50.h),
        ],
      ),
    );
  }
}
