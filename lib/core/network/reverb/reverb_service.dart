import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:masr_al_qsariya/core/config/app_end_points.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/core/realtime/laravel_broadcasting_auth_delegate.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';

class ReverbService {
  ReverbService._();
  static final ReverbService _instance = ReverbService._();
  factory ReverbService() => _instance;

  // Configure via build-time defines (recommended for prod/staging/local):
  // --dart-define=REVERB_HOST=...
  // --dart-define=REVERB_PORT=443
  // --dart-define=REVERB_SCHEME=https
  // --dart-define=REVERB_APP_KEY=...
  static const String _host = String.fromEnvironment(
    'REVERB_HOST',
    defaultValue: 'misr-alosariya_back-uqudc3ap.on-forge.com',
  );
  static const int _port = int.fromEnvironment(
    'REVERB_PORT',
    defaultValue: 443,
  );
  static const String _httpScheme = String.fromEnvironment(
    'REVERB_SCHEME',
    defaultValue: 'https',
  );
  static const String _appKey = String.fromEnvironment(
    'REVERB_APP_KEY',
    defaultValue: 'cihrywvayxv8nguraxqy',
  );
  static const String _authUrlOverride = String.fromEnvironment(
    'REVERB_AUTH_URL',
    defaultValue: '',
  );

  static String get _wsScheme => _httpScheme == 'https' ? 'wss' : 'ws';
  static Uri get _authEndpoint {
    // Important: Laravel broadcasting auth is served by the API host, not the
    // Reverb websocket host. Using the ws host here commonly causes 404.
    if (_authUrlOverride.trim().isNotEmpty) {
      return Uri.parse(_authUrlOverride);
    }
    return Uri.parse(AppEndpoints.broadcastingAuthUrl);
  }

  PusherChannelsClient? _client;
  StreamSubscription? _lifecycleSub;
  StreamSubscription? _connectionEstablishedSub;
  bool _isConnected = false;
  final Map<String, StreamSubscription> _channelSubs = {};
  final Map<String, PrivateChannel> _channels = {};

  bool get isConnected => _isConnected;

  Future<void> _awaitEstablishedConnection({
    Duration timeout = const Duration(seconds: 12),
  }) async {
    final client = _client;
    if (client == null || client.isDisposed) return;
    if (_isConnected) return;

    final completer = Completer<void>();
    late final StreamSubscription sub;
    sub = client.lifecycleStream.listen((state) {
      if (state == PusherChannelsClientLifeCycleState.establishedConnection) {
        if (!completer.isCompleted) completer.complete();
      }
    });
    try {
      await completer.future.timeout(timeout);
    } finally {
      await sub.cancel();
    }
  }

  Future<void> connect() async {
    if (_client != null && _isConnected) return;

    _disposeClient();

    final options = PusherChannelsOptions.fromHost(
      scheme: _wsScheme,
      host: _host,
      port: _port,
      key: _appKey,
    );

    _client = PusherChannelsClient.websocket(
      options: options,
      connectionErrorHandler: (exception, trace, refresh) {
        log('ReverbService: connection error — $exception');
        Future.delayed(const Duration(seconds: 2), refresh);
      },
      minimumReconnectDelayDuration: const Duration(seconds: 2),
    );

    _lifecycleSub = _client!.lifecycleStream.listen((state) {
      final connected =
          state == PusherChannelsClientLifeCycleState.establishedConnection;
      if (_isConnected != connected) {
        _isConnected = connected;
        log('ReverbService: connected=$_isConnected ($state)');
      }
    });

    _connectionEstablishedSub = _client!.onConnectionEstablished.listen((_) {
      for (final channel in _channels.values) {
        channel.subscribeIfNotUnsubscribed();
      }
    });

    await _client!.connect();

    // Don't silently succeed on timeout; callers rely on an actual socket.
    await _awaitEstablishedConnection();
  }

  Future<void> ensureConnected() async {
    final token = sl<Storage>().getToken();
    if (token == null || token.trim().isEmpty) return;
    if (_client != null && !_client!.isDisposed) {
      await _client!.connect();
      await _awaitEstablishedConnection();
      return;
    }
    await connect();
  }

  Future<void> subscribePrivateChat({
    required int workspaceId,
    required int chatId,
    required void Function(String eventName, Map<String, dynamic> data) onEvent,
  }) async {
    final channelName = AppEndpoints.privateChatChannelName(
      workspaceId: workspaceId,
      chatId: chatId,
    );
    unsubscribe(channelName);
    await ensureConnected();
    await subscribeToAllEvents(
      channelName: channelName,
      onEvent: (eventName, data) => onEvent(eventName, data),
    );
  }

