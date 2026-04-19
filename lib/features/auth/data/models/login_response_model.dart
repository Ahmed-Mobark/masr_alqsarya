import 'package:masr_al_qsariya/features/auth/domain/entities/login_response.dart';

class LoginResponseModel {
  const LoginResponseModel({
    this.token,
    this.challengeToken,
    this.requires2FA = false,
  });

  final String? token;
  final String? challengeToken;
  final bool requires2FA;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final dataMap = data is Map<String, dynamic> ? data : <String, dynamic>{};

    final challengeToken = dataMap['challenge_token'] as String?;
    final token = dataMap['token'] as String?;

    return LoginResponseModel(
      token: token,
      challengeToken: challengeToken,
      requires2FA: challengeToken != null && token == null,
    );
  }

  LoginResponse toEntity() => LoginResponse(
        token: token,
        challengeToken: challengeToken,
        requires2FA: requires2FA,
      );
}
