import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';

Future<void> showFolderPermissionsSheet(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return const _FolderPermissionsSheet();
    },
  );
}

class _FolderPermissionsSheet extends StatefulWidget {
  const _FolderPermissionsSheet();

  @override
  State<_FolderPermissionsSheet> createState() => _FolderPermissionsSheetState();
}

class _FolderPermissionsSheetState extends State<_FolderPermissionsSheet> {
  int viewIndex = 0;
  int editIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsetsDirectional.only(
          start: 18.w,
          end: 18.w,
          top: 14.h,
          bottom: 22.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 46.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              context.tr.documentsWhoCanView,
              style: AppTextStyles.heading2(color: AppColors.darkText)
                  .copyWith(fontSize: 15.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 10.h),
            _RadioOption(
              label: context.tr.documentsBothParents,
              selected: viewIndex == 0,
              onTap: () => setState(() => viewIndex = 0),
            ),
            _Divider(),
            _RadioOption(
              label: context.tr.documentsCustom,
              selected: viewIndex == 1,
              onTap: () => setState(() => viewIndex = 1),
            ),
            _Divider(),
            _RadioOption(
              label: context.tr.documentsNoOne,
              selected: viewIndex == 2,
              onTap: () => setState(() => viewIndex = 2),
            ),
            SizedBox(height: 16.h),
            Text(
              context.tr.documentsWhoCanEdit,
              style: AppTextStyles.heading2(color: AppColors.darkText)
                  .copyWith(fontSize: 15.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 10.h),
            _RadioOption(
              label: context.tr.documentsBothParents,
              selected: editIndex == 0,
              onTap: () => setState(() => editIndex = 0),
            ),
            _Divider(),
            _RadioOption(
              label: context.tr.documentsCustom,
              selected: editIndex == 1,
              onTap: () => setState(() => editIndex = 1),
            ),
            _Divider(),
            _RadioOption(
              label: context.tr.documentsNoOne,
              selected: editIndex == 2,
              onTap: () => setState(() => editIndex = 2),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadioOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RadioOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(vertical: 10.h),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium(color: AppColors.darkText)
                    .copyWith(fontSize: 13.sp, fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              width: 18.w,
              height: 18.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border, width: 1.w),
              ),
              padding: EdgeInsetsDirectional.all(3.w),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 120),
                opacity: selected ? 1 : 0,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.yellow,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(height: 1.h, color: AppColors.border);
  }
}

