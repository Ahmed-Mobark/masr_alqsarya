import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/auth/domain/entities/register_response.dart';
import 'package:masr_al_qsariya/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  const RegisterUseCase(this._repo);

  final AuthRepository _repo;

  Future<Either<Failure, RegisterResponse>> call(RegisterParams params) {
    return _repo.register(params);
  }
}

class RegisterParams extends Equatable {
  const RegisterParams({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.type,
    required this.password,
    required this.passwordConfirmation,
    this.dateOfBirth,
    this.deviceName,
  });

  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String type;
  final String password;
  final String passwordConfirmation;
  final String? dateOfBirth;
  final String? deviceName;

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    phone,
    email,
    type,
    password,
    passwordConfirmation,
    dateOfBirth,
    deviceName,
  ];
}
