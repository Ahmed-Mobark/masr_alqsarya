import 'package:dio/dio.dart';
import 'package:masr_al_qsariya/core/network/network_service/exceptions.dart';

class ErrorHelper {
  /// Extracts user-facing message from API error response.
  /// Supports: { "error": { "message": "..." } } and { "message": "..." }.
  static String _extractMessage(dynamic data) {
    if (data is! Map<String, dynamic>) return 'Unknown server error';

    // Check for field-level errors first (e.g. { "errors": { "email": ["..."] } })
    final errors = data['errors'];
    if (errors is Map<String, dynamic> && errors.isNotEmpty) {
      final firstValue = errors.values.first;
      if (firstValue is List && firstValue.isNotEmpty) {
        return firstValue.first.toString();
      }
      if (firstValue is String && firstValue.isNotEmpty) {
        return firstValue;
      }
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
