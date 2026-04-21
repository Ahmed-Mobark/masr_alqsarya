import 'package:get_it/get_it.dart';
import 'package:masr_al_qsariya/core/realtime/realtime_service.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';

void initRealtimeInjection(GetIt sl) {
  sl.registerLazySingleton<RealtimeService>(
    () => RealtimeService(sl<Storage>()),
  );
}
