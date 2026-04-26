import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/expense/domain/entities/regular_expense.dart';
import 'package:masr_al_qsariya/features/expense/domain/usecases/get_regular_expenses_usecase.dart';

class RegularExpensesCubit extends Cubit<RegularExpensesState> {
  final GetRegularExpensesUseCase _getRegularExpenses;
  RegularExpensesCubit(this._getRegularExpenses)
      : super(const RegularExpensesState.initial());

  Future<void> load({required int workspaceId}) async {
    emit(state.copyWith(status: RegularExpensesStatus.loading));
    final result = await _getRegularExpenses(GetRegularExpensesParams(workspaceId: workspaceId));
    result.fold(
      (failure) => emit(state.copyWith(status: RegularExpensesStatus.failure, failure: failure)),
      (items) => emit(state.copyWith(status: RegularExpensesStatus.success, items: items)),
    );
  }
}

enum RegularExpensesStatus { initial, loading, success, failure }

class RegularExpensesState extends Equatable {
  final RegularExpensesStatus status;
  final List<RegularExpenseEntity> items;
  final Failure? failure;

  const RegularExpensesState({
    required this.status,
    required this.items,
    required this.failure,
  });

  const RegularExpensesState.initial()
      : status = RegularExpensesStatus.initial,
        items = const [],
        failure = null;

  RegularExpensesState copyWith({
    RegularExpensesStatus? status,
    List<RegularExpenseEntity>? items,
    Failure? failure,
  }) {
    return RegularExpensesState(
      status: status ?? this.status,
      items: items ?? this.items,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [status, items, failure];
}

