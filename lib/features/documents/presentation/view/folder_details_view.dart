import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/features/documents/presentation/model/document_models.dart';
import 'package:masr_al_qsariya/features/documents/presentation/widgets/folder_item_card.dart';
import 'package:masr_al_qsariya/features/documents/presentation/widgets/folder_filter_sheet.dart';

class FolderDetailsView extends StatefulWidget {
  final String folderTitle;
  const FolderDetailsView({super.key, required this.folderTitle});

  @override
  State<FolderDetailsView> createState() => _FolderDetailsViewState();
}

class _FolderDetailsViewState extends State<FolderDetailsView> {
  DocumentFilterTab _tab = DocumentFilterTab.all;

  List<FolderItem> get _items => const [
    FolderItem(title: 'School_d56', type: FolderItemType.video),
    FolderItem(title: 'School_d56', type: FolderItemType.video),
    FolderItem(title: 'School_d56', type: FolderItemType.document),
    FolderItem(title: 'School_d56', type: FolderItemType.video),
    FolderItem(title: 'School_d56', type: FolderItemType.document),
    FolderItem(title: 'School_d56', type: FolderItemType.photo),
  ];

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
                child:
                    Icon(Iconsax.filter, size: 18.sp, color: AppColors.yellow),
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
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 1.02,
                  ),
                  itemCount: _filtered.length,
                  itemBuilder: (context, index) {
                    return FolderItemCard(item: _filtered[index]);
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
