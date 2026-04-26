import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/expense/domain/entities/regular_expense.dart';
import 'package:masr_al_qsariya/features/expense/domain/usecases/add_regular_expense_usecase.dart';

abstract class RegularExpensesRepository {
  Future<Either<Failure, List<RegularExpenseEntity>>> getRegularExpenses({
    required int workspaceId,
  });

  Future<Either<Failure, RegularExpenseEntity>> getRegularExpenseDetails({
    required int workspaceId,
    required int expenseId,
  });

  Future<Either<Failure, RegularExpenseEntity>> addRegularExpense({
    required int workspaceId,
    required AddRegularExpenseParams params,
  });
}