  Future<StreamSubscription?> subscribe({
    required String channelName,
    required String eventName,
    required void Function(Map<String, dynamic> data) onEvent,
  }) async {
    await ensureConnected();
    final client = _client;
    if (client == null || client.isDisposed) return null;

    final token = sl<Storage>().getToken();
    if (token == null || token.trim().isEmpty) {
      log('ReverbService: subscribe blocked (missing Bearer token)');
      return null;
    }

    final authUri = _authEndpoint;
    final delegate = LaravelBroadcastingAuthDelegate(
      dio: sl<ApiBaseHelper>().getDio(ApiEnvironment.primary),
      storage: sl<Storage>(),
      authorizationEndpoint: authUri,
    );

    log('ReverbService: subscribing channel="$channelName" event="$eventName"');

    final channel = client.privateChannel(
      channelName,
      authorizationDelegate: delegate,
    );
    _channels[channelName] = channel;

    await _awaitPrivateChannelSubscription(channel, channelName);

    final sub = channel.bind(eventName).listen((event) {
      _dispatchEvent(event, onEvent);
    });

    _channelSubs[channelName] = sub;
    return sub;
  }

  Future<StreamSubscription?> subscribeToAllEvents({
    required String channelName,
    required void Function(String eventName, Map<String, dynamic> data) onEvent,
  }) async {
    await ensureConnected();
    final client = _client;
    if (client == null || client.isDisposed) return null;

    final token = sl<Storage>().getToken();
    if (token == null || token.trim().isEmpty) {
      log('ReverbService: subscribe blocked (missing Bearer token)');
      return null;
    }

    final authUri = _authEndpoint;
    final delegate = LaravelBroadcastingAuthDelegate(
      dio: sl<ApiBaseHelper>().getDio(ApiEnvironment.primary),
      storage: sl<Storage>(),
      authorizationEndpoint: authUri,
    );

    log('ReverbService: subscribing channel="$channelName" (bindToAll)');

    final channel = client.privateChannel(
      channelName,
      authorizationDelegate: delegate,
    );
    _channels[channelName] = channel;

    await _awaitPrivateChannelSubscription(channel, channelName);

    final sub = channel.bindToAll().listen((event) {
      if (event.name.startsWith('pusher:')) return;
      final data = _eventToMap(event);
      if (data == null) return;
      onEvent(event.name, data);
    });

    _channelSubs[channelName] = sub;
    return sub;
  }

  void unsubscribe(String channelName) {
    _channelSubs[channelName]?.cancel();
    _channelSubs.remove(channelName);

    _channels[channelName]?.unsubscribe();
    _channels.remove(channelName);
  }

  Future<void> disconnect() async {
    for (final sub in _channelSubs.values) {
      sub.cancel();
    }
    _channelSubs.clear();
    _channels.clear();
    _disposeClient();
  }

  Future<void> _awaitPrivateChannelSubscription(
    PrivateChannel channel,
    String channelName,
  ) async {
    final completer = Completer<void>();
    late final StreamSubscription<ChannelReadEvent> subOk;
    late final StreamSubscription<ChannelReadEvent> subErr;

    subOk = channel.whenSubscriptionSucceeded().listen((_) {
      if (!completer.isCompleted) completer.complete();
    });
    subErr = channel.onSubscriptionError().listen((event) {
      if (completer.isCompleted) return;
      final map = event.tryGetDataAsMap();
      final msg =
          map?[PusherChannelsEvent.errorKey]?.toString() ??
          map?['message']?.toString() ??
          'Subscription error on $channelName';
      completer.completeError(StateError(msg));
    });

    channel.subscribe();

    try {
      await completer.future.timeout(
        const Duration(seconds: 25),
        onTimeout: () => throw TimeoutException(
          'Timed out waiting for $channelName subscription '
          '(check /broadcasting/auth JSON and WebSocket).',
        ),
      );
      log('ReverbService: subscribed $channelName');
    } finally {
      await subOk.cancel();
      await subErr.cancel();
    }
  }

  void _dispatchEvent(
    ChannelReadEvent event,
    void Function(Map<String, dynamic>) onEvent,
  ) {
    // Helpful for diagnosing "subscribed but not receiving events".
    log('ReverbService: event="${event.name}" channel="${event.channelName}"');

    final payload = event.tryGetDataAsMap();
    if (payload != null) {
      log('ReverbService: payload(map)=${jsonEncode(payload)}');
      onEvent(payload);
      return;
    }

    final raw = event.data;
    if (raw is String) {
      try {
        log('ReverbService: payload(raw)=$raw');
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        onEvent(decoded);
      } catch (e) {
        log('ReverbService: decode error — $e');
      }
    }
  }

  Map<String, dynamic>? _eventToMap(ChannelReadEvent event) {
    final payload = event.tryGetDataAsMap();
    if (payload != null) return payload;
    final raw = event.data;
    if (raw is String) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) return decoded;
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } catch (_) {
        return null;
      }
    }
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return null;
  }

  void _disposeClient() {
    _lifecycleSub?.cancel();
    _lifecycleSub = null;
    _connectionEstablishedSub?.cancel();
    _connectionEstablishedSub = null;
    if (_client != null && !_client!.isDisposed) {
      try {
        _client!.dispose();
      } catch (_) {}
    }
    _client = null;
    _isConnected = false;
  }
}
