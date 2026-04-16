import 'package:get_it/get_it.dart';
import 'package:masr_al_qsariya/features/auth/presentation/cubit/auth_cubit.dart';

Future<void> initAuthInjection(GetIt sl) async {
  sl.registerFactory<AuthCubit>(() => AuthCubit());
}
