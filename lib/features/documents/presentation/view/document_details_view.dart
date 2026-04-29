import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/features/documents/domain/entities/uploaded_file.dart';
import 'package:masr_al_qsariya/features/documents/domain/entities/uploaded_file_detail.dart';
import 'package:masr_al_qsariya/features/documents/presentation/cubit/document_detail_cubit.dart';
import 'package:masr_al_qsariya/features/documents/presentation/view/audit_log_view.dart';
import 'package:masr_al_qsariya/features/documents/presentation/widgets/folder_permissions_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:masr_al_qsariya/core/toast/app_toast.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentDetailsView extends StatelessWidget {
  const DocumentDetailsView({
    super.key,
    required this.file,
    required this.workspaceId,
    required this.folderTitle,
  });

  final UploadedFileEntity file;
  final int workspaceId;
  final String folderTitle;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<DocumentDetailCubit>()
            ..load(workspaceId: workspaceId, assetId: file.id),
      child: _DocumentDetailsBody(
        file: file,
        workspaceId: workspaceId,
        folderTitle: folderTitle,
      ),
    );
  }
}

class _DocumentDetailsBody extends StatelessWidget {
  const _DocumentDetailsBody({
    required this.file,
    required this.workspaceId,
    required this.folderTitle,
  });

  final UploadedFileEntity file;
  final int workspaceId;
  final String folderTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18.sp,
            color: AppColors.darkText,
          ),
          onPressed: () => sl<AppNavigator>().pop(),
        ),
        title: Text(
          context.tr.documentDetailsTitle,
          style: AppTextStyles.heading2(
            color: AppColors.darkText,
          ).copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<DocumentDetailCubit, DocumentDetailState>(
        builder: (context, state) {
          if (state.status == DocumentDetailStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state.status == DocumentDetailStatus.failure) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.failure?.message ??
                          context.tr.chatAttachmentDownloadFailed,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body(color: AppColors.greyText),
                    ),
                    SizedBox(height: 16.h),
                    TextButton(
                      onPressed: () => context.read<DocumentDetailCubit>().load(
                        workspaceId: workspaceId,
                        assetId: file.id,
                      ),
                      child: Text(context.tr.messagesRetry),
                    ),
                  ],
                ),
              ),
            );
          }

          final detail = state.detail;
          if (detail == null) return const SizedBox.shrink();

          return _DetailContent(
            detail: detail,
            file: file,
            workspaceId: workspaceId,
            folderTitle: folderTitle,
          );
        },
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({
    required this.detail,
    required this.file,
    required this.workspaceId,
    required this.folderTitle,
  });

  final UploadedFileDetailEntity detail;
  final UploadedFileEntity file;
  final int workspaceId;
  final String folderTitle;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          // File Summary section
          Text(
            context.tr.documentDetailsFileSummary,
            style: AppTextStyles.heading2(
              color: AppColors.darkText,
            ).copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 12.h),
          // Added By & Date Added chips
          Row(
            children: [
              _SummaryChip(
                label: context.tr.documentDetailsAddedBy,
                value: detail.uploadedBy.name,
                icon: Iconsax.user,
                iconColor: AppColors.error,
              ),
              SizedBox(width: 12.w),
              _SummaryChip(
                label: context.tr.documentDetailsDateAdded,
                value: detail.uploadedDateHumanReadable,
                icon: Iconsax.calendar_1,
                iconColor: AppColors.warning,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Visibility + Evidence row
          Row(
            children: [
              Expanded(
                child: _InfoChip(
                  icon: Iconsax.eye,
                  iconColor: AppColors.success,
                  label: context.tr.documentDetailsVisibility,
                  value: context.tr.documentDetailsVisibilityCount(
                    detail.visibility.canViewCount,
                    detail.visibility.workspaceMembersCount,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              _InfoChip(
                icon: Iconsax.shield_tick,
                iconColor: detail.isEvidence
                    ? AppColors.warning
                    : AppColors.greyText,
                label: detail.isEvidence
                    ? context.tr.documentDetailsEvidence
                    : context.tr.documentDetailsNotEvidence,
              ),
            ],
          ),
          // Visibility members list
          if (detail.visibility.members.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 6.h,
              children: detail.visibility.members.map((m) {
                return Chip(
                  avatar: Icon(Iconsax.user, size: 14.sp),
                  label: Text(
                    '${m.name} (${m.role})',
                    style: AppTextStyles.caption(
                      color: AppColors.darkText,
                    ).copyWith(fontSize: 11.sp),
                  ),
                  backgroundColor: AppColors.inputBg,
                  side: BorderSide.none,
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              }).toList(),
            ),
          ],
          SizedBox(height: 24.h),
          // Info section
          Text(
            context.tr.documentDetailsInfo,
            style: AppTextStyles.heading2(
              color: AppColors.darkText,
            ).copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8.h),
          Text(
            '${context.tr.documentDetailsFileLabel(detail.originalName)}\n'
            '${context.tr.documentDetailsTypeLabel(detail.mimeType)}\n'
            '${context.tr.documentDetailsSizeLabel(_formatSize(detail.size))}',
            style: AppTextStyles.body(
              color: AppColors.greyText,
            ).copyWith(fontSize: 13.sp, height: 1.6),
          ),
          SizedBox(height: 20.h),
          // File preview
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: _FilePreview(detail: detail),
          ),
          SizedBox(height: 28.h),
          // Document Actions
          Text(
            context.tr.documentDetailsActions,
            style: AppTextStyles.heading2(
              color: AppColors.darkText,
            ).copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Iconsax.document_download,
                  label: context.tr.documentDetailsDownload,
                  onTap: () => _download(context),
                ),
              ),
              if (detail.permissions.canUpdate) ...[
                SizedBox(width: 12.w),
                Expanded(
                  child: _ActionButton(
                    icon: Iconsax.lock_1,
                    label: context.tr.documentDetailsUpdatePermissions,
                    onTap: () => showFolderPermissionsSheet(
                      context,
                      workspaceId: workspaceId,
                      assetIds: [detail.id],
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Iconsax.clock,
                  label: context.tr.documentDetailsActivityLog,
                  onTap: () => sl<AppNavigator>().push(
                    screen: AuditLogView(
                      file: file,
                      workspaceId: workspaceId,
                      folderTitle: folderTitle,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _ActionButton(
                  icon: Iconsax.archive,
                  label: context.tr.documentDetailsArchive,
                  onTap: () {},
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  Future<void> _download(BuildContext context) async {
    try {
      final bytes = await sl<ApiBaseHelper>().getBytes(url: detail.url);
      final dir = await getTemporaryDirectory();
      final localFile = File('${dir.path}/${detail.originalName}');
      await localFile.writeAsBytes(bytes);
      await launchUrl(Uri.file(localFile.path));
    } catch (_) {
      if (context.mounted) {
        appToast(
          context: context,
          type: ToastType.error,
          message: context.tr.chatAttachmentDownloadFailed,
        );
      }
    }
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16.sp, color: iconColor),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.caption(
                      color: iconColor,
                    ).copyWith(fontSize: 10.sp, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    value,
                    style: AppTextStyles.bodyMedium(
                      color: AppColors.darkText,
                    ).copyWith(fontSize: 11.sp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.iconColor,
    required this.label,
    this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: iconColor),
          SizedBox(width: 8.w),
          if (value != null)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.caption(
                      color: AppColors.error,
                    ).copyWith(fontSize: 10.sp, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    value!,
                    style: AppTextStyles.bodyMedium(
                      color: AppColors.darkText,
                    ).copyWith(fontSize: 12.sp),
                  ),
                ],
              ),
            )
          else
            Text(
              label,
              style: AppTextStyles.bodyMedium(
                color: iconColor,
              ).copyWith(fontSize: 12.sp),
            ),
        ],
      ),
    );
  }
}

class _FilePreview extends StatelessWidget {
  const _FilePreview({required this.detail});

  final UploadedFileDetailEntity detail;

  @override
  Widget build(BuildContext context) {
    final mime = detail.mimeType.toLowerCase();
    if (mime.startsWith('image/')) {
      final token = sl<Storage>().getToken();
      return SizedBox(
        height: 200.h,
        width: double.infinity,
        child: Image.network(
          detail.url,
          fit: BoxFit.cover,
          headers: {
            if (token != null && token.isNotEmpty)
              'Authorization': 'Bearer $token',
            'Accept': '*/*',
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          },
          errorBuilder: (_, __, ___) => Container(
            height: 200.h,
            width: double.infinity,
            color: AppColors.inputBg,
            alignment: Alignment.center,
            child: Icon(
              Iconsax.gallery_slash,
              size: 48.sp,
              color: AppColors.greyText,
            ),
          ),
        ),
      );
    }

    final (IconData icon, Color color) = mime.startsWith('video/')
        ? (Iconsax.video_play, AppColors.captionText)
        : (Iconsax.document, AppColors.error);

    return Container(
      height: 200.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(16.r),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48.sp, color: color),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              detail.originalName,
              style: AppTextStyles.caption(color: AppColors.greyText),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Column(
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5E0),
                borderRadius: BorderRadius.circular(12.r),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 20.sp, color: AppColors.warning),
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: AppTextStyles.bodyMedium(
                color: AppColors.darkText,
              ).copyWith(fontSize: 12.sp, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
