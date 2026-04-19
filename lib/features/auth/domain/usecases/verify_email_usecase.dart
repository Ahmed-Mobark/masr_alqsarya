import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/auth/domain/entities/verify_email_response.dart';
import 'package:masr_al_qsariya/features/auth/domain/repositories/auth_repository.dart';

class VerifyEmailUseCase {
  const VerifyEmailUseCase(this._repo);

  final AuthRepository _repo;

  Future<Either<Failure, VerifyEmailResponse>> call(VerifyEmailParams params) {
    return _repo.verifyEmail(params);
  }
}

class VerifyEmailParams extends Equatable {
  const VerifyEmailParams({
    required this.email,
    required this.code,
    this.deviceName,
  });

  final String email;
  final String code;
  final String? deviceName;

  @override
  List<Object?> get props => [email, code, deviceName];
}
