import 'package:masr_al_qsariya/core/entities/pagination.dart';

class PaginationModel extends Pagination {
  const PaginationModel({
    required super.totalItems,
    required super.totalPages,
    required super.page,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) => PaginationModel(
    totalItems: json['totalItems'],
    totalPages: json['totalPages'],
    page: json['page'],
  );
}