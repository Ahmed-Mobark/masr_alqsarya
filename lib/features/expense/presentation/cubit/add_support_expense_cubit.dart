import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/expense/domain/entities/support_expense.dart';
import 'package:masr_al_qsariya/features/expense/domain/usecases/add_support_expense_usecase.dart';

class AddSupportExpenseCubit extends Cubit<AddSupportExpenseState> {
  final AddSupportExpenseUseCase _addExpense;
  AddSupportExpenseCubit(this._addExpense)
      : super(const AddSupportExpenseState.initial());

  Future<void> submit({
    required int workspaceId,
    required AddSupportExpenseParams params,
  }) async {
    emit(state.copyWith(status: AddSupportExpenseStatus.loading));
    final result = await _addExpense(
      AddSupportExpenseRequest(workspaceId: workspaceId, params: params),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: AddSupportExpenseStatus.failure, failure: failure),
      ),
      (item) =>
          emit(state.copyWith(status: AddSupportExpenseStatus.success, item: item)),
    );
  }
}

enum AddSupportExpenseStatus { initial, loading, success, failure }

class AddSupportExpenseState extends Equatable {
  final AddSupportExpenseStatus status;
  final SupportExpenseEntity? item;
  final Failure? failure;

  const AddSupportExpenseState({
    required this.status,
    required this.item,
    required this.failure,
  });

  const AddSupportExpenseState.initial()
      : status = AddSupportExpenseStatus.initial,
        item = null,
        failure = null;

  AddSupportExpenseState copyWith({
    AddSupportExpenseStatus? status,
    SupportExpenseEntity? item,
    Failure? failure,
  }) {
    return AddSupportExpenseState(
      status: status ?? this.status,
      item: item ?? this.item,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [status, item, failure];
}

