import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/expense/domain/entities/support_expense.dart';
import 'package:masr_al_qsariya/features/expense/domain/repositories/support_expenses_repository.dart';

class GetSupportExpensesUseCase {
  final SupportExpensesRepository _repo;
  const GetSupportExpensesUseCase(this._repo);

  Future<Either<Failure, List<SupportExpenseEntity>>> call(
    GetSupportExpensesParams params,
  ) =>
      _repo.getSupportExpenses(workspaceId: params.workspaceId);
}

class GetSupportExpensesParams extends Equatable {
  final int workspaceId;
  const GetSupportExpensesParams({required this.workspaceId});

  @override
  List<Object> get props => [workspaceId];
}

