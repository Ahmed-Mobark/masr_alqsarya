import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/schedule/domain/entities/calendar_item_type.dart';
import 'package:masr_al_qsariya/features/schedule/domain/repositories/calls_repository.dart';

class GetCalendarItemTypesParams extends Equatable {
  const GetCalendarItemTypesParams({required this.workspaceId});

  final int workspaceId;

  @override
  List<Object?> get props => [workspaceId];
}

class GetCalendarItemTypesUseCase {
  const GetCalendarItemTypesUseCase(this._repo);

  final CallsRepository _repo;

  Future<Either<Failure, List<CalendarItemTypeEntity>>> call(
    GetCalendarItemTypesParams params,
  ) {
    return _repo.getCalendarItemTypes(workspaceId: params.workspaceId);
  }
}

