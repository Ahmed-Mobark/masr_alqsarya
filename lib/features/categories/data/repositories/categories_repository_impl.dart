import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/core/network/network_service/repository_helper.dart';
import 'package:masr_al_qsariya/features/categories/data/datasources/categories_remote_data_source.dart';
import 'package:masr_al_qsariya/features/categories/domain/entities/category.dart';
import 'package:masr_al_qsariya/features/categories/domain/repositories/categories_repository.dart';

class CategoriesRepositoryImpl with RepositoryHelper implements CategoriesRepository {
  const CategoriesRepositoryImpl(this._remote);
  final CategoriesRemoteDataSource _remote;

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories({
    required String type,
  }) {
    return handleEither(() async {
      final models = await _remote.getCategories(type: type);
      return models.map((m) => m.toEntity()).toList();
    });
  }
}

