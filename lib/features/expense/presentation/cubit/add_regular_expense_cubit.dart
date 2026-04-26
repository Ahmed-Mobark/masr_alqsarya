import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/expense/domain/entities/regular_expense.dart';
import 'package:masr_al_qsariya/features/expense/domain/usecases/add_regular_expense_usecase.dart';

class AddRegularExpenseCubit extends Cubit<AddRegularExpenseState> {
  final AddRegularExpenseUseCase _addExpense;
  AddRegularExpenseCubit(this._addExpense)
      : super(const AddRegularExpenseState.initial());

  Future<void> submit({
    required int workspaceId,
    required AddRegularExpenseParams params,
  }) async {
    emit(state.copyWith(status: AddRegularExpenseStatus.loading));
    final result = await _addExpense(AddRegularExpenseRequest(workspaceId: workspaceId, params: params));
    result.fold(
      (failure) => emit(state.copyWith(status: AddRegularExpenseStatus.failure, failure: failure)),
      (item) => emit(state.copyWith(status: AddRegularExpenseStatus.success, item: item)),
    );
  }
}

enum AddRegularExpenseStatus { initial, loading, success, failure }

class AddRegularExpenseState extends Equatable {
  final AddRegularExpenseStatus status;
  final RegularExpenseEntity? item;
  final Failure? failure;

  const AddRegularExpenseState({
    required this.status,
    required this.item,
    required this.failure,
  });

  const AddRegularExpenseState.initial()
      : status = AddRegularExpenseStatus.initial,
        item = null,
        failure = null;

  AddRegularExpenseState copyWith({
    AddRegularExpenseStatus? status,
    RegularExpenseEntity? item,
    Failure? failure,
  }) {
    return AddRegularExpenseState(
      status: status ?? this.status,
      item: item ?? this.item,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [status, item, failure];
}

