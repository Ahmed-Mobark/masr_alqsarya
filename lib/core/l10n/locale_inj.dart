import 'package:get_it/get_it.dart';
import 'package:masr_al_qsariya/core/l10n/locale_cubit.dart';

Future<void> initLocaleInjection(GetIt sl) async {
  sl.registerLazySingleton<LocaleCubit>(() => LocaleCubit());
}

