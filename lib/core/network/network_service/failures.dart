import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final Map<String, dynamic>? errors;

  const Failure({required this.message, this.errors});

  @override
  List<Object?> get props => [message, errors];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.errors});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.errors});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}