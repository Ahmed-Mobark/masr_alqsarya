import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  const ForgotPasswordUseCase(this._repo);

  final AuthRepository _repo;

  Future<Either<Failure, void>> call(String email) {
    return _repo.forgotPassword(email);
  }
}
