import 'package:shared_preferences/shared_preferences.dart';

/// Persists the active family workspace id (used for e.g. `/workspaces/{id}/chats`).
abstract class WorkspaceIdStorage {
  Future<void> store(int workspaceId);
  int? get();
  Future<void> delete();
}

class WorkspaceIdStorageImpl implements WorkspaceIdStorage {
  WorkspaceIdStorageImpl(this._prefs);

  final SharedPreferences _prefs;

  static const String _key = 'workspace_id';

  @override
  Future<void> store(int workspaceId) async {
    await _prefs.setString(_key, workspaceId.toString());
  }

  @override
  int? get() {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return null;
    return int.tryParse(raw);
  }

  @override
  Future<void> delete() async {
    await _prefs.remove(_key);
  }
}
