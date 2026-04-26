import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/categories/domain/entities/category.dart';
import 'package:masr_al_qsariya/features/categories/domain/usecases/get_categories_usecase.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final GetCategoriesUseCase _getCategories;
  CategoriesCubit(this._getCategories) : super(const CategoriesState.initial());

  Future<void> load({required String type}) async {
    emit(state.copyWith(status: CategoriesStatus.loading));
    final result = await _getCategories(GetCategoriesParams(type: type));
    result.fold(
      (failure) =>
          emit(state.copyWith(status: CategoriesStatus.failure, failure: failure)),
      (items) =>
          emit(state.copyWith(status: CategoriesStatus.success, items: items)),
    );
  }
}

enum CategoriesStatus { initial, loading, success, failure }

class CategoriesState extends Equatable {
  final CategoriesStatus status;
  final List<CategoryEntity> items;
  final Failure? failure;

  const CategoriesState({
    required this.status,
    required this.items,
    required this.failure,
  });

  const CategoriesState.initial()
      : status = CategoriesStatus.initial,
        items = const [],
        failure = null;

  CategoriesState copyWith({
    CategoriesStatus? status,
    List<CategoryEntity>? items,
    Failure? failure,
  }) {
    return CategoriesState(
      status: status ?? this.status,
      items: items ?? this.items,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [status, items, failure];
}

