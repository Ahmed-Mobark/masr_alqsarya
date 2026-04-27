import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/expense/domain/entities/support_expense.dart';
import 'package:masr_al_qsariya/features/expense/domain/usecases/add_support_expense_usecase.dart';

abstract class SupportExpensesRepository {
  Future<Either<Failure, List<SupportExpenseEntity>>> getSupportExpenses({
    required int workspaceId,
  });

  Future<Either<Failure, SupportExpenseEntity>> getSupportExpenseDetails({
    required int workspaceId,
    required int expenseId,
  });

  Future<Either<Failure, SupportExpenseEntity>> addSupportExpense({
    required int workspaceId,
    required AddSupportExpenseParams params,
  });
}

