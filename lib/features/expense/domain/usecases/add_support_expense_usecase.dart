import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/expense/domain/entities/support_expense.dart';
import 'package:masr_al_qsariya/features/expense/domain/repositories/support_expenses_repository.dart';

class AddSupportExpenseUseCase {
  final SupportExpensesRepository _repo;
  const AddSupportExpenseUseCase(this._repo);

  Future<Either<Failure, SupportExpenseEntity>> call(
    AddSupportExpenseRequest request,
  ) =>
      _repo.addSupportExpense(
        workspaceId: request.workspaceId,
        params: request.params,
      );
}

class AddSupportExpenseRequest extends Equatable {
  final int workspaceId;
  final AddSupportExpenseParams params;
  const AddSupportExpenseRequest({
    required this.workspaceId,
    required this.params,
  });

  @override
  List<Object> get props => [workspaceId, params];
}

class AddSupportExpenseParams extends Equatable {
  final String payerId;
  final String payerName;
  final String payeeId;
  final String payeeName;
  final String currency;
  final String amount; // backend expects string in form-data
  final String title;
  final int? categoryId;
  final String date; // e.g. 2026-04-27
  final String? note;
  final bool isPaid;
  final MultipartFile? attachment;

  const AddSupportExpenseParams({
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

