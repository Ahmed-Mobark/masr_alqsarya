import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/schedule/domain/entities/call.dart';
import 'package:masr_al_qsariya/features/schedule/domain/repositories/calls_repository.dart';

class CreateCallParams extends Equatable {
  const CreateCallParams({
    required this.workspaceId,
    required this.mode,
    required this.scheduledStartsAt,
  });

  final int workspaceId;
  final String mode; // audio | video
  /// Backend expects `YYYY-MM-DD` (as shown in your request).
  final String scheduledStartsAt;

  @override
  List<Object?> get props => [workspaceId, mode, scheduledStartsAt];
}

class CreateCallUseCase {
  const CreateCallUseCase(this._repo);

  final CallsRepository _repo;

  Future<Either<Failure, CallEntity>> call(CreateCallParams params) {
    return _repo.createCall(
      workspaceId: params.workspaceId,
      mode: params.mode,
      scheduledStartsAt: params.scheduledStartsAt,
    );
  }
}

