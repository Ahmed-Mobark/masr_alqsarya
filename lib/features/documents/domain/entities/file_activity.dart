import 'package:equatable/equatable.dart';

class FileActivityEntity extends Equatable {
  const FileActivityEntity({
    required this.id,
    required this.action,
    required this.actor,
    this.metadata,
    required this.createdAt,
  });

  final int id;
  final String action;
  final FileActivityActorEntity actor;
  final Map<String, dynamic>? metadata;
  final String createdAt;

  @override
  List<Object?> get props => [id, action, actor, metadata, createdAt];
}

class FileActivityActorEntity extends Equatable {
  const FileActivityActorEntity({
    required this.id,
    required this.name,
    required this.email,
  });

  final int id;
  final String name;
  final String email;

  @override
  List<Object?> get props => [id, name, email];
}
