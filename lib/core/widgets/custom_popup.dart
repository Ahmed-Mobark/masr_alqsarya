import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomPopup {
  static void appShowModalBottomSheet({required BuildContext context, required Widget Function(BuildContext) builder}) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(15.r))),
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).cardColor,
      builder: builder,
    );
  }

  static void appShowDialog({required BuildContext context, required Widget Function(BuildContext) builder}) {
    showDialog(
      context: context,
      builder: builder,
    );
  }
}
