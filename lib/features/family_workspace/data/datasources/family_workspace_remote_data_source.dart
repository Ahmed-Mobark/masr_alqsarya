import 'package:masr_al_qsariya/core/config/app_end_points.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/features/family_workspace/data/models/family_workspace_member_model.dart';

abstract class FamilyWorkspaceRemoteDataSource {
  Future<List<FamilyWorkspaceMemberModel>> getMembers({
    required int workspaceId,
  });
}

class FamilyWorkspaceRemoteDataSourceImpl
    implements FamilyWorkspaceRemoteDataSource {
  const FamilyWorkspaceRemoteDataSourceImpl(this._api);
  final ApiBaseHelper _api;

  @override
  Future<List<FamilyWorkspaceMemberModel>> getMembers({
    required int workspaceId,
  }) async {
    final url = Uri(
      path: AppEndpoints.familyWorkspaceMembers,
      queryParameters: {
        'role': 'child',
        // Backend expects workspace_id as query param (matches Postman).
        'workspace_id': workspaceId.toString(),
      },
    ).toString();

    final response = await _api.get<Map<String, dynamic>>(
      // Keep query inline in URL so it appears clearly in logs.
      url: url,
    );

    final data = response['data'];
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(FamilyWorkspaceMemberModel.fromJson)
          .toList();
    }

    if (data is Map<String, dynamic>) {
      final inner = data['data'];
      if (inner is List) {
        return inner
            .whereType<Map<String, dynamic>>()
            .map(FamilyWorkspaceMemberModel.fromJson)
            .toList();
      }
    }

    return const [];
  }
}
