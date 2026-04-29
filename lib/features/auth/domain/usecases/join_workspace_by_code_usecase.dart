import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/auth/domain/repositories/auth_repository.dart';

class JoinWorkspaceByCodeParams extends Equatable {
  const JoinWorkspaceByCodeParams({
    required this.invitationCode,
    required this.status,
  });

  final String invitationCode;
  final String status; // "accept" | "reject"

  @override
  List<Object?> get props => [invitationCode, status];
}

class JoinWorkspaceByCodeUseCase {
  const JoinWorkspaceByCodeUseCase(this._repo);
  final AuthRepository _repo;

  Future<Either<Failure, void>> call(JoinWorkspaceByCodeParams params) {
    return _repo.joinWorkspaceByCode(params);
  }
}

