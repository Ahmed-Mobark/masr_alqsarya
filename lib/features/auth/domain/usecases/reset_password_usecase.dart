import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  const ResetPasswordUseCase(this._repo);

  final AuthRepository _repo;

  Future<Either<Failure, void>> call(ResetPasswordParams params) {
    return _repo.resetPassword(params);
  }
}

class ResetPasswordParams extends Equatable {
  const ResetPasswordParams({
    required this.email,
    required this.code,
    required this.password,
    required this.passwordConfirmation,
  });

  final String email;
  final String code;
  final String password;
  final String passwordConfirmation;

  @override
  List<Object?> get props => [email, code, password, passwordConfirmation];
}
