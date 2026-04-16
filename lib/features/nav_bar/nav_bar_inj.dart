import 'package:get_it/get_it.dart';
import 'package:masr_al_qsariya/features/nav_bar/presentation/cubit/nav_bar_cubit.dart';

Future<void> initNavBarInjection(GetIt sl) async {
  sl.registerFactory<NavBarCubit>(() => NavBarCubit());
}

