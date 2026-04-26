import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/schedule/domain/repositories/calls_repository.dart';

class CreateCalendarItemParams extends Equatable {
  const CreateCalendarItemParams({
    required this.workspaceId,
    required this.type,
    required this.startsAt,
    this.endsAt,
    this.note,
    this.categoryId,
    this.childWorkspaceMemberId,
  });

  final int workspaceId;
  final String type;
  final String startsAt;
  final String? endsAt;
  final String? note;
  final int? categoryId;
  final int? childWorkspaceMemberId;

  @override
  List<Object?> get props => [
        workspaceId,
        type,
        startsAt,
        endsAt,
        note,
        categoryId,
        childWorkspaceMemberId,
      ];
}

class CreateCalendarItemUseCase {
  const CreateCalendarItemUseCase(this._repo);

  final CallsRepository _repo;

  Future<Either<Failure, void>> call(CreateCalendarItemParams params) {
    return _repo.createCalendarItem(
      workspaceId: params.workspaceId,
      type: params.type,
      startsAt: params.startsAt,
      endsAt: params.endsAt,
      note: params.note,
      categoryId: params.categoryId,
      childWorkspaceMemberId: params.childWorkspaceMemberId,
    );
  }
}

