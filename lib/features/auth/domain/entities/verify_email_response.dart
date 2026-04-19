import 'package:equatable/equatable.dart';

class VerifyEmailResponse extends Equatable {
  const VerifyEmailResponse({required this.token});

  final String token;

  @override
  List<Object?> get props => [token];
}
