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
    this.type = typeCoPartner,
    /// Family workspace id (multipart). When null, datasource uses [WorkspaceIdStorage].
    this.workspaceId,
  });

  /// Co-parent: multipart `type` on `invite-co-partner`. Other roles: `professional_type` on `invite-professional`.
  static const String typeCoPartner = 'co_partner';
  static const String typeTherapist = 'therapist';
  /// Backend uses `lower` for lawyer role in family-workspace invites.
  static const String typeLawyer = 'lower';
  static const String typeOther = 'other';

  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String type;
  final int? workspaceId;

  @override
  List<Object?> get props => [firstName, lastName, phone, email, type, workspaceId];
}
