import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/schedule/domain/repositories/calls_repository.dart';

class CallRecordingConsentParams extends Equatable {
  const CallRecordingConsentParams({
    required this.workspaceId,
    required this.callId,
    required this.approved,
  });

  final int workspaceId;
  final int callId;
  final bool approved;

  @override
  List<Object?> get props => [workspaceId, callId, approved];
}

class CallRecordingConsentUseCase {
  const CallRecordingConsentUseCase(this._repo);

  final CallsRepository _repo;

  Future<Either<Failure, void>> call(CallRecordingConsentParams params) {
    return _repo.callRecordingConsent(
      workspaceId: params.workspaceId,
      callId: params.callId,
      approved: params.approved,
    );
  }
}

