import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masr_al_qsariya/core/config/app_icons.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/features/documents/presentation/model/document_models.dart';
import 'package:masr_al_qsariya/features/documents/presentation/view/folder_details_view.dart';
import 'package:masr_al_qsariya/features/documents/presentation/widgets/document_folder_card.dart';
import 'package:masr_al_qsariya/features/documents/presentation/widgets/folder_permissions_sheet.dart';

class DocumentsView extends StatelessWidget {
  const DocumentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final folders = <DocumentFolder>[
      DocumentFolder(
        title: context.tr.documentsFolderSchool,
        createdAt: '21/2/2026',
        addedBy: context.tr.documentsAddedByParentAMother,
        access: context.tr.documentsAccessBothParents,
        lastUpdatedBy: context.tr.documentsLastUpdatedByParentAMother,
        lastUpdatedAt: context.tr.documentsLastUpdatedAtParentAMother,
      ),
      DocumentFolder(
        title: context.tr.documentsFolderCalls,
        createdAt: '21/2/2026',
        addedBy: context.tr.documentsAddedByParentAMother,
        access: context.tr.documentsAccessBothParents,
      ),
      DocumentFolder(
        title: context.tr.documentsFolderInvoices,
        createdAt: '21/2/2026',
        addedBy: context.tr.documentsAddedByParentAMother,
        access: context.tr.documentsAccessBothParents,
      ),
      DocumentFolder(
        title: context.tr.documentsFolderLegal,
        createdAt: '21/2/2026',
        addedBy: context.tr.documentsAddedByParentAMother,
        access: context.tr.documentsAccessBothParents,
      ),
    ];

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
          padding: EdgeInsetsDirectional.only(start: 16.w, end: 16.w, top: 8.h),
          child: Column(
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
                child: ListView.separated(
                  itemCount: folders.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final folder = folders[index];
                    return DocumentFolderCard(
                      folder: folder,
                      onTap: () => sl<AppNavigator>().push(
                        screen: FolderDetailsView(folderTitle: folder.title),
                      ),
                      onMoreTap: () => showFolderPermissionsSheet(context),
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
