import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';

class FolderFilterResult {
  const FolderFilterResult({
    this.search,
    this.type,
    this.sort,
    this.evidenceOnly,
    this.addedBy,
    this.startDate,
    this.endDate,
  });

  final String? search;
  final String? type;
  final String? sort;
  final bool? evidenceOnly;
  final Set<String>? addedBy;
  final DateTime? startDate;
  final DateTime? endDate;
}

class FolderFilterSheet extends StatefulWidget {
  const FolderFilterSheet({
    super.key,
    this.initial,
  });

  final FolderFilterResult? initial;

  static Future<FolderFilterResult?> show(BuildContext context, {FolderFilterResult? initial}) {
    return showModalBottomSheet<FolderFilterResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FolderFilterSheet(initial: initial),
    );
  }

  @override
  State<FolderFilterSheet> createState() => _FolderFilterSheetState();
}

class _FolderFilterSheetState extends State<FolderFilterSheet> {
  late final TextEditingController _searchController;
  String? _selectedType;
  String? _selectedSort;
  bool _evidenceOnly = false;
  final Set<String> _addedBy = {'parentA'};
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initial?.search ?? '');
    _selectedType = widget.initial?.type;
    _selectedSort = widget.initial?.sort ?? 'newest';
    _evidenceOnly = widget.initial?.evidenceOnly ?? false;
    _addedBy
      ..clear()
      ..addAll(widget.initial?.addedBy ?? {'parentA'});
    _startDate = widget.initial?.startDate;
    _endDate = widget.initial?.endDate;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _reset() {
    setState(() {
      _searchController.clear();
      _selectedType = null;
      _selectedSort = 'newest';
      _evidenceOnly = false;
      _addedBy
        ..clear()
        ..add('parentA');
      _startDate = null;
      _endDate = null;
    });
  }

  void _apply() {
    final search = _searchController.text.trim();
    Navigator.of(context).pop(
      FolderFilterResult(
        search: search.isEmpty ? null : search,
        type: _selectedType,
        sort: _selectedSort,
        evidenceOnly: _evidenceOnly ? true : null,
        addedBy: _addedBy.isEmpty ? null : {..._addedBy},
        startDate: _startDate,
        endDate: _endDate,
      ),
    );
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.darkText,
              surface: AppColors.background,
              onSurface: AppColors.darkText,
            ),
            dialogBackgroundColor: AppColors.background,
            datePickerTheme: DatePickerThemeData(
              backgroundColor: AppColors.background,
              headerBackgroundColor: AppColors.background,
              headerForegroundColor: AppColors.darkText,
              dayForegroundColor: WidgetStateProperty.all(AppColors.darkText),
              todayForegroundColor: WidgetStateProperty.all(AppColors.yellow),
              todayBorder: const BorderSide(color: AppColors.primary, width: 1),
              yearForegroundColor: WidgetStateProperty.all(AppColors.darkText),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.r),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.yellow,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.darkText,
              surface: AppColors.background,
              onSurface: AppColors.darkText,
            ),
            dialogBackgroundColor: AppColors.background,
            datePickerTheme: DatePickerThemeData(
              backgroundColor: AppColors.background,
              headerBackgroundColor: AppColors.background,
              headerForegroundColor: AppColors.darkText,
              dayForegroundColor: WidgetStateProperty.all(AppColors.darkText),
              todayForegroundColor: WidgetStateProperty.all(AppColors.yellow),
              todayBorder: const BorderSide(color: AppColors.primary, width: 1),
              yearForegroundColor: WidgetStateProperty.all(AppColors.darkText),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.r),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.yellow,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _endDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.92,
      ),
      padding: EdgeInsets.only(bottom: bottomPadding),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
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
                  onTap: _reset,
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
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(context.tr.newsSearchByName),
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
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18.r),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18.r),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18.r),
                        borderSide: BorderSide(color: AppColors.primary, width: 1.2),
                      ),
                    ),
                  ),
                  SizedBox(height: 22.h),
                  _SectionTitle(context.tr.newsSearchByType),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: [
                      _Chip(
                        label: context.tr.documentsTypePdf,
                        selected: _selectedType == 'pdf',
                        onTap: () => setState(() => _selectedType = 'pdf'),
                      ),
                      _Chip(
                        label: context.tr.documentsTypeCourtDocument,
                        selected: _selectedType == 'court',
                        onTap: () => setState(() => _selectedType = 'court'),
                      ),
                      _Chip(
                        label: context.tr.documentsTypeInvoice,
                        selected: _selectedType == 'invoice',
                        onTap: () => setState(() => _selectedType = 'invoice'),
                      ),
                      _Chip(
                        label: context.tr.documentsTypeImage,
                        selected: _selectedType == 'image',
                        onTap: () => setState(() => _selectedType = 'image'),
                      ),
                    ],
                  ),
                  SizedBox(height: 22.h),
                  _SectionTitle(context.tr.newsSortBy),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: [
                      _Chip(
                        label: context.tr.newsNewest,
                        selected: _selectedSort == 'newest',
                        onTap: () => setState(() => _selectedSort = 'newest'),
                      ),
                      _Chip(
                        label: context.tr.newsOldest,
                        selected: _selectedSort == 'oldest',
                        onTap: () => setState(() => _selectedSort = 'oldest'),
                      ),
                      _Chip(
                        label: context.tr.newsName,
                        selected: _selectedSort == 'name',
                        onTap: () => setState(() => _selectedSort = 'name'),
                      ),
                    ],
                  ),
                  SizedBox(height: 22.h),
                  _SectionTitle(context.tr.documentsEvidenceStatus),
                  SizedBox(height: 12.h),
                  _RadioLine(
                    label: context.tr.documentsAllRecords,
                    selected: !_evidenceOnly,
                    onTap: () => setState(() => _evidenceOnly = false),
                  ),
                  SizedBox(height: 10.h),
                  _RadioLine(
                    label: context.tr.documentsMarkedAsEvidence,
                    selected: _evidenceOnly,
                    onTap: () => setState(() => _evidenceOnly = true),
                  ),
                  SizedBox(height: 22.h),
                  _SectionTitle(context.tr.documentsAddedBy),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: _CheckLine(
                          label: context.tr.documentsAddedByParentA,
                          checked: _addedBy.contains('parentA'),
                          onTap: () => setState(() => _toggleAddedBy('parentA')),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _CheckLine(
                          label: context.tr.documentsAddedByParentB,
                          checked: _addedBy.contains('parentB'),
                          onTap: () => setState(() => _toggleAddedBy('parentB')),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: _CheckLine(
                          label: context.tr.documentsAddedByLawyer,
                          checked: _addedBy.contains('lawyer'),
                          onTap: () => setState(() => _toggleAddedBy('lawyer')),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _CheckLine(
                          label: context.tr.documentsAddedByMediator,
                          checked: _addedBy.contains('mediator'),
                          onTap: () => setState(() => _toggleAddedBy('mediator')),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 22.h),
                  _SectionTitle(context.tr.documentsDateRange),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: _DateField(
                          label: context.tr.documentsStartDate,
                          onTap: _pickStartDate,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text('-', style: AppTextStyles.bodyMedium(color: AppColors.greyText)),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _DateField(
                          label: context.tr.documentsEndDate,
                          onTap: _pickEndDate,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 26.h),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: _apply,
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
                    style: AppTextStyles.bodyMedium(color: AppColors.darkText).copyWith(
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

  void _toggleAddedBy(String key) {
    if (_addedBy.contains(key)) {
      _addedBy.remove(key);
    } else {
      _addedBy.add(key);
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.bodyMedium(color: AppColors.darkText).copyWith(fontSize: 15.sp),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Chip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.background,
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyMedium(
            color: selected ? AppColors.yellow : AppColors.darkText,
          ).copyWith(fontSize: 13.sp),
        ),
      ),
    );
  }
}

class _RadioLine extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _RadioLine({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 18.w,
            height: 18.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: selected ? AppColors.primary : AppColors.border, width: 1.2),
            ),
            padding: EdgeInsetsDirectional.all(3.w),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 120),
              opacity: selected ? 1 : 0,
              child: const DecoratedBox(
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.yellow),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyMedium(color: AppColors.greyText).copyWith(fontSize: 13.sp),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckLine extends StatelessWidget {
  final String label;
  final bool checked;
  final VoidCallback onTap;
  const _CheckLine({required this.label, required this.checked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 18.w,
            height: 18.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: checked ? AppColors.primary : AppColors.border, width: 1.2),
              color: checked ? AppColors.primary : Colors.transparent,
            ),
            alignment: Alignment.center,
            child: Icon(Icons.check, size: 12.sp, color: checked ? AppColors.darkText : Colors.transparent),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyMedium(color: AppColors.greyText).copyWith(fontSize: 13.sp),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _DateField({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        height: 48.h,
        padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColors.inputBg,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium(color: AppColors.captionText).copyWith(fontSize: 12.sp),
              ),
            ),
            Icon(Iconsax.calendar_1, size: 18.sp, color: AppColors.yellow),
          ],
        ),
      ),
    );
  }
}

