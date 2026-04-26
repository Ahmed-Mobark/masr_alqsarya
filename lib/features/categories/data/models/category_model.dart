import 'package:masr_al_qsariya/features/categories/domain/entities/category.dart';

class CategoryModel {
  final int id;
  final String name;
  final String type;
  final String? description;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      description: json['description']?.toString(),
    );
  }

  CategoryEntity toEntity() => CategoryEntity(
        id: id,
        name: name,
        type: type,
        description: description,
      );
}

