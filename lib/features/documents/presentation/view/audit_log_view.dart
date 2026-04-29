import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/features/documents/domain/entities/file_activity.dart';
import 'package:masr_al_qsariya/features/documents/domain/entities/uploaded_file.dart';
import 'package:masr_al_qsariya/features/documents/presentation/cubit/file_activity_cubit.dart';
import 'package:masr_al_qsariya/core/toast/app_toast.dart';
import 'package:url_launcher/url_launcher.dart';

class AuditLogView extends StatelessWidget {
  const AuditLogView({
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
      create: (_) => sl<FileActivityCubit>()
        ..load(workspaceId: workspaceId, assetId: file.id),
      child: _AuditLogBody(
        file: file,
        folderTitle: folderTitle,
        workspaceId: workspaceId,
      ),
    );
  }
}

class _AuditLogBody extends StatelessWidget {
  const _AuditLogBody({
    required this.file,
    required this.folderTitle,
    required this.workspaceId,
  });

  final UploadedFileEntity file;
  final String folderTitle;
  final int workspaceId;

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
          context.tr.auditLogTitle,
          style: AppTextStyles.heading2(color: AppColors.darkText)
              .copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 16.h),
                  // File icon + name + folder
                  _FileHeader(file: file, folderTitle: folderTitle),
                  SizedBox(height: 24.h),
                  // Mark as Evidence toggle
                  _EvidenceToggle(
                    workspaceId: workspaceId,
                    assetId: file.id,
                  ),
                  SizedBox(height: 28.h),
                  // Activity History
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      context.tr.auditLogActivityHistory,
                      style: AppTextStyles.heading2(color: AppColors.darkText)
                          .copyWith(
                              fontSize: 16.sp, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Activity list
                  BlocBuilder<FileActivityCubit, FileActivityState>(
                    builder: (context, state) {
                      if (state.status == FileActivityStatus.loading) {
                        return Padding(
                          padding: EdgeInsets.only(top: 40.h),
                          child: const Center(
                              child: CircularProgressIndicator(
                                  color: AppColors.primary)),
                        );
                      }
                      if (state.status == FileActivityStatus.failure) {
                        return Padding(
                          padding: EdgeInsets.only(top: 40.h),
                          child: Center(
                            child: Text(
                              state.failure?.message ?? context.tr.auditLogLoadFailed,
                              style: AppTextStyles.body(
                                  color: AppColors.greyText),
                            ),
                          ),
                        );
                      }
                      if (state.activities.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.only(top: 40.h),
                          child: Center(
                            child: Text(
                              context.tr.auditLogNoActivity,
                              style: AppTextStyles.body(
                                  color: AppColors.greyText),
                            ),
                          ),
                        );
                      }
                      return _ActivityTimeline(activities: state.activities);
                    },
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
          // Download button
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
            child: SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: () async {
                  final uri = Uri.tryParse(file.url);
                  if (uri != null) {
                    await launchUrl(uri,
                        mode: LaunchMode.externalApplication);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.darkText,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: Text(
                  context.tr.auditLogDownload,
                  style: AppTextStyles.button(color: AppColors.darkText)
                      .copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FileHeader extends StatelessWidget {
  const _FileHeader({required this.file, required this.folderTitle});

  final UploadedFileEntity file;
  final String folderTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF5E0),
            borderRadius: BorderRadius.circular(14.r),
          ),
          alignment: Alignment.center,
          child: Icon(Iconsax.document, size: 28.sp, color: AppColors.error),
        ),
        SizedBox(height: 12.h),
        Text(
          file.originalName,
          style: AppTextStyles.heading2(color: AppColors.darkText)
              .copyWith(fontSize: 14.sp, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        Text(
          folderTitle,
          style: AppTextStyles.caption(color: AppColors.greyText)
              .copyWith(fontSize: 12.sp),
        ),
      ],
    );
  }
}

class _EvidenceToggle extends StatelessWidget {
  const _EvidenceToggle({
    required this.workspaceId,
    required this.assetId,
  });

