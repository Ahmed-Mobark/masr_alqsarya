import 'package:masr_al_qsariya/core/storage/models/local_user.dart';

abstract class Storage {
  // User Storage
  Future<void> storeUser({required LocalUser user});
  LocalUser? getUser();
  Future<void> deleteUser();

  // Token Storage
  Future<void> storeToken({required String token});
  String? getToken();
  Future<void> deleteToken();

  // Check Token
  bool isAuthorized();

  // Check Onboarding
  bool isOnboardingCompleted();
  Future<void> storeOnboardingCompleted({required bool isOnboardingCompleted});

  // Role Storage
  Future<void> storeSelectedRole({required String role});
  String? getSelectedRole();
  Future<void> deleteSelectedRole();

  // Language Storage
  Future<void> storeLang({required String langCode});
  String getLang();
  Future<void> deleteLang();

  // Check Language
  bool isSelectLang();


}
