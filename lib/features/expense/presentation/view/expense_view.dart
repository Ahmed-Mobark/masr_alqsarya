import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/data/dummy_data.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/features/expense/presentation/view/add_expense_view.dart';

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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => sl<AppNavigator>().pop(),
        ),
        title: Text(context.tr.expenseTitle, style: AppTextStyles.heading2()),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.add, size: 24),
            onPressed: () {
              sl<AppNavigator>().push(screen: const AddExpenseView());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 0),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _selectedTab == 0
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Text(
                          context.tr.expenseRegularExpense,
                          style: AppTextStyles.bodyMedium(
                            color: _selectedTab == 0
                                ? AppColors.darkText
                                : AppColors.greyText,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 1),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _selectedTab == 1
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Text(
                          context.tr.expenseSupportPayment,
                          style: AppTextStyles.bodyMedium(
                            color: _selectedTab == 1
                                ? AppColors.darkText
                                : AppColors.greyText,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Expense list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filteredExpenses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
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

class _ExpenseDetailCard extends StatelessWidget {
  final ExpenseItem expense;
  const _ExpenseDetailCard({required this.expense});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Child Name row
          _buildInfoRow(
            context.tr.expenseChildName,
            expense.childName,
          ),
          const SizedBox(height: 12),
          // Submitted By row
          _buildInfoRow(
            context.tr.expenseSubmittedBy,
            expense.submittedBy,
          ),
          const SizedBox(height: 12),
          // Category or Court Case row
          if (expense.type == ExpenseType.support && expense.courtCase != null)
            _buildInfoRow(
              context.tr.expenseCourtCase,
              expense.courtCase!,
            )
          else
            _buildInfoRow(
              context.tr.addExpenseCategoryLabel,
              expense.category,
            ),
          const SizedBox(height: 12),
          // Reference Number row
          _buildInfoRow(
            context.tr.expenseReferenceNumber,
            expense.referenceNumber,
          ),
          const SizedBox(height: 12),
          // Payment Period row
          _buildInfoRow(
            context.tr.expensePaymentPeriod,
            expense.paymentPeriod,
          ),
          const SizedBox(height: 16),
          // Divider
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 14),
          // Amount + VIEW RECEIPT
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${expense.amount.toStringAsFixed(0)} EGP',
                style: AppTextStyles.heading2().copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  context.tr.expenseViewReceipt,
                  style: AppTextStyles.smallMedium(
                    color: AppColors.primaryDark,
                  ).copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.caption(color: AppColors.greyText),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium(),
        ),
      ],
    );
  }
}
