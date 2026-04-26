import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/family_workspace/domain/entities/family_workspace_member.dart';
import 'package:masr_al_qsariya/features/family_workspace/domain/repositories/family_workspace_repository.dart';

class GetFamilyWorkspaceMembersUseCase {
  final FamilyWorkspaceRepository _repo;
  const GetFamilyWorkspaceMembersUseCase(this._repo);

  Future<Either<Failure, List<FamilyWorkspaceMemberEntity>>> call({
    required int workspaceId,
  }) =>
      _repo.getMembers(workspaceId: workspaceId);
}

