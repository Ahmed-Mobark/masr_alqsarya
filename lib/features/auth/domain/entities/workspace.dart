import 'package:equatable/equatable.dart';

class Workspace extends Equatable {
  const Workspace({
    this.id,
    this.name,
    this.type,
    this.data,
  });

  final int? id;
  final String? name;
  final String? type;
  final Map<String, dynamic>? data;

  @override
  List<Object?> get props => [id, name, type, data];
}
