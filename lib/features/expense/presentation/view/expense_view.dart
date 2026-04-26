import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/data/dummy_data.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/features/expense/presentation/view/add_expense_view.dart';
import 'package:masr_al_qsariya/features/expense/presentation/view/invoice_details_view.dart';

class ExpenseView extends StatefulWidget {
  const ExpenseView({super.key});

  @override
  State<ExpenseView> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView> {
  int _selectedTab = 0;

  List<ExpenseItem> get _filteredExpenses {
    if (_selectedTab == 0) {
      return DummyData.expenses
          .where((e) => e.type == ExpenseType.regular)
          .toList();
    } else {
      return DummyData.expenses
          .where((e) => e.type == ExpenseType.support)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: const SizedBox.shrink(),
        leadingWidth: 0,
        title: Text(
          context.tr.expenseTitle,
          style: AppTextStyles.heading2().copyWith(fontSize: 18.sp),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsetsDirectional.only(end: 20.w),
            child: InkWell(
              borderRadius: BorderRadius.circular(999.r),
              onTap: () => sl<AppNavigator>().push(screen: const AddExpenseView()),
              child: Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 1.w),
                ),
                alignment: Alignment.center,
                child: Icon(Iconsax.add, size: 18.sp, color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Expanded(
                  child: _ExpenseTab(
                    label: context.tr.expenseRegularExpense,
                    isSelected: _selectedTab == 0,
                    onTap: () => setState(() => _selectedTab = 0),
                  ),
                ),
                SizedBox(width: 18.w),
                Expanded(
                  child: _ExpenseTab(
                    label: context.tr.expenseSupportPayment,
                    isSelected: _selectedTab == 1,
                    onTap: () => setState(() => _selectedTab = 1),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18.h),
          // Expense list
          Expanded(
            child: ListView.separated(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w),
              itemCount: _filteredExpenses.length,
              separatorBuilder: (_, __) => SizedBox(height: 14.h),
              itemBuilder: (context, index) {
                final expense = _filteredExpenses[index];
                return _ExpenseDetailCard(expense: expense);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ExpenseTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final labelStyle = AppTextStyles.bodyMedium(
      color: isSelected ? AppColors.yellow : AppColors.greyText,
    ).copyWith(fontSize: 13.sp, fontWeight: FontWeight.w600);

    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsetsDirectional.only(top: 6.h, bottom: 8.h),
        child: Column(
          children: [
            Text(label, style: labelStyle, textAlign: TextAlign.center),
            SizedBox(height: 10.h),
            Container(
              height: 2.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.yellow : Colors.transparent,
                borderRadius: BorderRadius.circular(999.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpenseDetailCard extends StatelessWidget {
  final ExpenseItem expense;
  const _ExpenseDetailCard({required this.expense});

  @override
  Widget build(BuildContext context) {
    final title = expense.title ??
        (expense.type == ExpenseType.support
            ? 'Monthly Child Support'
            : '${expense.category} Purchase');

    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: () => sl<AppNavigator>().push(screen: InvoiceDetailsView(expense: expense)),
      child: Container(
        padding: EdgeInsetsDirectional.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.border, width: 1.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.bodyMedium().copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkText,
                    ),
                  ),
                ),
                if (expense.type == ExpenseType.support)
                  Container(
                    padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      context.tr.expensePaidBadge,
                      style: AppTextStyles.smallMedium(
                        color: AppColors.success,
                      ).copyWith(fontSize: 10.sp, fontWeight: FontWeight.w700),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 14.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _KeyValue(
                        label: context.tr.expenseChildName,
                        value: expense.childName,
                      ),
                      SizedBox(height: 12.h),
                      _KeyValue(
                        label: expense.type == ExpenseType.support
                            ? context.tr.expenseCourtCase
                            : context.tr.addExpenseCategoryLabel,
                        value: expense.type == ExpenseType.support
                            ? (expense.courtCase ?? '-')
                            : expense.category,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 24.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _KeyValue(
                        label: context.tr.expenseSubmittedBy,
                        value: expense.submittedBy,
                      ),
                      SizedBox(height: 12.h),
                      _KeyValue(
                        label: context.tr.expenseReferenceNumber,
                        value: expense.referenceNumber,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            _KeyValue(
              label: context.tr.expensePaymentPeriod,
              value: expense.paymentPeriod,
            ),
            SizedBox(height: 16.h),
            Divider(height: 1.h, color: AppColors.border),
            SizedBox(height: 14.h),
            Row(
              children: [
                Text(
                  expense.amount.toStringAsFixed(2),
                  style: AppTextStyles.heading2().copyWith(
                    fontSize: 20.sp,
                    color: AppColors.darkText,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(width: 6.w),
                Padding(
                  padding: EdgeInsetsDirectional.only(top: 6.h),
                  child: Text(
                    'EGP',
                    style: AppTextStyles.caption(color: AppColors.captionText)
                        .copyWith(fontSize: 10.sp, fontWeight: FontWeight.w600),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {},
                  child: Text(
                    context.tr.expenseViewReceipt,
                    style: AppTextStyles.smallMedium(color: AppColors.yellow).copyWith(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.yellow,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _KeyValue extends StatelessWidget {
  final String label;
  final String value;

  const _KeyValue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption(color: AppColors.captionText)
              .copyWith(fontSize: 11.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: AppTextStyles.bodyMedium().copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.darkText,
          ),
        ),
      ],
    );
  }
}
