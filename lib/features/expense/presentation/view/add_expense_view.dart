import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';

class AddExpenseView extends StatefulWidget {
  const AddExpenseView({super.key});

  @override
  State<AddExpenseView> createState() => _AddExpenseViewState();
}

class _AddExpenseViewState extends State<AddExpenseView> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  DateTime? _selectedDate;
  bool _alreadyPaid = false;
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCurrency = 'USD';

  static const List<String> _categoryKeys = [
    'Education',
    'Healthcare',
    'Activities',
    'Essentials',
    'Clothing',
    'Food',
    'Transportation',
    'Other',
  ];

  String _categoryLabel(BuildContext context, String key) {
    return switch (key) {
      'Education' => context.tr.expenseCategoryEducation,
      'Healthcare' => context.tr.expenseCategoryHealthcare,
      'Activities' => context.tr.expenseCategoryActivities,
      'Essentials' => context.tr.expenseCategoryEssentials,
      'Clothing' => context.tr.expenseCategoryClothing,
      'Food' => context.tr.expenseCategoryFood,
      'Transportation' => context.tr.expenseCategoryTransportation,
      'Other' => context.tr.expenseCategoryOther,
      _ => key,
    };
  }

  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'MAD', 'SAR', 'AED'];

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(context.tr.addExpenseTitle, style: AppTextStyles.navTitle()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category dropdown
              _buildLabel(context.tr.addExpenseCategoryLabel),
              const SizedBox(height: 8),
              _buildCategoryDropdown(context),
              const SizedBox(height: 20),

              // Date picker
              _buildLabel(context.tr.addExpenseDateLabel),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate != null
                              ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
                              : context.tr.addExpenseSelectDateHint,
                          style: _selectedDate != null
                              ? AppTextStyles.bodyMedium()
                              : AppTextStyles.caption(),
                        ),
                      ),
                      const Icon(Iconsax.calendar, size: 20, color: AppColors.greyText),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Amount
              _buildLabel(context.tr.addExpenseAmountLabel),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: AppTextStyles.bodyMedium(),
                decoration: _inputDecoration(context.tr.addExpenseEnterAmountHint),
                validator: (val) {
                  if (val == null || val.isEmpty) return context.tr.addExpenseAmountRequired;
                  if (double.tryParse(val) == null) return context.tr.addExpenseEnterValidAmount;
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Currency
              _buildLabel(context.tr.addExpenseCurrencyLabel),
              const SizedBox(height: 8),
              _buildDropdown<String>(
                value: _selectedCurrency,
                hint: context.tr.addExpenseSelectCurrencyHint,
                items: _currencies,
                onChanged: (val) => setState(() => _selectedCurrency = val ?? 'USD'),
              ),
              const SizedBox(height: 20),

              // Description
              _buildLabel(context.tr.addExpenseDescriptionLabel),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                style: AppTextStyles.bodyMedium(),
                decoration: _inputDecoration(context.tr.addExpenseEnterDescriptionHint),
              ),
              const SizedBox(height: 20),

              // Proof of purchase
              _buildLabel(context.tr.addExpenseProofOfPurchaseLabel),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  // TODO: Implement file upload
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border, style: BorderStyle.solid),
                  ),
                  child: Column(
                    children: [
                      const Icon(Iconsax.document_upload, size: 32, color: AppColors.greyText),
                      const SizedBox(height: 8),
                      Text(context.tr.addExpenseTapToUpload, style: AppTextStyles.caption()),
                      const SizedBox(height: 4),
                      Text(context.tr.addExpenseUploadFormats, style: AppTextStyles.tiny(color: AppColors.greyText)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Already paid checkbox
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _alreadyPaid,
                      onChanged: (val) => setState(() => _alreadyPaid = val ?? false),
                      activeColor: AppColors.primaryDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      context.tr.addExpenseAlreadyPaidQuestion,
                      style: AppTextStyles.bodyMedium(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 44,
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
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(context.tr.commonSave, style: AppTextStyles.button()),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: AppTextStyles.button());
  }

  Widget _buildDropdown<T>({
    required T? value,
    required String hint,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonFormField<T>(
        initialValue: value,
        hint: Text(hint, style: AppTextStyles.caption()),
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text('$item', style: AppTextStyles.bodyMedium()),
                ))
            .toList(),
        onChanged: onChanged,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        icon: const Icon(Iconsax.arrow_down_1, size: 18, color: AppColors.greyText),
      ),
    );
  }

  Widget _buildCategoryDropdown(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        hint: Text(context.tr.addExpenseSelectCategoryHint, style: AppTextStyles.caption()),
        items: _categoryKeys
            .map((key) => DropdownMenuItem(
                  value: key,
                  child: Text(_categoryLabel(context, key), style: AppTextStyles.bodyMedium()),
                ))
            .toList(),
        onChanged: (val) => setState(() => _selectedCategory = val),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        icon: const Icon(Iconsax.arrow_down_1, size: 18, color: AppColors.greyText),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.caption(),
      filled: true,
      fillColor: AppColors.background,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryDark),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    );
  }
}
