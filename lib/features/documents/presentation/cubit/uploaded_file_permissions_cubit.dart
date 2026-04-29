import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/documents/domain/entities/documents_uploaded_file_permission.dart';
import 'package:masr_al_qsariya/features/documents/domain/entities/documents_workspace_member.dart';
import 'package:masr_al_qsariya/features/documents/domain/usecases/get_workspace_members_usecase.dart';
import 'package:masr_al_qsariya/features/documents/domain/usecases/update_uploaded_file_permissions_usecase.dart';

class UploadedFilePermissionsCubit extends Cubit<UploadedFilePermissionsState> {
  UploadedFilePermissionsCubit(
    this._getWorkspaceMembers,
    this._updateUploadedFilePermissions,
  ) : super(const UploadedFilePermissionsState.initial());

  final GetWorkspaceMembersUseCase _getWorkspaceMembers;
  final UpdateUploadedFilePermissionsUseCase _updateUploadedFilePermissions;

  Future<void> update({
    required int workspaceId,
    required List<int> assetIds,
    required int viewIndex,
    required int editIndex,
  }) async {
    if (assetIds.isEmpty) return;

    emit(state.copyWith(status: UploadedFilePermissionsStatus.loading));

    String? lastMessage;

    final membersResult = await _getWorkspaceMembers(
      GetWorkspaceMembersParams(workspaceId: workspaceId),
    );

    await membersResult.fold(
      (failure) async {
        emit(
          state.copyWith(
            status: UploadedFilePermissionsStatus.failure,
            failure: failure,
          ),
        );
      },
      (members) async {
        final ids = _extractParentIds(members);

        final canView = viewIndex == 2 ? false : true;
        final canUpdate = editIndex == 2 ? false : true;

        final permissions = <DocumentsUploadedFilePermissionEntity>[
          if (ids.parentAId != null)
            DocumentsUploadedFilePermissionEntity(
              workspaceMemberId: ids.parentAId!,
              canView: canView,
              canUpdate: canUpdate,
            ),
          if (ids.parentBId != null)
            DocumentsUploadedFilePermissionEntity(
              workspaceMemberId: ids.parentBId!,
              canView: canView,
              canUpdate: canUpdate,
            ),
        ];

        if (permissions.isEmpty) {
          emit(
            state.copyWith(
              status: UploadedFilePermissionsStatus.failure,
              failure: const ServerFailure(message: 'No parents found'),
            ),
          );
          return;
        }

        for (final assetId in assetIds) {
          final result = await _updateUploadedFilePermissions(
            UpdateUploadedFilePermissionsParams(
              workspaceId: workspaceId,
              assetId: assetId,
              permissions: permissions,
            ),
          );

          final ok = await result.fold(
            (failure) async {
              emit(
                state.copyWith(
                  status: UploadedFilePermissionsStatus.failure,
                  failure: failure,
                ),
              );
              return false;
            },
            (message) async {
              lastMessage = message;
              return true;
            },
          );

          if (!ok) return;
        }

        emit(
          state.copyWith(
            status: UploadedFilePermissionsStatus.success,
            failure: null,
            successMessage: lastMessage,
          ),
        );
      },
    );
  }

  _ParentIds _extractParentIds(List<DocumentsWorkspaceMemberEntity> members) {
    int? parentA;
    int? parentB;

    for (final m in members) {
      final r = m.role.toLowerCase();
      final n = m.fullName.toLowerCase();

      final isParentA =
          r.contains('parenta') ||
          r.contains('mother') ||
          n.contains('mother') ||
          n.contains('أم') ||
          r.contains('أم');

      final isParentB =
          r.contains('parentb') ||
          r.contains('father') ||
          n.contains('father') ||
          n.contains('أب') ||
          r.contains('أبو') ||
          r.contains('والد') ||
          n.contains('والد');

      if (isParentA && parentA == null) parentA = m.id;
      if (isParentB && parentB == null) parentB = m.id;
    }

    // Fallback: keep UI functional even if role strings differ.
    if (parentA == null && members.isNotEmpty) parentA = members.first.id;
    if (parentB == null && members.length > 1) parentB = members[1].id;

    return _ParentIds(parentAId: parentA, parentBId: parentB);
  }
}

class _ParentIds {
  const _ParentIds({required this.parentAId, required this.parentBId});
  final int? parentAId;
  final int? parentBId;
}

enum UploadedFilePermissionsStatus { initial, loading, success, failure }

class UploadedFilePermissionsState extends Equatable {
  const UploadedFilePermissionsState({
    required this.status,
    this.failure,
    this.successMessage,
  });

  const UploadedFilePermissionsState.initial()
    : status = UploadedFilePermissionsStatus.initial,
      failure = null,
      successMessage = null;

  final UploadedFilePermissionsStatus status;
  final Failure? failure;
  final String? successMessage;

  UploadedFilePermissionsState copyWith({
    UploadedFilePermissionsStatus? status,
    Failure? failure,
    String? successMessage,
  }) {
    return UploadedFilePermissionsState(
      status: status ?? this.status,
      failure: failure,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [status, failure, successMessage];
}
