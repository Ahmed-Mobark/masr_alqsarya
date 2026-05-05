import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/auth/domain/repositories/auth_repository.dart';

class ChangePasswordUseCase {
  const ChangePasswordUseCase(this._repo);

  final AuthRepository _repo;

  Future<Either<Failure, void>> call(ChangePasswordParams params) {
    return _repo.changePassword(params);
  }
}

class ChangePasswordParams extends Equatable {
  const ChangePasswordParams({
    required this.currentPassword,
    required this.password,
    required this.passwordConfirmation,
  });

  final String currentPassword;
  final String password;
  final String passwordConfirmation;

  @override
  List<Object?> get props => [currentPassword, password, passwordConfirmation];
}
