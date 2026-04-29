import 'package:masr_al_qsariya/core/navigation/navigation_inj.dart';
import 'package:masr_al_qsariya/core/l10n/locale_inj.dart';
import 'package:masr_al_qsariya/core/network/network_service_inj.dart';
import 'package:masr_al_qsariya/core/services/media_service_inj.dart';
import 'package:masr_al_qsariya/core/storage/storage_inj.dart';
import 'package:masr_al_qsariya/core/injection/realtime_inj.dart';
import 'package:masr_al_qsariya/core/injection/moderation_inj.dart';
import 'package:masr_al_qsariya/features/auth/auth_inj.dart';
import 'package:masr_al_qsariya/features/news/news_inj.dart';
import 'package:masr_al_qsariya/features/messages/messages_inj.dart';
import 'package:masr_al_qsariya/features/nav_bar/nav_bar_inj.dart';
import 'package:masr_al_qsariya/features/schedule/schedule_inj.dart';
import 'package:masr_al_qsariya/features/expense/expense_inj.dart';
import 'package:masr_al_qsariya/features/categories/categories_inj.dart';
import 'package:masr_al_qsariya/features/family_workspace/family_workspace_inj.dart';
import 'package:masr_al_qsariya/features/documents/documents_inj.dart';
import 'package:get_it/get_it.dart';

GetIt sl = GetIt.instance;

Future<void> init() async {
  sl.allowReassignment = true;
  await initStorageInjection(sl);
  initRealtimeInjection(sl);
  initModerationInjection(sl);
  await initLocaleInjection(sl);
  await initAuthInjection(sl);
  await initNewsInjection(sl);
  await initMessagesInjection(sl);
  await initScheduleInjection(sl);
  await initExpenseInjection(sl);
  await initCategoriesInjection(sl);
  await initDocumentsInjection(sl);
  await initFamilyWorkspaceInjection(sl);
  await initNavBarInjection(sl);
  initNavigationInjection(sl);
  initNetworkServiceInjection(sl);
  initMediaServiceInjection(sl);
}
