import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masr_al_qsariya/core/config/app_icons.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/features/documents/domain/entities/uploaded_file.dart';
import 'package:masr_al_qsariya/features/documents/presentation/cubit/documents_cubit.dart';
import 'package:masr_al_qsariya/features/documents/presentation/model/document_models.dart';
import 'package:masr_al_qsariya/features/documents/presentation/view/folder_details_view.dart';
import 'package:masr_al_qsariya/features/documents/presentation/widgets/document_folder_card.dart';
import 'package:masr_al_qsariya/features/documents/presentation/widgets/folder_permissions_sheet.dart';

class DocumentsView extends StatelessWidget {
  const DocumentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DocumentsCubit>()..load(),
      child: Scaffold(
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
            context.tr.documentsTitle,
            style: AppTextStyles.heading2(
              color: AppColors.darkText,
            ).copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.only(end: 16.w),
              child: SvgPicture.asset(AppIcons.documentsIcon),
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              start: 16.w,
              end: 16.w,
              top: 8.h,
            ),
            child: BlocBuilder<DocumentsCubit, DocumentsState>(
              builder: (context, state) {
                final folders = _buildFolders(context, state.filesByType);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr.documentsFolders,
                      style: AppTextStyles.heading2(
                        color: AppColors.darkText,
                      ).copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 12.h),
                    Expanded(
                      child: switch (state.status) {
                        DocumentsStatus.initial || DocumentsStatus.loading =>
                          const Center(child: CircularProgressIndicator()),
                        DocumentsStatus.failure ||
                        DocumentsStatus.workspaceMissing => Center(
                          child: Text(
                            state.failure?.message ??
                                context.tr.messagesLoadError,
                            style: AppTextStyles.body(
                              color: AppColors.greyText,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DocumentsStatus.success => ListView.separated(
                          itemCount: folders.length,
                          separatorBuilder: (_, __) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            final folder = folders[index];
                            final files =
                                state.filesByType[folder.type] ??
                                const <UploadedFileEntity>[];
                            return DocumentFolderCard(
                              folder: folder,
                              onTap: () => sl<AppNavigator>().push(
                                screen: FolderDetailsView(
                                  folderTitle: folder.title,
                                  folderType: folder.type,
                                  files: files,
                                  workspaceId: state.workspaceId ?? 0,
                                ),
                              ),
                              onMoreTap: () => showFolderPermissionsSheet(
                                context,
                                workspaceId: state.workspaceId ?? 0,
                                assetIds: files.map((e) => e.id).toList(),
                              ),
                            );
                          },
                        ),
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  List<DocumentFolder> _buildFolders(
    BuildContext context,
    Map<DocumentsFolderType, List<UploadedFileEntity>> filesByType,
  ) {
    return [
      _folderForType(
        context: context,
        type: DocumentsFolderType.chats,
        title: context.tr.messagesTitle,
        files: filesByType[DocumentsFolderType.chats] ?? const [],
      ),
      _folderForType(
        context: context,
        type: DocumentsFolderType.calls,
        title: context.tr.documentsFolderCalls,
        files: filesByType[DocumentsFolderType.calls] ?? const [],
      ),
      _folderForType(
        context: context,
        type: DocumentsFolderType.invoices,
        title: context.tr.documentsFolderInvoices,
        files: filesByType[DocumentsFolderType.invoices] ?? const [],
      ),
    ];
  }

  DocumentFolder _folderForType({
    required BuildContext context,
    required DocumentsFolderType type,
    required String title,
    required List<UploadedFileEntity> files,
  }) {
    return DocumentFolder(
      type: type,
      title: title,
      createdAt: files.isNotEmpty ? files.first.createdAt : '-',
      addedBy: context.tr.documentsAddedByParentAMother,
      access: context.tr.documentsAccessBothParents,
      filesCount: files.length,
      lastUpdatedBy: files.isNotEmpty
          ? context.tr.documentsLastUpdatedByParentAMother
          : null,
      lastUpdatedAt: files.isNotEmpty ? files.first.createdAt : null,
    );
  }
}
