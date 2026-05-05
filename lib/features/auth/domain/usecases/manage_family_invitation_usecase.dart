import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/auth/domain/repositories/auth_repository.dart';

class ResendFamilyInvitationParams extends Equatable {
  const ResendFamilyInvitationParams({
    required this.invitationId,
    required this.email,
  });

  final int invitationId;
  final String email;

  @override
  List<Object?> get props => [invitationId, email];
}

class CancelFamilyInvitationParams extends Equatable {
  const CancelFamilyInvitationParams({
    required this.invitationId,
    required this.email,
  });

  final int invitationId;
  final String email;

  @override
  List<Object?> get props => [invitationId, email];
}

class ResendFamilyInvitationUseCase {
  const ResendFamilyInvitationUseCase(this._repo);

  final AuthRepository _repo;

  Future<Either<Failure, void>> call(ResendFamilyInvitationParams params) {
    return _repo.resendFamilyInvitation(params);
  }
}

class CancelFamilyInvitationUseCase {
  const CancelFamilyInvitationUseCase(this._repo);

  final AuthRepository _repo;

  Future<Either<Failure, void>> call(CancelFamilyInvitationParams params) {
    return _repo.cancelFamilyInvitation(params);
  }
}
