import 'package:masr_al_qsariya/core/storage/data/storage.dart';
import 'package:masr_al_qsariya/core/storage/data/storage_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive_flutter/hive_flutter.dart';

Future<void> initStorageInjection(GetIt sl) async {
  //! Get App Directory and Init Hive
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);

  //! Register Models
  // Hive.registerAdapter(UserModelAdapter());

  //! Open Boxes
  // Box<UserModel> userBox = await Hive.openBox<UserModel>('userBox');
  Box<String> stringBox = await Hive.openBox<String>('stringBox');
  Box<bool> boolBox = await Hive.openBox<bool>('boolBox');

  //! Injection
  sl.registerLazySingleton<Box<String>>(() => stringBox);
  // sl.registerLazySingleton<Box<UserModel>>(() => userBox);
  sl.registerLazySingleton<Box<bool>>(() => boolBox);

  sl.registerFactory<Storage>(
    () => StorageImpl(stringBox: sl(), boolBox: sl()),
  );
}
