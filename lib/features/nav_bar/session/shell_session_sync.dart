import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';
import 'package:masr_al_qsariya/core/storage/workspace_id_storage.dart';
import 'package:masr_al_qsariya/features/auth/domain/entities/workspace.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/get_workspace_usecase.dart';

/// When the main shell opens: ensures workspace id is loaded into [WorkspaceIdStorage]
/// (e.g. cold start with a saved token before the Messages tab runs).
Future<void> syncWorkspaceAndPrefetchChats() async {
  if (!sl<Storage>().isAuthorized()) return;

  final result = await sl<GetWorkspaceUseCase>()();
  final workspace = result.fold<Workspace?>((_) => null, (w) => w);
  final id = workspace?.id;
  if (id == null) return;

  await sl<WorkspaceIdStorage>().store(id);
}
