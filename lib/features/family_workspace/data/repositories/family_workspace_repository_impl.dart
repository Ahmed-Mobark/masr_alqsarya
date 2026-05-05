import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/core/network/network_service/repository_helper.dart';
import 'package:masr_al_qsariya/features/family_workspace/data/datasources/family_workspace_remote_data_source.dart';
import 'package:masr_al_qsariya/features/family_workspace/domain/entities/family_workspace_member.dart';
import 'package:masr_al_qsariya/features/family_workspace/domain/repositories/family_workspace_repository.dart';

class FamilyWorkspaceRepositoryImpl
    with RepositoryHelper
    implements FamilyWorkspaceRepository {
  const FamilyWorkspaceRepositoryImpl(this._remote);
  final FamilyWorkspaceRemoteDataSource _remote;

  @override
  Future<Either<Failure, List<FamilyWorkspaceMemberEntity>>> getMembers({
    required int workspaceId,
    String? role,
  }) {
    return handleEither(() async {
      final models = await _remote.getMembers(
        workspaceId: workspaceId,
        role: role,
      );
      return models.map((m) => m.toEntity()).toList();
    });
  }
}

