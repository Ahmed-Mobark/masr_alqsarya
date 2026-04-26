import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/core/network/network_service/repository_helper.dart';
import 'package:masr_al_qsariya/features/expense/data/datasources/regular_expenses_remote_data_source.dart';
import 'package:masr_al_qsariya/features/expense/domain/entities/regular_expense.dart';
import 'package:masr_al_qsariya/features/expense/domain/repositories/regular_expenses_repository.dart';
import 'package:masr_al_qsariya/features/expense/domain/usecases/add_regular_expense_usecase.dart';

class RegularExpensesRepositoryImpl
    with RepositoryHelper
    implements RegularExpensesRepository {
  const RegularExpensesRepositoryImpl(this._remote);

  final RegularExpensesRemoteDataSource _remote;

  @override
  Future<Either<Failure, List<RegularExpenseEntity>>> getRegularExpenses({
    required int workspaceId,
  }) {
    return handleEither(() async {
      final models = await _remote.getRegularExpenses(workspaceId: workspaceId);
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, RegularExpenseEntity>> getRegularExpenseDetails({
    required int workspaceId,
    required int expenseId,
  }) {
    return handleEither(() async {
      final model = await _remote.getRegularExpenseDetails(
        workspaceId: workspaceId,
        expenseId: expenseId,
      );
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, RegularExpenseEntity>> addRegularExpense({
    required int workspaceId,
    required AddRegularExpenseParams params,
  }) {
    return handleEither(() async {
      final model = await _remote.addRegularExpense(
        workspaceId: workspaceId,
        params: params,
      );
      return model.toEntity();
    });
  }
}

