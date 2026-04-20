import 'package:masr_al_qsariya/core/storage/data/storage.dart';
import 'package:masr_al_qsariya/core/storage/models/local_user.dart';
import 'package:hive/hive.dart';

class StorageImpl implements Storage {
  final Box<String> stringBox;
  final Box<bool> boolBox;
  // final Box<UserModel> userBox;

  static const String _user = "user";
  static const String _token = "token";
  static const String _language = "language";
  static const String _onboarding = "onboarding";
  static const String _selectedRole = "selected_role";

  StorageImpl({required this.stringBox, required this.boolBox});

  //* user storage
  @override
  Future<void> storeUser({required LocalUser user}) async {
    await stringBox.put(_user, user.toJson());
  }

  @override
  LocalUser? getUser() {
    final json = stringBox.get(_user);
    if (json == null || json.isEmpty) return null;
    try {
      return LocalUser.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> deleteUser() async {
    await stringBox.delete(_user);
  }

  //* token storage
  @override
  Future<void> storeToken({required String token}) async {
    await stringBox.put(_token, token);
  }

  @override
  String? getToken() => stringBox.get(_token);

  @override
  Future<void> deleteToken() async {
    await stringBox.delete(_token);
  }

  //* onboarding storage
  @override
  bool isOnboardingCompleted() => boolBox.get(_onboarding) ?? false;

  @override
  Future<void> storeOnboardingCompleted({
    required bool isOnboardingCompleted,
  }) async {
    await boolBox.put(_onboarding, isOnboardingCompleted);
  }

  //* role storage
  @override
  Future<void> storeSelectedRole({required String role}) async {
    await stringBox.put(_selectedRole, role);
  }

  @override
  String? getSelectedRole() => stringBox.get(_selectedRole);

  @override
  Future<void> deleteSelectedRole() async {
    await stringBox.delete(_selectedRole);
  }

  //* language storage
  @override
  Future<void> storeLang({required String langCode}) async {
    await stringBox.put(_language, langCode);
  }

  @override
  String getLang() => stringBox.get(_language) ?? "en";

  @override
  Future<void> deleteLang() async {
    await stringBox.delete(_language);
  }

  //* check token
  @override
  bool isAuthorized() => stringBox.get(_token) != null;

  //* check language
  @override
  bool isSelectLang() => stringBox.get(_language) != null;
}
