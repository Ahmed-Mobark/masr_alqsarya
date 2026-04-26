import 'package:masr_al_qsariya/core/config/app_end_points.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/features/categories/data/models/category_model.dart';

abstract class CategoriesRemoteDataSource {
  Future<List<CategoryModel>> getCategories({required String type});
}

class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  const CategoriesRemoteDataSourceImpl(this._api);
  final ApiBaseHelper _api;

  @override
  Future<List<CategoryModel>> getCategories({required String type}) async {
    final response = await _api.get<Map<String, dynamic>>(
      url: AppEndpoints.categories,
      queryParameters: {'type': type},
    );

    // Backend example: { data: { data: [ ... ] } }
    final data = response['data'];
    if (data is Map<String, dynamic>) {
      final inner = data['data'];
      if (inner is List) {
        return inner
            .whereType<Map<String, dynamic>>()
            .map(CategoryModel.fromJson)
            .toList();
      }
    }

    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(CategoryModel.fromJson)
          .toList();
    }

    return const [];
  }
}

