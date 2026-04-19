import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/auth/domain/entities/login_response.dart';
import 'package:masr_al_qsariya/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._repo);

  final AuthRepository _repo;

  Future<Either<Failure, LoginResponse>> call(LoginParams params) {
    return _repo.login(params);
  }
}

class LoginParams extends Equatable {
  const LoginParams({
    required this.email,
    required this.password,
    this.deviceName,
  });

  final String email;
  final String password;
  final String? deviceName;

  @override
  List<Object?> get props => [email, password, deviceName];
}
