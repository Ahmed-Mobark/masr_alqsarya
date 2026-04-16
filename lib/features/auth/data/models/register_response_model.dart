import 'package:masr_al_qsariya/features/auth/domain/entities/register_response.dart';

class RegisterResponseModel {
  const RegisterResponseModel({
    required this.email,
    required this.message,
    required this.success,
  });

  final bool success;
  final String message;
  final String email;

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final dataMap = data is Map<String, dynamic> ? data : <String, dynamic>{};
    return RegisterResponseModel(
      success: (json['success'] as bool?) ?? false,
      message: (json['message'] as String?) ?? '',
      email: (dataMap['email'] as String?) ?? '',
    );
  }

  RegisterResponse toEntity() =>
      RegisterResponse(email: email, message: message);
}
