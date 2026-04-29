import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/toast/app_toast.dart';
import 'package:masr_al_qsariya/features/documents/presentation/cubit/uploaded_file_permissions_cubit.dart';

Future<void> showFolderPermissionsSheet(
  BuildContext context, {
  required int workspaceId,
  required List<int> assetIds,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return BlocProvider(
        create: (_) => sl<UploadedFilePermissionsCubit>(),
        child: _FolderPermissionsSheet(
          workspaceId: workspaceId,
          assetIds: assetIds,
        ),
      );
    },
  );
}

class _FolderPermissionsSheet extends StatefulWidget {
  final int workspaceId;
  final List<int> assetIds;

  const _FolderPermissionsSheet({
    required this.workspaceId,
    required this.assetIds,
  });

  @override
  State<_FolderPermissionsSheet> createState() =>
      _FolderPermissionsSheetState();
}

class _FolderPermissionsSheetState extends State<_FolderPermissionsSheet> {
  int viewIndex = 0;
  int editIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      UploadedFilePermissionsCubit,
      UploadedFilePermissionsState
    >(
      listener: (context, state) {
        if (state.status == UploadedFilePermissionsStatus.success) {
          final msg = state.successMessage;
          if (msg != null && msg.isNotEmpty) {
            appToast(context: context, type: ToastType.success, message: msg);
          }
          Navigator.of(context).pop();
        } else if (state.status == UploadedFilePermissionsStatus.failure) {
          final msg = state.failure?.message;
          if (msg != null && msg.isNotEmpty) {
            appToast(context: context, type: ToastType.error, message: msg);
          }
        }
      },
      child: SafeArea(
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
                style: AppTextStyles.heading2(
                  color: AppColors.darkText,
                ).copyWith(fontSize: 15.sp, fontWeight: FontWeight.w700),
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
                style: AppTextStyles.heading2(
                  color: AppColors.darkText,
                ).copyWith(fontSize: 15.sp, fontWeight: FontWeight.w700),
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
              SizedBox(height: 20.h),
              BlocBuilder<
                UploadedFilePermissionsCubit,
                UploadedFilePermissionsState
              >(
                builder: (context, state) {
                  final isLoading =
                      state.status == UploadedFilePermissionsStatus.loading;

                  return Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isLoading
                              ? null
                              : () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            side: BorderSide(
                              color: AppColors.border,
                              width: 1.w,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999.r),
                            ),
                          ),
                          child: Text(
                            context.tr.commonCancel,
                            style:
                                AppTextStyles.bodyMedium(
                                  color: AppColors.darkText,
                                ).copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  context
                                      .read<UploadedFilePermissionsCubit>()
                                      .update(
                                        workspaceId: widget.workspaceId,
                                        assetIds: widget.assetIds,
                                        viewIndex: viewIndex,
                                        editIndex: editIndex,
                                      );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.darkText,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999.r),
                            ),
                          ),
                          child: isLoading
                              ? SizedBox(
                                  width: 18.w,
                                  height: 18.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  context.tr.commonSave,
                                  style:
                                      AppTextStyles.bodyMedium(
                                        color: AppColors.darkText,
                                      ).copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
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
                style: AppTextStyles.bodyMedium(
                  color: AppColors.darkText,
                ).copyWith(fontSize: 13.sp, fontWeight: FontWeight.w500),
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
