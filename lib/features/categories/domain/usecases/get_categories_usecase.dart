import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/categories/domain/entities/category.dart';
import 'package:masr_al_qsariya/features/categories/domain/repositories/categories_repository.dart';

class GetCategoriesUseCase {
  final CategoriesRepository _repo;
  const GetCategoriesUseCase(this._repo);

  Future<Either<Failure, List<CategoryEntity>>> call(GetCategoriesParams params) =>
      _repo.getCategories(type: params.type);
}

class GetCategoriesParams extends Equatable {
  final String type;
  const GetCategoriesParams({required this.type});

  @override
  List<Object> get props => [type];
}

