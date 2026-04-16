import 'package:equatable/equatable.dart';

class RegisterResponse extends Equatable {
  const RegisterResponse({required this.email, required this.message});

  final String email;
  final String message;

  @override
  List<Object?> get props => [email, message];
}
