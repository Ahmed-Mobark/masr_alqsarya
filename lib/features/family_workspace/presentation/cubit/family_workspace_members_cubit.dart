import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/family_workspace/domain/entities/family_workspace_member.dart';
import 'package:masr_al_qsariya/features/family_workspace/domain/usecases/get_family_workspace_members_usecase.dart';

class FamilyWorkspaceMembersCubit extends Cubit<FamilyWorkspaceMembersState> {
  final GetFamilyWorkspaceMembersUseCase _getMembers;
  FamilyWorkspaceMembersCubit(this._getMembers)
      : super(const FamilyWorkspaceMembersState.initial());

  Future<void> load({required int workspaceId}) async {
    emit(state.copyWith(status: FamilyWorkspaceMembersStatus.loading));
    final result = await _getMembers(workspaceId: workspaceId);
    result.fold(
      (failure) => emit(
        state.copyWith(status: FamilyWorkspaceMembersStatus.failure, failure: failure),
      ),
      (items) => emit(
        state.copyWith(status: FamilyWorkspaceMembersStatus.success, items: items),
      ),
    );
  }
}

enum FamilyWorkspaceMembersStatus { initial, loading, success, failure }

class FamilyWorkspaceMembersState extends Equatable {
  final FamilyWorkspaceMembersStatus status;
  final List<FamilyWorkspaceMemberEntity> items;
  final Failure? failure;

  const FamilyWorkspaceMembersState({
    required this.status,
    required this.items,
    required this.failure,
  });

  const FamilyWorkspaceMembersState.initial()
      : status = FamilyWorkspaceMembersStatus.initial,
        items = const [],
        failure = null;

  FamilyWorkspaceMembersState copyWith({
    FamilyWorkspaceMembersStatus? status,
    List<FamilyWorkspaceMemberEntity>? items,
    Failure? failure,
  }) {
    return FamilyWorkspaceMembersState(
      status: status ?? this.status,
      items: items ?? this.items,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [status, items, failure];
}

