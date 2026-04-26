import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final int id;
  final String name;
  final String type;
  final String? description;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
  });

  @override
  List<Object?> get props => [id, name, type, description];
}

