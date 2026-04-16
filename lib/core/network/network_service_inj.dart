import 'package:dio/dio.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

void initNetworkServiceInjection(GetIt sl) {
  sl.registerLazySingleton<InternetConnection>(() => InternetConnection());
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<ApiBaseHelper>(() => ApiBaseHelper());
}