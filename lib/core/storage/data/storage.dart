
abstract class Storage {
  // User Storage
  // Future<void> storeUserData({required UserModel user});
  // UserModel? getUserData();
  // Future<void> deleteUserData();

  // Token Storage
  Future<void> storeToken({required String token});
  String? getToken();
  Future<void> deleteToken();

  // Check Token
  bool isAuthorized();

  // Check Onboarding
  bool isOnboardingCompleted();
  Future<void> storeOnboardingCompleted({required bool isOnboardingCompleted});

  // Language Storage
  Future<void> storeLang({required String langCode});
  String getLang();
  Future<void> deleteLang();

  // Check Language
  bool isSelectLang();


}
