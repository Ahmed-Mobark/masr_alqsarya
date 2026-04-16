import 'package:masr_al_qsariya/core/navigation/navigation_inj.dart';
import 'package:masr_al_qsariya/core/network/network_service_inj.dart';
import 'package:masr_al_qsariya/core/services/media_service_inj.dart';
import 'package:masr_al_qsariya/core/storage/storage_inj.dart';
import 'package:get_it/get_it.dart';

GetIt sl = GetIt.instance;

Future<void> init() async {
  await initStorageInjection(sl);
  initNavigationInjection(sl);
  initNetworkServiceInjection(sl);
  initMediaServiceInjection(sl);

}
