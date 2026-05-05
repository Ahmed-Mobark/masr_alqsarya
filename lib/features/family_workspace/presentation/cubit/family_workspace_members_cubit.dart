import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/family_workspace/domain/entities/family_workspace_member.dart';
import 'package:masr_al_qsariya/features/family_workspace/domain/usecases/get_family_workspace_members_usecase.dart';

class FamilyWorkspaceMembersCubit extends Cubit<FamilyWorkspaceMembersState> {
  final GetFamilyWorkspaceMembersUseCase _getMembers;
  FamilyWorkspaceMembersCubit(this._getMembers)
      : super(const FamilyWorkspaceMembersState.initial());

  Future<void> load({
    required int workspaceId,
    String? role,
  }) async {
    emit(
      FamilyWorkspaceMembersState(
        status: FamilyWorkspaceMembersStatus.loading,
        items: state.items,
        failure: null,
      ),
    );
    final result = await _getMembers(workspaceId: workspaceId, role: role);
    result.fold(
      (failure) => emit(
        FamilyWorkspaceMembersState(
          status: FamilyWorkspaceMembersStatus.failure,
          items: state.items,
          failure: failure,
        ),
      ),
      (items) => emit(
        FamilyWorkspaceMembersState(
          status: FamilyWorkspaceMembersStatus.success,
          items: items,
          failure: null,
        ),
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
    this.failure,
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
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, items, failure];
}

