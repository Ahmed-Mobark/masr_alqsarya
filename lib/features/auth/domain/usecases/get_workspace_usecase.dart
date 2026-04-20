import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/auth/domain/entities/workspace.dart';
import 'package:masr_al_qsariya/features/auth/domain/repositories/auth_repository.dart';

class GetWorkspaceUseCase {
  const GetWorkspaceUseCase(this._repo);

  final AuthRepository _repo;

  Future<Either<Failure, Workspace>> call() {
    return _repo.getWorkspace();
  }
}
