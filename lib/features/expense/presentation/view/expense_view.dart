import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/data/dummy_data.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/features/expense/presentation/view/add_expense_view.dart';

class ExpenseView extends StatelessWidget {
  const ExpenseView({super.key});

  double get _totalExpenses =>
      DummyData.expenses.fold(0.0, (sum, e) => sum + e.amount);

  double get _parentAPaid => DummyData.expenses
      .where((e) => e.paidBy == 'Parent A')
      .fold(0.0, (sum, e) => sum + e.amount);

  double get _parentBPaid => DummyData.expenses
      .where((e) => e.paidBy == 'Parent B')
      .fold(0.0, (sum, e) => sum + e.amount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: Text('Expense', style: AppTextStyles.navTitle()),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Summary Card
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Total This Month',
                    style: AppTextStyles.caption(
                        color: AppColors.darkText),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${_totalExpenses.toStringAsFixed(2)}',
                    style: AppTextStyles.heading1().copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'You Paid',
                              style: AppTextStyles.tiny(
                                  color: AppColors.darkText),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${_parentAPaid.toStringAsFixed(2)}',
                              style: AppTextStyles.heading2(),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 36,
                        color:
                            AppColors.darkText.withValues(alpha: 0.2),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Co-parent Paid',
                              style: AppTextStyles.tiny(
                                  color: AppColors.darkText),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${_parentBPaid.toStringAsFixed(2)}',
                              style: AppTextStyles.heading2(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Expense list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: DummyData.expenses.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final expense = DummyData.expenses[index];
                return _ExpenseItemCard(expense: expense);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          sl<AppNavigator>().push(screen: const AddExpenseView());
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Iconsax.add, color: AppColors.darkText),
        label: Text('Add Expense', style: AppTextStyles.button()),
      ),
    );
  }
}

class _ExpenseItemCard extends StatelessWidget {
  final ExpenseItem expense;
  const _ExpenseItemCard({required this.expense});

  Color get _iconBgColor {
    switch (expense.category) {
      case 'Education':
        return const Color(0xFFE3F2FD);
      case 'Healthcare':
        return const Color(0xFFE8F5E9);
      case 'Activities':
        return const Color(0xFFFFF3E0);
      case 'Essentials':
        return const Color(0xFFFCE4EC);
      default:
        return AppColors.inputBg;
    }
  }

  Color get _iconColor {
    switch (expense.category) {
      case 'Education':
        return const Color(0xFF1976D2);
      case 'Healthcare':
        return AppColors.success;
      case 'Activities':
        return const Color(0xFFE65100);
      case 'Essentials':
        return const Color(0xFFC62828);
      default:
        return AppColors.greyText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon circle
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _iconBgColor,
              shape: BoxShape.circle,
            ),
            child:
                Icon(expense.icon, size: 20, color: _iconColor),
          ),
          const SizedBox(width: 12),

          // Title + category + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(expense.title,
                    style: AppTextStyles.button()),
                const SizedBox(height: 3),
                Text(expense.category,
                    style: AppTextStyles.caption()),
                const SizedBox(height: 2),
                Text(expense.date,
                    style: AppTextStyles.small()),
              ],
            ),
          ),

          // Amount
          Text(
            '\$${expense.amount.toStringAsFixed(2)}',
            style: AppTextStyles.button(),
          ),
        ],
      ),
    );
  }
}
