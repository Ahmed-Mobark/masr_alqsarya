import 'package:masr_al_qsariya/features/auth/domain/entities/verify_email_response.dart';

class VerifyEmailResponseModel {
  const VerifyEmailResponseModel({required this.token});

  final String token;

  factory VerifyEmailResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final dataMap = data is Map<String, dynamic> ? data : <String, dynamic>{};

    return VerifyEmailResponseModel(
      token: (dataMap['token'] as String?) ?? '',
    );
  }

  VerifyEmailResponse toEntity() => VerifyEmailResponse(token: token);
}
