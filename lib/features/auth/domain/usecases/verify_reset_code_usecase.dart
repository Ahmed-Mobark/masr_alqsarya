import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/auth/domain/repositories/auth_repository.dart';

class VerifyResetCodeUseCase {
  const VerifyResetCodeUseCase(this._repo);

  final AuthRepository _repo;

  Future<Either<Failure, void>> call(VerifyResetCodeParams params) {
    return _repo.verifyResetCode(params);
  }
}

class VerifyResetCodeParams extends Equatable {
  const VerifyResetCodeParams({
    required this.email,
    required this.code,
  });

  final String email;
  final String code;

  @override
  List<Object?> get props => [email, code];
}
