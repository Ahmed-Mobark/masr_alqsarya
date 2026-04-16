import 'package:equatable/equatable.dart';

class Pagination extends Equatable {
  final int totalItems;
  final int totalPages;
  final int page;

  const Pagination({
    required this.totalItems,
    required this.totalPages,
    required this.page,
  });


  @override
  List<Object?> get props => [
    totalItems,
    totalPages,
    page,
  ];

}