import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/expense/domain/entities/support_expense.dart';
import 'package:masr_al_qsariya/features/expense/domain/usecases/get_support_expenses_usecase.dart';

class SupportExpensesCubit extends Cubit<SupportExpensesState> {
  final GetSupportExpensesUseCase _getSupportExpenses;
  SupportExpensesCubit(this._getSupportExpenses)
      : super(const SupportExpensesState.initial());

  Future<void> load({required int workspaceId}) async {
    emit(state.copyWith(status: SupportExpensesStatus.loading));
    final result = await _getSupportExpenses(
      GetSupportExpensesParams(workspaceId: workspaceId),
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(status: SupportExpensesStatus.failure, failure: failure)),
      (items) => emit(state.copyWith(status: SupportExpensesStatus.success, items: items)),
    );
  }
}

enum SupportExpensesStatus { initial, loading, success, failure }

class SupportExpensesState extends Equatable {
  final SupportExpensesStatus status;
  final List<SupportExpenseEntity> items;
  final Failure? failure;

  const SupportExpensesState({
    required this.status,
    required this.items,
    required this.failure,
  });

  const SupportExpensesState.initial()
      : status = SupportExpensesStatus.initial,
        items = const [],
        failure = null;

  SupportExpensesState copyWith({
    SupportExpensesStatus? status,
    List<SupportExpenseEntity>? items,
    Failure? failure,
  }) {
    return SupportExpensesState(
      status: status ?? this.status,
      items: items ?? this.items,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [status, items, failure];
}

