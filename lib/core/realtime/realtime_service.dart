import 'dart:async';
import 'dart:developer' as developer;

import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:flutter/foundation.dart';
import 'package:masr_al_qsariya/core/config/app_end_points.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/core/realtime/laravel_broadcasting_auth_delegate.dart';
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

  void _log(String message, [Object? error, StackTrace? stack]) {
    if (kDebugMode) {
      developer.log(
        message,
        name: 'RealtimeService',
        error: error,
        stackTrace: stack,
      );
    }
  }

  Future<void> ensureConnected() async {
    if (_storage.getToken() == null) return;

    if (_client != null && !_client!.isDisposed) {
      await _client!.connect();
      return;
    }

    _client = PusherChannelsClient.websocket(
      options: _options,
      connectionErrorHandler: (exception, trace, refresh) {
        _log('WebSocket connection error', exception, trace);
        refresh();
      },
      minimumReconnectDelayDuration: const Duration(seconds: 2),
    );
    try {
      await _client!.connect();
      _log('WebSocket connected: ${_options.uri}');
    } catch (e, st) {
      _log('WebSocket connect failed', e, st);
      rethrow;
    }
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
    final authUri = Uri.parse(AppEndpoints.broadcastingAuthUrl);
    final delegate = LaravelBroadcastingAuthDelegate(
      dio: sl<ApiBaseHelper>().getDio(ApiEnvironment.primary),
      storage: _storage,
      authorizationEndpoint: authUri,
    );

    _log('Subscribing $channelName (auth: $authUri)');

    final channel = client.privateChannel(
      channelName,
      authorizationDelegate: delegate,
    );
    try {
      // [PrivateChannel.subscribe] is `async void` — awaiting outcome via events.
      await _awaitPrivateChannelSubscription(channel, channelName);
    } catch (e, st) {
      _log('subscribePrivateChat failed for $channelName', e, st);
      rethrow;
    }

    final sub = channel.bindToAll().listen(
      (event) {
        if (event.name.startsWith('pusher:')) return;
        _log('Realtime event: ${event.name}');
        onNewActivity();
      },
      onError: (Object e, StackTrace st) {
        _log('Channel stream error ($channelName)', e, st);
      },
    );

    _chatListeners[chatId] = _ChatListen(subscription: sub, channel: channel);
  }

  /// Waits until the private channel is subscribed or a subscription/auth error is emitted.
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
      final msg = map?[PusherChannelsEvent.errorKey]?.toString() ??
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
          '(check /broadcasting/auth JSON and Soketi WebSocket).',
        ),
      );
      _log('Subscribed $channelName');
    } finally {
      await subOk.cancel();
      await subErr.cancel();
    }
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
