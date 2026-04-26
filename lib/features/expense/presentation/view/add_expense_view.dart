import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/features/expense/presentation/widgets/add_expense_category_tile.dart';
import 'package:masr_al_qsariya/features/expense/presentation/widgets/add_expense_choice_chip.dart';
import 'package:masr_al_qsariya/features/expense/presentation/widgets/add_expense_dashed_card.dart';
import 'package:masr_al_qsariya/features/expense/presentation/widgets/add_expense_field_container.dart';
import 'package:masr_al_qsariya/features/expense/presentation/widgets/add_expense_labeled_field.dart';
import 'package:masr_al_qsariya/features/expense/presentation/widgets/add_expense_required_label.dart';
import 'package:masr_al_qsariya/features/expense/presentation/widgets/add_expense_segment_option.dart';

class AddExpenseView extends StatefulWidget {
  const AddExpenseView({super.key});

  @override
  State<AddExpenseView> createState() => _AddExpenseViewState();
}

class _AddExpenseViewState extends State<AddExpenseView> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  bool _alreadyPaid = true;
  int _selectedChildIndex = 0;
  int _selectedCategoryIndex = 0;

  final _payerNameController = TextEditingController();
  final _payerIdController = TextEditingController();
  final _payeeNameController = TextEditingController();
  final _payeeIdController = TextEditingController();
  final _currencyController = TextEditingController();
  final _amountController = TextEditingController();
  final _expenseTitleController = TextEditingController();
  final _notesController = TextEditingController();
  String? _proofFileName;

  late final FocusNode _payerNameFocus;
  late final FocusNode _payerIdFocus;
  late final FocusNode _payeeNameFocus;
  late final FocusNode _payeeIdFocus;
  late final FocusNode _currencyFocus;
  late final FocusNode _amountFocus;
  late final FocusNode _expenseTitleFocus;
  late final FocusNode _notesFocus;

  static const List<String> _childKeys = ['both', 'laila', 'omar'];

  String _childLabel(BuildContext context, String key) {
    return switch (key) {
      'both' => context.tr.addExpenseChildBothChildren,
      'laila' => 'Laila',
      'omar' => 'Omar',
      _ => key,
    };
  }

  List<_CategoryTileData> _categories(BuildContext context) => [
    _CategoryTileData(
      label: context.tr.expenseCategoryEducation,
      icon: Iconsax.teacher,
    ),
    _CategoryTileData(
      label: context.tr.addExpenseCategoryMedical,
      icon: Iconsax.hospital,
    ),
    _CategoryTileData(
      label: context.tr.addExpenseCategoryGroceries,
      icon: Iconsax.shopping_cart,
    ),
    _CategoryTileData(
      label: context.tr.expenseCategoryActivities,
      icon: Iconsax.activity,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _payerNameFocus = FocusNode();
    _payerIdFocus = FocusNode();
    _payeeNameFocus = FocusNode();
    _payeeIdFocus = FocusNode();
    _currencyFocus = FocusNode();
    _amountFocus = FocusNode();
    _expenseTitleFocus = FocusNode();
    _notesFocus = FocusNode();
  }

  @override
  void dispose() {
    _payerNameFocus.dispose();
    _payerIdFocus.dispose();
    _payeeNameFocus.dispose();
    _payeeIdFocus.dispose();
    _currencyFocus.dispose();
    _amountFocus.dispose();
    _expenseTitleFocus.dispose();
    _notesFocus.dispose();
    _payerNameController.dispose();
    _payerIdController.dispose();
    _payeeNameController.dispose();
    _payeeIdController.dispose();
    _currencyController.dispose();
    _amountController.dispose();
    _expenseTitleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryDark,
              onPrimary: AppColors.darkText,
              surface: AppColors.background,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _pickProofOfPurchase() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
        withData: false,
      );

      if (!mounted) return;
      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;

      // Optional 5MB limit (matches design copy).
      final size = file.size;
      const maxBytes = 5 * 1024 * 1024;
      if (size > maxBytes) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.tr.addExpenseProofTooLarge,
              style: AppTextStyles.bodyMedium(color: AppColors.white),
            ),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      setState(() => _proofFileName = file.name);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.tr.addExpenseProofPickFailed,
            style: AppTextStyles.bodyMedium(color: AppColors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = _categories(context);
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.tr.addExpenseTitle,
          style: AppTextStyles.navTitle().copyWith(fontSize: 16.sp),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsetsDirectional.only(
          start: 20.w,
          end: 20.w,
          top: 14.h,
          bottom: 24.h,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                    AddExpenseRequiredLabel(text: context.tr.addExpenseChildLabel),
              SizedBox(height: 12.h),
              Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                children: List.generate(_childKeys.length, (index) {
                  final selected = _selectedChildIndex == index;
                        return AddExpenseChoiceChip(
                    label: _childLabel(context, _childKeys[index]),
                    selected: selected,
                    onTap: () => setState(() => _selectedChildIndex = index),
                  );
                }),
              ),
              SizedBox(height: 18.h),

              Row(
                children: [
                  Expanded(
                          child: AddExpenseLabeledField(
                      label: context.tr.addExpensePayerName,
                      controller: _payerNameController,
                      hint: context.tr.addExpenseFieldHint,
                      focusNode: _payerNameFocus,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                          child: AddExpenseLabeledField(
                      label: context.tr.addExpensePayerId,
                      controller: _payerIdController,
                      hint: context.tr.addExpenseFieldHint,
                      focusNode: _payerIdFocus,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),

              Row(
                children: [
                  Expanded(
                          child: AddExpenseLabeledField(
                      label: context.tr.addExpensePayeeName,
                      controller: _payeeNameController,
                      hint: context.tr.addExpenseFieldHint,
                      focusNode: _payeeNameFocus,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                          child: AddExpenseLabeledField(
                      label: context.tr.addExpensePayeeId,
                      controller: _payeeIdController,
                      hint: context.tr.addExpenseFieldHint,
                      focusNode: _payeeIdFocus,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

                    AddExpenseRequiredLabel(text: context.tr.addExpenseCurrencyLabel),
              SizedBox(height: 10.h),
                    AddExpenseFieldContainer(
                focusNode: _currencyFocus,
                child: TextFormField(
                  controller: _currencyController,
                  focusNode: _currencyFocus,
                  textAlignVertical: TextAlignVertical.center,
                  style: AppTextStyles.bodyMedium().copyWith(fontSize: 12.sp),
                  decoration: _inputDecoration(context.tr.addExpenseFieldHint),
                  validator: (val) => (val == null || val.isEmpty)
                      ? context.tr.addExpenseCurrencyRequired
                      : null,
                ),
              ),
              SizedBox(height: 16.h),

                    AddExpenseRequiredLabel(text: context.tr.addExpenseAmountLabel),
              SizedBox(height: 10.h),
                    AddExpenseFieldContainer(
                focusNode: _amountFocus,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _amountController,
                        focusNode: _amountFocus,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        style: AppTextStyles.bodyMedium().copyWith(
                          fontSize: 12.sp,
                        ),
                        decoration: _inputDecoration('0.00'),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return context.tr.addExpenseAmountRequired;
                          }
                          if (double.tryParse(val) == null) {
                            return context.tr.addExpenseEnterValidAmount;
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'EGP',
                      style: AppTextStyles.bodyMedium(
                        color: AppColors.yellow,
                      ).copyWith(fontSize: 12.sp, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              _buildLabel(context.tr.addExpenseExpenseTitleLabel),
              SizedBox(height: 10.h),
                    AddExpenseFieldContainer(
                focusNode: _expenseTitleFocus,
                child: TextFormField(
                  controller: _expenseTitleController,
                  focusNode: _expenseTitleFocus,
                  textAlignVertical: TextAlignVertical.center,
                  style: AppTextStyles.bodyMedium().copyWith(fontSize: 12.sp),
                  decoration: _inputDecoration(context.tr.addExpenseFieldHint),
                ),
              ),
              SizedBox(height: 22.h),

                    AddExpenseRequiredLabel(text: context.tr.addExpenseCategoryLabel),
              SizedBox(height: 12.h),
              Row(
                children: List.generate(categories.length, (index) {
                  final selected = _selectedCategoryIndex == index;
                  final tile = categories[index];
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(
                        end: index == categories.length - 1 ? 0 : 10.w,
                      ),
                            child: AddExpenseCategoryTile(
                        icon: tile.icon,
                        label: tile.label,
                        selected: selected,
                        onTap: () =>
                            setState(() => _selectedCategoryIndex = index),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 18.h),

                    AddExpenseRequiredLabel(text: context.tr.addExpenseDateLabel),
              SizedBox(height: 10.h),
              InkWell(
                borderRadius: BorderRadius.circular(16.r),
                onTap: _pickDate,
                      child: AddExpenseFieldContainer(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate != null
                              ? '${_selectedDate!.day.toString().padLeft(2, '0')} '
                                    '${_monthShort(_selectedDate!.month)} '
                                    '${_selectedDate!.year}'
                              : context.tr.addExpenseDatePlaceholder,
                          style: AppTextStyles.bodyMedium(
                            color: _selectedDate != null
                                ? AppColors.darkText
                                : AppColors.captionText,
                          ).copyWith(fontSize: 12.sp),
                        ),
                      ),
                      Icon(
                        Iconsax.calendar_1,
                        size: 18.sp,
                        color: AppColors.yellow,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 18.h),

              _buildLabel(context.tr.addExpenseNotesOptional),
              SizedBox(height: 10.h),
                    AddExpenseFieldContainer(
                focusNode: _notesFocus,
                child: TextFormField(
                  controller: _notesController,
                  focusNode: _notesFocus,
                  maxLines: 4,
                  textAlignVertical: TextAlignVertical.top,
                  style: AppTextStyles.bodyMedium().copyWith(fontSize: 12.sp),
                  decoration: _inputDecoration(context.tr.addExpenseNotesHint),
                ),
              ),
              SizedBox(height: 18.h),

                    AddExpenseRequiredLabel(
                      text: context.tr.addExpenseAlreadyPaidQuestion,
                    ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                          child: AddExpenseSegmentOption(
                      label: context.tr.addExpenseYesIPaidIt,
                      selected: _alreadyPaid,
                      onTap: () => setState(() => _alreadyPaid = true),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                          child: AddExpenseSegmentOption(
                      label: context.tr.addExpenseNotPaidYet,
                      selected: !_alreadyPaid,
                      onTap: () => setState(() => _alreadyPaid = false),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),

                    AddExpenseRequiredLabel(
                      text: context.tr.addExpenseProofOfPurchaseLabel,
                    ),
              SizedBox(height: 12.h),
              InkWell(
                borderRadius: BorderRadius.circular(18.r),
                onTap: _pickProofOfPurchase,
                      child: AddExpenseDashedCard(
                  child: Column(
                    children: [
                      Container(
                        width: 46.w,
                        height: 46.w,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.18),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Iconsax.cloud_add,
                          size: 22.sp,
                          color: AppColors.yellow,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        _proofFileName ??
                            context.tr.addExpenseUploadReceiptOrInvoice,
                        style: AppTextStyles.bodyMedium().copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        context.tr.addExpenseUploadFormats,
                        style: AppTextStyles.caption(
                          color: AppColors.captionText,
                        ).copyWith(fontSize: 10.sp),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 18.h),

              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // TODO: Save expense
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.darkText,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  ),
                  child: Text(
                    context.tr.addExpenseSubmitExpense.toUpperCase(),
                    style: AppTextStyles.button().copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.bodyMedium().copyWith(
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.darkText,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.caption(
        color: AppColors.captionText,
      ).copyWith(fontSize: 12.sp),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      isCollapsed: true,
      contentPadding: EdgeInsetsDirectional.zero,
    );
  }

  String _monthShort(int month) {
    return const [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ][month - 1];
  }
}

class _CategoryTileData {
  final String label;
  final IconData icon;

  const _CategoryTileData({required this.label, required this.icon});
}
