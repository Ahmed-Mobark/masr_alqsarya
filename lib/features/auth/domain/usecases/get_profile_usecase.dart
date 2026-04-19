import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/auth/domain/entities/user_profile.dart';
import 'package:masr_al_qsariya/features/auth/domain/repositories/auth_repository.dart';

class GetProfileUseCase {
  const GetProfileUseCase(this._repo);

  final AuthRepository _repo;

  Future<Either<Failure, UserProfile>> call() {
    return _repo.getProfile();
  }
}
