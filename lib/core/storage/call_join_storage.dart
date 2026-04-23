import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class CallJoinStorage {
  Future<void> store({
    required int callId,
    required String livekitUrl,
    required String token,
    required String roomName,
  });

  CallJoinStored? get(int callId);

  Future<void> delete(int callId);
}

class CallJoinStorageImpl implements CallJoinStorage {
  CallJoinStorageImpl(this._prefs);

  final SharedPreferences _prefs;

  static String _key(int callId) => 'call_join_$callId';

  @override
  Future<void> store({
    required int callId,
    required String livekitUrl,
    required String token,
    required String roomName,
  }) async {
    final payload = jsonEncode({
      'livekit_url': livekitUrl,
      'token': token,
      'room_name': roomName,
    });
    await _prefs.setString(_key(callId), payload);
  }

  @override
  CallJoinStored? get(int callId) {
    final raw = _prefs.getString(_key(callId));
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;
      final map = Map<String, dynamic>.from(decoded);
      final livekitUrl = (map['livekit_url'] ?? '').toString();
      final token = (map['token'] ?? '').toString();
      final roomName = (map['room_name'] ?? '').toString();
      if (livekitUrl.isEmpty || token.isEmpty || roomName.isEmpty) return null;
      return CallJoinStored(
        livekitUrl: livekitUrl,
        token: token,
        roomName: roomName,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> delete(int callId) async {
    await _prefs.remove(_key(callId));
  }
}

class CallJoinStored {
  const CallJoinStored({
    required this.livekitUrl,
    required this.token,
    required this.roomName,
  });

  final String livekitUrl;
  final String token;
  final String roomName;
}

