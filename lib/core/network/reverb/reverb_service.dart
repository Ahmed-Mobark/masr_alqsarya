import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:http/http.dart' as http;
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';


class _JsonPrivateChannelAuthDelegate
    implements EndpointAuthorizableChannelAuthorizationDelegate<
        PrivateChannelAuthorizationData> {
  const _JsonPrivateChannelAuthDelegate({
    required this.authorizationEndpoint,
    required this.headers,
    required this.onAuthFailed,
  });

  final Uri authorizationEndpoint;
  final Map<String, String> headers;

  @override
  final EndpointAuthFailedCallback? onAuthFailed;

  @override
  Future<PrivateChannelAuthorizationData> authorizationData(
    String socketId,
    String channelName,
  ) async {
    try {
      log(
        'ReverbService: auth request socket_id=$socketId channel_name=$channelName',
      );
      final response = await http.post(
        authorizationEndpoint,
        headers: <String, String>{
          ...headers,
          'content-type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'socket_id': socketId,
          'channel_name': channelName,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Auth failed (${response.statusCode}) at $authorizationEndpoint: ${response.body}',
        );
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map) {
        throw const FormatException('Invalid auth response');
      }
      final auth = decoded['auth'];
      if (auth is! String || auth.isEmpty) {
        throw const FormatException('Missing auth key');
      }
      log('ReverbService: auth ok (prefix=${auth.split(':').first})');
      return PrivateChannelAuthorizationData(authKey: auth);
    } catch (e, st) {
      onAuthFailed?.call(e, st);
      rethrow;
    }
  }
}

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
    defaultValue: 'shajareteldor-back-qr30eq11.on-forge.com',
  );
  static const int _port = int.fromEnvironment('REVERB_PORT', defaultValue: 443);
  static const String _httpScheme =
      String.fromEnvironment('REVERB_SCHEME', defaultValue: 'https');
  static const String _appKey = String.fromEnvironment(
    'REVERB_APP_KEY',
    defaultValue: 'aIeU091R1bcTmXSB102i',
  );
  static const String _authPath = String.fromEnvironment(
    'REVERB_AUTH_PATH',
    defaultValue: '/api/broadcasting/auth',
  );

  static String get _wsScheme => _httpScheme == 'https' ? 'wss' : 'ws';
  static String get _authEndpoint =>
      '$_httpScheme://$_host:${_port.toString()}$_authPath';

  PusherChannelsClient? _client;
  StreamSubscription? _lifecycleSub;
  StreamSubscription? _connectionEstablishedSub;
  bool _isConnected = false;
  final Map<String, StreamSubscription> _channelSubs = {};
  final Map<String, PrivateChannel> _channels = {};

  bool get isConnected => _isConnected;

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
        Future.delayed(const Duration(seconds: 5), refresh);
      },
    );

    final completer = Completer<void>();

    _lifecycleSub = _client!.lifecycleStream.listen((state) {
      final connected =
          state == PusherChannelsClientLifeCycleState.establishedConnection;
      if (_isConnected != connected) {
        _isConnected = connected;
        log('ReverbService: connected=$_isConnected ($state)');
      }
      if (connected && !completer.isCompleted) {
        completer.complete();
      }
    });

    _connectionEstablishedSub = _client!.onConnectionEstablished.listen((_) {
      for (final channel in _channels.values) {
        channel.subscribeIfNotUnsubscribed();
      }
    });

    await _client!.connect();

    // Don't silently succeed on timeout; callers rely on an actual socket.
    await completer.future.timeout(const Duration(seconds: 12));
  }

  Future<StreamSubscription?> subscribe({
    required String channelName,
    required String eventName,
    required void Function(Map<String, dynamic> data) onEvent,
  }) async {
    if (_client == null) return null;
    if (!_isConnected) {
      log('ReverbService: subscribe called while not connected');
    }

   

    if (sl<Storage>().getToken() == null || sl<Storage>().getToken()!.trim().isEmpty) {
      log('ReverbService: subscribe blocked (missing Bearer token)');
      return null;
    }

    log(
      'ReverbService: subscribing channel="$channelName" event="$eventName" token=${sl<Storage>().getToken()?.substring(0, 10)}...',
    );

    final authDelegate = _JsonPrivateChannelAuthDelegate(
      authorizationEndpoint: Uri.parse(_authEndpoint),
      headers: {
        'Authorization': 'Bearer ${sl<Storage>().getToken()}',
        'Accept': 'application/json',
      },
      onAuthFailed: (exception, trace) {
        if (exception
            is EndpointAuthorizableChannelTokenAuthorizationException) {
          log('ReverbService: auth ${exception.response.statusCode} — ${exception.response.body}');
        } else {
          log('ReverbService: auth failed — $exception');
        }
      },
    );

    final channel = _client!.privateChannel(
      channelName,
      authorizationDelegate: authDelegate,
    );
    _channels[channelName] = channel;

    channel.subscribe();

    final sub = channel.bind(eventName).listen((event) {
      _dispatchEvent(event, onEvent);
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
