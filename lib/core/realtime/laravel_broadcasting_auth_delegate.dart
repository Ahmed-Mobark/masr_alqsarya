import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:dio/dio.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';

/// Laravel / Soketi private-channel auth via the same headers as [ApiBaseHelper].
///
/// Parses either `{"auth":"..."}` or a wrapped API shape `{"data":{"auth":"..."}}`.
///
/// **Backend requirement:** `POST` [broadcastingAuthUrl] must authenticate the
/// Bearer token (e.g. `Broadcast::routes(['middleware' => ['auth:sanctum']])`)
/// and return JSON containing `auth`, not an empty HTML page.
class LaravelBroadcastingAuthDelegate
    implements
        EndpointAuthorizableChannelAuthorizationDelegate<
            PrivateChannelAuthorizationData> {
  LaravelBroadcastingAuthDelegate({
    required this.dio,
    required this.storage,
    required this.authorizationEndpoint,
  });

  final Dio dio;
  final Storage storage;
  final Uri authorizationEndpoint;

  @override
  EndpointAuthFailedCallback? get onAuthFailed => null;

  @override
  Future<PrivateChannelAuthorizationData> authorizationData(
    String socketId,
    String channelName,
  ) async {
    final token = storage.getToken();
    final lang = storage.getLang();

    final response = await dio.post<dynamic>(
      authorizationEndpoint.toString(),
      data: {
        'socket_id': socketId,
        'channel_name': channelName,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        // Don't let Dio throw on non-2xx; we want to surface server body.
        validateStatus: (_) => true,
        headers: {
          'Accept': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
          'app-type': 'client',
          'Accept-Language': lang,
          'X-Locale': lang,
        },
      ),
    );

    final status = response.statusCode ?? 0;
    if (status != 200) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Broadcasting auth HTTP $status — body: ${response.data}',
      );
    }

    final authKey = _extractAuthKey(response.data);
    if (authKey == null || authKey.isEmpty) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Broadcasting auth: missing "auth" in JSON body. '
            'Use auth:sanctum on broadcasting routes. Raw: ${response.data}',
      );
    }

    return PrivateChannelAuthorizationData(authKey: authKey);
  }
}

String? _extractAuthKey(dynamic raw) {
  if (raw == null) return null;

  Map<String, dynamic>? map;
  if (raw is Map<String, dynamic>) {
    map = raw;
  } else if (raw is Map) {
    map = Map<String, dynamic>.from(raw);
  }
  if (map == null) return null;

  final direct = map['auth'];
  if (direct is String && direct.isNotEmpty) return direct;

  final data = map['data'];
  if (data is Map) {
    final nested = data['auth'];
    if (nested is String && nested.isNotEmpty) return nested;
  }
  return null;
}
