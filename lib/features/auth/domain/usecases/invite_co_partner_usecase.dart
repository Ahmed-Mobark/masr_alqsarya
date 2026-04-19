import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/auth/domain/repositories/auth_repository.dart';

class InviteCoPartnerUseCase {
  const InviteCoPartnerUseCase(this._repo);

  final AuthRepository _repo;

  Future<Either<Failure, void>> call(InviteCoPartnerParams params) {
    return _repo.inviteCoPartner(params);
  }
}

class InviteCoPartnerParams extends Equatable {
  const InviteCoPartnerParams({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
  });

  final String firstName;
  final String lastName;
  final String phone;
  final String email;

  @override
  List<Object?> get props => [firstName, lastName, phone, email];
}
