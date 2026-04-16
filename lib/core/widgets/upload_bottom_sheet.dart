import 'dart:io';
import 'package:masr_al_qsariya/core/config/app_icons.dart';
import 'package:masr_al_qsariya/core/enums/media_type.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/services/media_service/media_services.dart';
import 'package:masr_al_qsariya/core/widgets/bottom_sheet_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';

class UploadBottomSheet extends StatelessWidget {
  final Function(File file) onchange;
  const UploadBottomSheet({required this.onchange, super.key});

  static final MediaService _mediaService = sl<MediaService>();

  Future<void> _getImage(
    BuildContext context,
    AppImageSource appImageSource,
  ) async {
    final pickedImageFile = await _mediaService.uploadImage(
      context,
      appImageSource,
    );
    if (pickedImageFile != null) {
      onchange(pickedImageFile);
    }
  }

  Future<void> _getMultipleFile(BuildContext context) async {
    final selectedFiles = await _mediaService.uploadFiles(context);
    if (selectedFiles != null && selectedFiles.isNotEmpty) {
      onchange(selectedFiles.whereType<File>().first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 25.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 3.5.h,
            margin: EdgeInsets.only(bottom: 15.h),
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor,
              borderRadius: BorderRadius.circular(50.r),
            ),
          ),
          BottomSheetCard(
            onTap: () {
              sl<AppNavigator>().pop();
              _getImage(context, AppImageSource.gallery);
            },
            icon: AppIcons.gallery,
            text: context.tr.chooseImage,
          ),

          BottomSheetCard(
            onTap: () {
              sl<AppNavigator>().pop();
              _getImage(context, AppImageSource.camera);
            },
            icon: AppIcons.camera,
            text: context.tr.takePicture,
          ),

          BottomSheetCard(
            onTap: () {
              sl<AppNavigator>().pop();
              _getMultipleFile(context);
            },
            icon: AppIcons.file,
            text: context.tr.chooseFromFiles,
          ),
        ],
      ),
    );
  }
}
