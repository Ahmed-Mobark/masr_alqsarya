import 'package:dio/dio.dart';

class AppException implements Exception {
  final String message;
  final Response? response;
  AppException(this.message, {this.response});

  @override
  String toString() => message;
}

class ServerException extends AppException {
  ServerException({required String message, Response? response}) : super(message, response: response);
}

class FetchDataException extends AppException {
  FetchDataException(super.message);
}

class BadRequestException extends AppException {
  BadRequestException(super.message);
}

class UnauthorizedException extends AppException {
  UnauthorizedException(super.message);
}

class NotFoundException extends AppException {
  NotFoundException(super.message);
}

class ConflictException extends AppException {
  ConflictException(super.message);
}

class ValidationException extends AppException {
  final Map<String, dynamic>? validationErrors;
  ValidationException(super.message, {this.validationErrors});
}

class CacheException extends AppException {
  CacheException(super.message);
}

class NetworkException extends AppException {
  NetworkException(super.message);
}