import 'package:equatable/equatable.dart';

class LoginResponse extends Equatable {
  const LoginResponse({
    required this.token,
    this.challengeToken,
    this.requires2FA = false,
  });

  final String? token;
  final String? challengeToken;
  final bool requires2FA;

  @override
  List<Object?> get props => [token, challengeToken, requires2FA];
}
