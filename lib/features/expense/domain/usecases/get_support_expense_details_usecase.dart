import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/expense/domain/entities/support_expense.dart';
import 'package:masr_al_qsariya/features/expense/domain/repositories/support_expenses_repository.dart';

class GetSupportExpenseDetailsUseCase {
  final SupportExpensesRepository _repo;
  const GetSupportExpenseDetailsUseCase(this._repo);

  Future<Either<Failure, SupportExpenseEntity>> call(
    GetSupportExpenseDetailsParams params,
  ) =>
      _repo.getSupportExpenseDetails(
        workspaceId: params.workspaceId,
        expenseId: params.expenseId,
      );
}

class GetSupportExpenseDetailsParams extends Equatable {
  final int workspaceId;
  final int expenseId;
  const GetSupportExpenseDetailsParams({
    required this.workspaceId,
    required this.expenseId,
  });

  @override
  List<Object> get props => [workspaceId, expenseId];
}

