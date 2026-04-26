import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/expense/domain/entities/regular_expense.dart';
import 'package:masr_al_qsariya/features/expense/domain/usecases/get_regular_expense_details_usecase.dart';

class RegularExpenseDetailsCubit extends Cubit<RegularExpenseDetailsState> {
  final GetRegularExpenseDetailsUseCase _getDetails;
  RegularExpenseDetailsCubit(this._getDetails)
      : super(const RegularExpenseDetailsState.initial());

  Future<void> load({required int workspaceId, required int expenseId}) async {
    emit(state.copyWith(status: RegularExpenseDetailsStatus.loading));
    final result = await _getDetails(
      GetRegularExpenseDetailsParams(workspaceId: workspaceId, expenseId: expenseId),
    );
    result.fold(
      (failure) => emit(state.copyWith(status: RegularExpenseDetailsStatus.failure, failure: failure)),
      (item) => emit(state.copyWith(status: RegularExpenseDetailsStatus.success, item: item)),
    );
  }
}

enum RegularExpenseDetailsStatus { initial, loading, success, failure }

class RegularExpenseDetailsState extends Equatable {
  final RegularExpenseDetailsStatus status;
  final RegularExpenseEntity? item;
  final Failure? failure;

  const RegularExpenseDetailsState({
    required this.status,
    required this.item,
    required this.failure,
  });

  const RegularExpenseDetailsState.initial()
      : status = RegularExpenseDetailsStatus.initial,
        item = null,
        failure = null;

  RegularExpenseDetailsState copyWith({
    RegularExpenseDetailsStatus? status,
    RegularExpenseEntity? item,
    Failure? failure,
  }) {
    return RegularExpenseDetailsState(
      status: status ?? this.status,
      item: item ?? this.item,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [status, item, failure];
}

