import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/expense/domain/entities/regular_expense.dart';
import 'package:masr_al_qsariya/features/expense/domain/repositories/regular_expenses_repository.dart';

class GetRegularExpenseDetailsUseCase {
  final RegularExpensesRepository _repo;
  const GetRegularExpenseDetailsUseCase(this._repo);

  Future<Either<Failure, RegularExpenseEntity>> call(
    GetRegularExpenseDetailsParams params,
  ) =>
      _repo.getRegularExpenseDetails(
        workspaceId: params.workspaceId,
        expenseId: params.expenseId,
      );
}

class GetRegularExpenseDetailsParams extends Equatable {
  final int workspaceId;
  final int expenseId;
  const GetRegularExpenseDetailsParams({
    required this.workspaceId,
    required this.expenseId,
  });

  @override
  List<Object> get props => [workspaceId, expenseId];
}

