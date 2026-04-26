import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/expense/domain/entities/regular_expense.dart';
import 'package:masr_al_qsariya/features/expense/domain/repositories/regular_expenses_repository.dart';

class AddRegularExpenseUseCase {
  final RegularExpensesRepository _repo;
  const AddRegularExpenseUseCase(this._repo);

  Future<Either<Failure, RegularExpenseEntity>> call(
    AddRegularExpenseRequest request,
  ) =>
      _repo.addRegularExpense(workspaceId: request.workspaceId, params: request.params);
}

class AddRegularExpenseRequest extends Equatable {
  final int workspaceId;
  final AddRegularExpenseParams params;
  const AddRegularExpenseRequest({required this.workspaceId, required this.params});

  @override
  List<Object> get props => [workspaceId, params];
}

class AddRegularExpenseParams extends Equatable {
  final int childWorkspaceMemberId;
  final String payerId;
  final String payerName;
  final String payeeId;
  final String payeeName;
  final String currency;
  final String amount; // backend expects string in form-data
  final String title;
  final int categoryId;
  final String date; // e.g. 4/26/2026
  final String? note;
  final bool isPaid;
  final MultipartFile? attachment;

  const AddRegularExpenseParams({
    required this.childWorkspaceMemberId,
    required this.payerId,
    required this.payerName,
    required this.payeeId,
    required this.payeeName,
    required this.currency,
    required this.amount,
    required this.title,
    required this.categoryId,
    required this.date,
    required this.note,
    required this.isPaid,
    required this.attachment,
  });

  @override
  List<Object?> get props => [
        childWorkspaceMemberId,
        payerId,
        payerName,
        payeeId,
        payeeName,
        currency,
        amount,
        title,
        categoryId,
        date,
        note,
        isPaid,
        attachment,
      ];
}

