import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/family_workspace/domain/entities/family_workspace_member.dart';

abstract class FamilyWorkspaceRepository {
  Future<Either<Failure, List<FamilyWorkspaceMemberEntity>>> getMembers({
    required int workspaceId,
  });
}

