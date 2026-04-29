import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/documents/domain/entities/documents_workspace_member.dart';
import 'package:masr_al_qsariya/features/documents/domain/repositories/documents_repository.dart';

class GetWorkspaceMembersUseCase {
  const GetWorkspaceMembersUseCase(this._repo);

  final DocumentsRepository _repo;

  Future<Either<Failure, List<DocumentsWorkspaceMemberEntity>>> call(
    GetWorkspaceMembersParams params,
  ) => _repo.getWorkspaceMembers(workspaceId: params.workspaceId);
}

class GetWorkspaceMembersParams extends Equatable {
  const GetWorkspaceMembersParams({required this.workspaceId});

  final int workspaceId;

  @override
  List<Object> get props => [workspaceId];
}