  final int workspaceId;
  final int assetId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FileActivityCubit, FileActivityState>(
      listenWhen: (prev, curr) => prev.evidenceError != curr.evidenceError && curr.evidenceError != null,
      listener: (context, state) {
        appToast(
          context: context,
          type: ToastType.error,
          message: state.evidenceError!,
        );
        context.read<FileActivityCubit>().clearEvidenceError();
      },
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5E0),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                alignment: Alignment.center,
                child: Icon(Iconsax.shield_tick, size: 20.sp, color: AppColors.warning),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr.auditLogMarkAsEvidence,
                      style: AppTextStyles.bodyMedium(color: AppColors.darkText)
                          .copyWith(fontSize: 13.sp, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      context.tr.auditLogEvidenceSubtitle,
                      style: AppTextStyles.caption(color: AppColors.greyText)
                          .copyWith(fontSize: 11.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              if (state.isTogglingEvidence)
                SizedBox(
                  width: 24.w,
                  height: 24.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                )
              else
                Switch(
                  value: state.isEvidence,
                  onChanged: (v) => context.read<FileActivityCubit>().toggleEvidence(
                    workspaceId: workspaceId,
                    assetId: assetId,
                    isEvidence: v,
                  ),
                  activeThumbColor: AppColors.primary,
                  activeTrackColor: AppColors.primary.withValues(alpha: 0.4),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ActivityTimeline extends StatelessWidget {
  const _ActivityTimeline({required this.activities});

  final List<FileActivityEntity> activities;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        final isLast = index == activities.length - 1;
        return _ActivityTimelineItem(
          activity: activity,
          isLast: isLast,
        );
      },
    );
  }
}

class _ActivityTimelineItem extends StatelessWidget {
  const _ActivityTimelineItem({
    required this.activity,
    required this.isLast,
  });

  final FileActivityEntity activity;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline dot + line
          SizedBox(
            width: 40.w,
            child: Column(
              children: [
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: _iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(_icon, size: 18.sp, color: _iconColor),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2.w,
                      color: AppColors.border,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _localizedTitle(context),
                    style: AppTextStyles.bodyMedium(color: AppColors.darkText)
                        .copyWith(
                            fontSize: 13.sp, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    activity.createdAt,
                    style: AppTextStyles.caption(color: AppColors.greyText)
                        .copyWith(fontSize: 11.sp),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _localizedTitle(BuildContext context) {
    final name = activity.actor.name;
    return switch (activity.action.toLowerCase()) {
      'uploaded' => context.tr.auditLogActionUploaded(name),
      'viewed' => context.tr.auditLogActionViewed(name),
      'downloaded' => context.tr.auditLogActionDownloaded(name),
      'marked_as_evidence' => context.tr.auditLogActionMarkedAsEvidence,
      'permission_changed' => context.tr.auditLogActionPermissionChanged(name),
      _ => '${activity.action} by $name',
    };
  }

  IconData get _icon {
    return switch (activity.action.toLowerCase()) {
      'uploaded' => Iconsax.document_upload,
      'viewed' => Iconsax.eye,
      'downloaded' => Iconsax.document_download,
      'marked_as_evidence' => Iconsax.star,
      'permission_changed' => Iconsax.lock_1,
      _ => Iconsax.activity,
    };
  }

  Color get _iconColor {
    return switch (activity.action.toLowerCase()) {
      'uploaded' => AppColors.error,
      'viewed' => AppColors.blue,
      'downloaded' => AppColors.darkText,
      'marked_as_evidence' => AppColors.warning,
      'permission_changed' => AppColors.error,
      _ => AppColors.greyText,
    };
  }

  Color get _iconBgColor {
    return switch (activity.action.toLowerCase()) {
      'uploaded' => AppColors.error.withValues(alpha: 0.1),
      'viewed' => AppColors.blue.withValues(alpha: 0.1),
      'downloaded' => AppColors.inputBg,
      'marked_as_evidence' => AppColors.warning.withValues(alpha: 0.1),
      'permission_changed' => AppColors.error.withValues(alpha: 0.1),
      _ => AppColors.inputBg,
    };
  }
}
