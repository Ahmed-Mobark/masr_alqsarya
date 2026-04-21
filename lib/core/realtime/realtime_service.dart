import 'dart:async';

import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:masr_al_qsariya/core/config/app_end_points.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';

class _ChatListen {
  _ChatListen({required this.subscription, required this.channel});

  final StreamSubscription<ChannelReadEvent> subscription;
  final PrivateChannel channel;
}

/// Soketi / Pusher-protocol WebSocket client (private channels + Laravel broadcasting auth).
class RealtimeService {
  RealtimeService(this._storage);

  final Storage _storage;

  PusherChannelsClient? _client;
  final Map<int, _ChatListen> _chatListeners = {};

  PusherChannelsOptions get _options => PusherChannelsOptions.fromHost(
        scheme: 'wss',
        host: AppEndpoints.soketiHost,
        key: AppEndpoints.soketiAppKey,
        port: AppEndpoints.soketiPort,
      );

  Map<String, String> get _authHeaders {
    final token = _storage.getToken();
    return {
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<void> ensureConnected() async {
    if (_storage.getToken() == null) return;

    if (_client != null && !_client!.isDisposed) {
      await _client!.connect();
      return;
    }

    _client = PusherChannelsClient.websocket(
      options: _options,
      connectionErrorHandler: (_, __, refresh) => refresh(),
      minimumReconnectDelayDuration: const Duration(seconds: 2),
    );
    await _client!.connect();
  }

  /// Subscribe to the workspace chat private channel; [onNewActivity] runs when a non-system event arrives.
  Future<void> subscribePrivateChat({
    required int chatId,
    required void Function() onNewActivity,
  }) async {
    await unsubscribeChat(chatId);

    final token = _storage.getToken();
    if (token == null || token.isEmpty) return;

    await ensureConnected();
    final client = _client;
    if (client == null || client.isDisposed) return;

    final channelName = AppEndpoints.privateChatChannelName(chatId);
    final delegate = EndpointAuthorizableChannelTokenAuthorizationDelegate
        .forPrivateChannel(
      authorizationEndpoint: Uri.parse(AppEndpoints.broadcastingAuthUrl),
      headers: _authHeaders,
    );

    final channel = client.privateChannel(
      channelName,
      authorizationDelegate: delegate,
    );
    channel.subscribe();

    final sub = channel.bindToAll().listen((event) {
      if (event.name.startsWith('pusher:')) return;
      onNewActivity();
    });

    _chatListeners[chatId] = _ChatListen(subscription: sub, channel: channel);
  }

  Future<void> unsubscribeChat(int chatId) async {
    final entry = _chatListeners.remove(chatId);
    if (entry == null) return;
    await entry.subscription.cancel();
    entry.channel.unsubscribe();
  }

  Future<void> disconnect() async {
    for (final id in _chatListeners.keys.toList()) {
      await unsubscribeChat(id);
    }
    if (_client != null) {
      try {
        await _client!.disconnect();
      } catch (_) {}
      if (!_client!.isDisposed) {
        _client!.dispose();
      }
      _client = null;
    }
  }
}
