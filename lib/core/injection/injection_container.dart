import 'package:masr_al_qsariya/core/navigation/navigation_inj.dart';
import 'package:masr_al_qsariya/core/l10n/locale_inj.dart';
import 'package:masr_al_qsariya/core/network/network_service_inj.dart';
import 'package:masr_al_qsariya/core/services/media_service_inj.dart';
import 'package:masr_al_qsariya/core/storage/storage_inj.dart';
import 'package:masr_al_qsariya/core/injection/realtime_inj.dart';
import 'package:masr_al_qsariya/features/auth/auth_inj.dart';
import 'package:masr_al_qsariya/features/news/news_inj.dart';
import 'package:masr_al_qsariya/features/messages/messages_inj.dart';
import 'package:masr_al_qsariya/features/nav_bar/nav_bar_inj.dart';
import 'package:get_it/get_it.dart';

GetIt sl = GetIt.instance;

Future<void> init() async {
  sl.allowReassignment = true;
  await initStorageInjection(sl);
  initRealtimeInjection(sl);
  await initLocaleInjection(sl);
  await initAuthInjection(sl);
  await initNewsInjection(sl);
  await initMessagesInjection(sl);
  await initNavBarInjection(sl);
  initNavigationInjection(sl);
  initNetworkServiceInjection(sl);
  initMediaServiceInjection(sl);
}
