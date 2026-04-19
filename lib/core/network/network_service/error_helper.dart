import 'package:dio/dio.dart';
import 'package:masr_al_qsariya/core/network/network_service/exceptions.dart';

class ErrorHelper {
  /// Extracts user-facing message from API error response.
  /// Supports: { "error": { "message": "..." } } and { "message": "..." }.
  static String _extractMessage(dynamic data) {
    if (data is! Map<String, dynamic>) return 'Unknown server error';

    // Collect all field-level errors (e.g. { "errors": { "email": ["..."], "password": ["..."] } })
    final errors = data['errors'];
    if (errors is Map<String, dynamic> && errors.isNotEmpty) {
      final allMessages = <String>[];
      for (final value in errors.values) {
        if (value is List) {
          allMessages.addAll(value.map((e) => e.toString()));
        } else if (value is String && value.isNotEmpty) {
          allMessages.add(value);
        }
      }
      if (allMessages.isNotEmpty) return allMessages.join('\n');
    }

    final error = data['error'];
    if (error is Map<String, dynamic>) {
      final msg = error['message'];
      if (msg is String && msg.isNotEmpty) return msg;
    }
    final topLevel = data['message'];
    if (topLevel is String && topLevel.isNotEmpty) return topLevel;
    return 'Unknown server error';
  }

  static AppException handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
        return NetworkException('No internet connection');
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return NetworkException('Connection timed out');
      case DioExceptionType.badResponse:
        final data = e.response?.data;
        final String message = _extractMessage(data);
        return ValidationException(message);
      default:
        return ServerException(
          message: 'Unexpected error occurred',
          response: e.response,
        );
    }
  }
}
