import 'dart:io';

import 'package:flutter/material.dart';
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
import 'package:masr_al_qsariya/features/documents/presentation/model/document_models.dart';
import 'package:masr_al_qsariya/features/documents/presentation/view/audit_log_view.dart';
import 'package:masr_al_qsariya/features/documents/presentation/view/document_details_view.dart';
import 'package:masr_al_qsariya/features/documents/presentation/widgets/folder_item_card.dart';
import 'package:masr_al_qsariya/features/documents/presentation/widgets/folder_filter_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:masr_al_qsariya/core/toast/app_toast.dart';
import 'package:url_launcher/url_launcher.dart';

class FolderDetailsView extends StatefulWidget {
  final String folderTitle;
  final DocumentsFolderType folderType;
  final int workspaceId;
  final List<UploadedFileEntity> files;
  const FolderDetailsView({
    super.key,
    required this.folderTitle,
    required this.folderType,
    required this.workspaceId,
    required this.files,
  });

  @override
  State<FolderDetailsView> createState() => _FolderDetailsViewState();
}

class _FolderDetailsViewState extends State<FolderDetailsView> {
  DocumentFilterTab _tab = DocumentFilterTab.all;
  bool _isDownloading = false;

  List<FolderItem> get _items => widget.files
      .map(
        (file) => FolderItem(
          title: file.originalName,
          type: _folderItemTypeFromMime(file.mimeType),
          uploadedFile: file,
        ),
      )
      .toList();

  List<FolderItem> get _filtered {
    if (_tab == DocumentFilterTab.all) return _items;
    return _items.where((e) {
      return switch (_tab) {
        DocumentFilterTab.videos => e.type == FolderItemType.video,
        DocumentFilterTab.photos => e.type == FolderItemType.photo,
        DocumentFilterTab.documents => e.type == FolderItemType.document,
        DocumentFilterTab.all => true,
      };
    }).toList();
  }

  FolderItemType _folderItemTypeFromMime(String mimeType) {
    final lower = mimeType.toLowerCase();
    if (lower.startsWith('image/')) {
      return FolderItemType.photo;
    }
    if (lower.startsWith('video/')) {
      return FolderItemType.video;
    }
    return FolderItemType.document;
  }

  Future<void> _openItem(FolderItem item) async {
    // Images: show in-app preview with auth headers
    if (item.type == FolderItemType.photo) {
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => _ImagePreviewView(
            title: item.title,
            imageUrl: item.uploadedFile.url,
          ),
        ),
      );
      return;
    }

    // Videos & documents: download with auth then open locally
    if (_isDownloading) return;
    setState(() => _isDownloading = true);

    try {
      final bytes = await sl<ApiBaseHelper>().getBytes(
        url: item.uploadedFile.url,
      );
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${item.uploadedFile.originalName}');
      await file.writeAsBytes(bytes);

      final uri = Uri.file(file.path);
      final opened = await launchUrl(uri);
      if (!opened) _showOpenError();
    } catch (_) {
      _showOpenError();
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  void _showOpenError() {
    if (!mounted) return;
    appToast(
      context: context,
      type: ToastType.error,
      message: context.tr.chatAttachmentDownloadFailed,
    );
  }

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
          widget.folderTitle,
          style: AppTextStyles.heading2(
            color: AppColors.darkText,
          ).copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsetsDirectional.only(end: 16.w),
            child: InkWell(
              borderRadius: BorderRadius.circular(999.r),
              onTap: () => FolderFilterSheet.show(context),
              child: Container(
                width: 34.w,
                height: 34.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 1.w),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Iconsax.filter,
                  size: 18.sp,
                  color: AppColors.yellow,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsetsDirectional.only(start: 16.w, end: 16.w, top: 8.h),
          child: Column(
            children: [
              _FolderTabs(
                value: _tab,
                onChanged: (t) => setState(() => _tab = t),
              ),
              SizedBox(height: 14.h),
              if (_isDownloading)
                Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: const LinearProgressIndicator(color: AppColors.primary),
                ),
              Expanded(
                child: _filtered.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Iconsax.folder_open,
                                size: 64.sp,
                                color: AppColors.greyText.withValues(alpha: 0.4),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                context.tr.folderEmptyTitle,
                                style: AppTextStyles.heading2(
                                  color: AppColors.darkText,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                context.tr.folderEmptySubtitle,
                                style: AppTextStyles.caption(
                                  color: AppColors.greyText,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 1.02,
                  ),
                  itemCount: _filtered.length,
                  itemBuilder: (context, index) {
                    final item = _filtered[index];
                    return FolderItemCard(
                      item: item,
                      onTap: () => _openItem(item),
                      onInfoTap: () => sl<AppNavigator>().push(
                        screen: DocumentDetailsView(
                          file: item.uploadedFile,
                          workspaceId: widget.workspaceId,
                          folderTitle: widget.folderTitle,
                        ),
                      ),
                      onPermissionTap: () => sl<AppNavigator>().push(
                        screen: AuditLogView(
                          file: item.uploadedFile,
                          workspaceId: widget.workspaceId,
                          folderTitle: widget.folderTitle,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImagePreviewView extends StatelessWidget {
  const _ImagePreviewView({required this.title, required this.imageUrl});

  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final token = sl<Storage>().getToken();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 1,
          maxScale: 4,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
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
            errorBuilder: (_, __, ___) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Iconsax.gallery_slash, size: 48.sp, color: Colors.white54),
                  SizedBox(height: 8.h),
                  Text(
                    context.tr.chatImagePreviewFailed,
                    style: AppTextStyles.body(color: Colors.white54),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FolderTabs extends StatelessWidget {
  final DocumentFilterTab value;
  final ValueChanged<DocumentFilterTab> onChanged;

  const _FolderTabs({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Widget tab(DocumentFilterTab tab, String label) {
      final selected = value == tab;
      return InkWell(
        borderRadius: BorderRadius.circular(999.r),
        onTap: () => onChanged(tab),
        child: Container(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 16.w,
            vertical: 10.h,
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.inputBg,
            borderRadius: BorderRadius.circular(999.r),
          ),
          child: Text(
            label,
            style: AppTextStyles.bodyMedium().copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.darkText,
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          tab(DocumentFilterTab.all, context.tr.documentsTabAll),
          SizedBox(width: 10.w),
          tab(DocumentFilterTab.videos, context.tr.documentsTabVideos),
          SizedBox(width: 10.w),
          tab(DocumentFilterTab.photos, context.tr.documentsTabPhotos),
          SizedBox(width: 10.w),
          tab(DocumentFilterTab.documents, context.tr.documentsTabDocuments),
        ],
      ),
    );
  }
}
