import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/expense/domain/entities/regular_expense.dart';
import 'package:masr_al_qsariya/features/expense/domain/repositories/regular_expenses_repository.dart';

class GetRegularExpensesUseCase {
  final RegularExpensesRepository _repo;
  const GetRegularExpensesUseCase(this._repo);

  Future<Either<Failure, List<RegularExpenseEntity>>> call(
    GetRegularExpensesParams params,
  ) =>
      _repo.getRegularExpenses(workspaceId: params.workspaceId);
}

class GetRegularExpensesParams extends Equatable {
  final int workspaceId;
  const GetRegularExpensesParams({required this.workspaceId});

  @override
  List<Object> get props => [workspaceId];
}

