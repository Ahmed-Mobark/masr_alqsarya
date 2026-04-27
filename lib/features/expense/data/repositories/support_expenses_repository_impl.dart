import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/core/network/network_service/repository_helper.dart';
import 'package:masr_al_qsariya/features/expense/data/datasources/support_expenses_remote_data_source.dart';
import 'package:masr_al_qsariya/features/expense/domain/entities/support_expense.dart';
import 'package:masr_al_qsariya/features/expense/domain/repositories/support_expenses_repository.dart';
import 'package:masr_al_qsariya/features/expense/domain/usecases/add_support_expense_usecase.dart';

class SupportExpensesRepositoryImpl
    with RepositoryHelper
    implements SupportExpensesRepository {
  const SupportExpensesRepositoryImpl(this._remote);
  final SupportExpensesRemoteDataSource _remote;

  @override
  Future<Either<Failure, List<SupportExpenseEntity>>> getSupportExpenses({
    required int workspaceId,
  }) {
    return handleEither(() async {
      final models = await _remote.getSupportExpenses(workspaceId: workspaceId);
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, SupportExpenseEntity>> getSupportExpenseDetails({
    required int workspaceId,
    required int expenseId,
  }) {
    return handleEither(() async {
      final model = await _remote.getSupportExpenseDetails(
        workspaceId: workspaceId,
        expenseId: expenseId,
      );
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, SupportExpenseEntity>> addSupportExpense({
    required int workspaceId,
    required AddSupportExpenseParams params,
  }) {
    return handleEither(() async {
      final model = await _remote.addSupportExpense(
        workspaceId: workspaceId,
        params: params,
      );
      return model.toEntity();
    });
  }
}

