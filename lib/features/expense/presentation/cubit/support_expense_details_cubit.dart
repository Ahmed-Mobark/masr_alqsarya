import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/expense/domain/entities/support_expense.dart';
import 'package:masr_al_qsariya/features/expense/domain/usecases/get_support_expense_details_usecase.dart';

class SupportExpenseDetailsCubit extends Cubit<SupportExpenseDetailsState> {
  final GetSupportExpenseDetailsUseCase _getDetails;
  SupportExpenseDetailsCubit(this._getDetails)
      : super(const SupportExpenseDetailsState.initial());

  Future<void> load({required int workspaceId, required int expenseId}) async {
    emit(state.copyWith(status: SupportExpenseDetailsStatus.loading));
    final result = await _getDetails(
      GetSupportExpenseDetailsParams(workspaceId: workspaceId, expenseId: expenseId),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: SupportExpenseDetailsStatus.failure, failure: failure),
      ),
      (item) => emit(
        state.copyWith(status: SupportExpenseDetailsStatus.success, item: item),
      ),
    );
  }
}

enum SupportExpenseDetailsStatus { initial, loading, success, failure }

class SupportExpenseDetailsState extends Equatable {
  final SupportExpenseDetailsStatus status;
  final SupportExpenseEntity? item;
  final Failure? failure;

  const SupportExpenseDetailsState({
    required this.status,
    required this.item,
    required this.failure,
  });

  const SupportExpenseDetailsState.initial()
      : status = SupportExpenseDetailsStatus.initial,
        item = null,
        failure = null;

  SupportExpenseDetailsState copyWith({
    SupportExpenseDetailsStatus? status,
    SupportExpenseEntity? item,
    Failure? failure,
  }) {
    return SupportExpenseDetailsState(
      status: status ?? this.status,
      item: item ?? this.item,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [status, item, failure];
}

