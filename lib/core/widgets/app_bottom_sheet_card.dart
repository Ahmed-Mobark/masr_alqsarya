import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBottomSheetCard extends StatelessWidget {
  final List<Widget> children;
  const AppBottomSheetCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: EdgeInsets.only(right: 30.w, left: 30.w, top: 30.h, bottom: MediaQuery.viewInsetsOf(context).bottom + 30.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      ),
    );
  }
}