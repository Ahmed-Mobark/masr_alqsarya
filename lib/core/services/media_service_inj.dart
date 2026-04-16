import 'package:get_it/get_it.dart';
import 'package:masr_al_qsariya/core/services/media_service/media_service_impl.dart';
import 'package:masr_al_qsariya/core/services/media_service/media_services.dart';

void initMediaServiceInjection(GetIt sl) {
  sl.registerLazySingleton<MediaService>(() => MediaServiceImpl());
}