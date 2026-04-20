import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';

class NewsFilterResult {
  const NewsFilterResult({
    this.search,
    this.type,
    this.sortDirection,
  });

  final String? search;
  final String? type;
  final String? sortDirection;
}

class NewsFilterSheet extends StatefulWidget {
  const NewsFilterSheet({
    super.key,
    this.initialSearch,
    this.initialType,
    this.initialSort,
  });

  final String? initialSearch;
  final String? initialType;
  final String? initialSort;

  static Future<NewsFilterResult?> show(
    BuildContext context, {
    String? initialSearch,
    String? initialType,
    String? initialSort,
  }) {
    return showModalBottomSheet<NewsFilterResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NewsFilterSheet(
        initialSearch: initialSearch,
        initialType: initialType,
        initialSort: initialSort,
      ),
    );
  }

  @override
  State<NewsFilterSheet> createState() => _NewsFilterSheetState();
}

class _NewsFilterSheetState extends State<NewsFilterSheet> {
  late final TextEditingController _searchController;
  String? _selectedType;
  String? _selectedSort;

  List<_FilterOption> _typeFilters(BuildContext context) => [
        _FilterOption(label: context.tr.newsAllPosts, value: null),
        _FilterOption(label: context.tr.newsUpdates, value: 'update'),
        _FilterOption(label: context.tr.newsAnnouncements, value: 'announcement'),
        _FilterOption(label: context.tr.newsPhotos, value: 'photo'),
        _FilterOption(label: context.tr.newsDocuments, value: 'document'),
        _FilterOption(label: context.tr.newsExpenseUpdates, value: 'expense_update'),
      ];

  List<_FilterOption> _sortFilters(BuildContext context) => [
        _FilterOption(label: context.tr.newsNewest, value: 'desc'),
        _FilterOption(label: context.tr.newsOldest, value: 'asc'),
        _FilterOption(label: context.tr.newsName, value: 'name'),
      ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialSearch);
    _selectedType = widget.initialType;
    _selectedSort = widget.initialSort;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedType = null;
      _selectedSort = null;
    });
  }

  void _applyFilters() {
    final search = _searchController.text.trim();
    Navigator.of(context).pop(
      NewsFilterResult(
        search: search.isEmpty ? null : search,
        type: _selectedType,
        sortDirection: _selectedSort,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final typeFilters = _typeFilters(context);
    final sortFilters = _sortFilters(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: EdgeInsets.only(bottom: bottomPadding),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.tr.newsFilter,
                  style: AppTextStyles.heading2(color: AppColors.darkText)
                      .copyWith(fontSize: 20.sp),
                ),
                GestureDetector(
                  onTap: _resetFilters,
                  child: Text(
                    context.tr.newsResetFilters,
                    style: AppTextStyles.bodyMedium(color: AppColors.primary)
                        .copyWith(fontSize: 14.sp),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // Scrollable content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search by Name
                  Text(
                    context.tr.newsSearchByName,
                    style: AppTextStyles.bodyMedium(color: AppColors.darkText)
                        .copyWith(fontSize: 15.sp),
                  ),
                  SizedBox(height: 10.h),
                  TextField(
                    controller: _searchController,
                    style: AppTextStyles.body(color: AppColors.darkText)
                        .copyWith(fontSize: 14.sp),
                    decoration: InputDecoration(
                      hintText: context.tr.newsSearchHint,
                      hintStyle: AppTextStyles.body(color: AppColors.greyText)
                          .copyWith(fontSize: 14.sp),
                      prefixIcon: Icon(Iconsax.search_normal,
                          color: AppColors.greyText, size: 20.sp),
                      filled: true,
                      fillColor: AppColors.inputBg,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 14.h),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.r),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.r),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.r),
                        borderSide:
                            BorderSide(color: AppColors.primary, width: 1.2),
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Search by Type
                  Text(
                    context.tr.newsSearchByType,
                    style: AppTextStyles.bodyMedium(color: AppColors.darkText)
                        .copyWith(fontSize: 15.sp),
                  ),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: typeFilters.map((filter) {
                      final isSelected = _selectedType == filter.value;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedType = filter.value),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.15)
                                : AppColors.background,
                            borderRadius: BorderRadius.circular(999.r),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.border,
                              width: 1.2,
                            ),
                          ),
                          child: Text(
                            filter.label,
                            style: AppTextStyles.bodyMedium(
                              color: isSelected
                                  ? AppColors.yellow
                                  : AppColors.darkText,
                            ).copyWith(fontSize: 13.sp),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 24.h),

                  // Sort by
                  Text(
                    context.tr.newsSortBy,
                    style: AppTextStyles.bodyMedium(color: AppColors.darkText)
                        .copyWith(fontSize: 15.sp),
                  ),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: sortFilters.map((filter) {
                      final isSelected = _selectedSort == filter.value;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedSort = filter.value),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.15)
                                : AppColors.background,
                            borderRadius: BorderRadius.circular(999.r),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.border,
                              width: 1.2,
                            ),
                          ),
                          child: Text(
                            filter.label,
                            style: AppTextStyles.bodyMedium(
                              color: isSelected
                                  ? AppColors.yellow
                                  : AppColors.darkText,
                            ).copyWith(fontSize: 13.sp),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),

          // Apply button
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.darkText,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  ),
                  child: Text(
                    context.tr.newsApplyFilters,
                    style: AppTextStyles.bodyMedium(color: AppColors.darkText)
                        .copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterOption {
  const _FilterOption({required this.label, required this.value});
  final String label;
  final String? value;
}
