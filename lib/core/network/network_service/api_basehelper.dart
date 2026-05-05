import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:masr_al_qsariya/core/config/app_end_points.dart';
import 'package:flutter/foundation.dart';
import 'package:masr_al_qsariya/core/config/map_end_points.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/network/network_service/error_helper.dart';
import 'package:masr_al_qsariya/core/network/network_service/exceptions.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';

enum ApiEnvironment {primary, secondary, map}

class ApiBaseHelper {
  static String primaryBaseUrl = AppEndpoints.baseUrl;
  static String secondaryBaseUrl = AppEndpoints.baseUrl;
  static String mapBaseUrl = MapEndpoints.baseUrl;

  /// Debug-only escape hatch for misconfigured HTTPS certificates.
  ///
  /// Enable ONLY for local dev:
  /// `--dart-define=ALLOW_BAD_CERTS=true`
  static const bool _allowBadCerts =
      bool.fromEnvironment('ALLOW_BAD_CERTS', defaultValue: false);

  
  static final ApiBaseHelper _instance = ApiBaseHelper._internal();
  final Map<ApiEnvironment, Dio> _dioInstances = {};

  factory ApiBaseHelper({Dio? dio, ApiEnvironment environment = ApiEnvironment.primary}) {
    if (dio != null) {_instance._dioInstances[environment] = dio;}
    else {_instance._initializeDio(environment);}
    return _instance;
  }

  ApiBaseHelper._internal();

  void _initializeDio(ApiEnvironment environment) {
    final baseUrl = _getBaseUrl(environment);
    final dio = Dio(
      BaseOptions(baseUrl: baseUrl, headers: _defaultHeaders()),
    )..interceptors.add(PrettyDioLogger(
      requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
        enabled: kDebugMode,
    ));

    // If your backend certificate is broken (e.g. hostname mismatch), this
    // allows development to continue. Never enable in release builds.
    if (kDebugMode && _allowBadCerts) {
      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.badCertificateCallback = (cert, host, port) => true;
          return client;
        },
      );
    }

    _dioInstances[environment] = dio;
  }

  String _getBaseUrl(ApiEnvironment environment) => switch(environment) {
    ApiEnvironment.primary => primaryBaseUrl,
    ApiEnvironment.secondary => secondaryBaseUrl,
    ApiEnvironment.map => mapBaseUrl,
  };

  Dio getDio(ApiEnvironment environment) {
    if (!_dioInstances.containsKey(environment)) {_initializeDio(environment);}
    return _dioInstances[environment]!;
  }

  void updateLocaleInHeaders(String locale, {ApiEnvironment? environment}) {
    if (environment != null) {
      getDio(environment).options.headers['Accept-Language'] = locale;
      getDio(environment).options.headers['X-Locale'] = locale;
    } else {
      for (var dio in _dioInstances.values) {
        dio.options.headers['Accept-Language'] = locale;
        dio.options.headers['X-Locale'] = locale;
      }
    }
  }

  static Map<String, String> _defaultHeaders() {
    final lang = sl<Storage>().getLang();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'app-type': 'client',
      'Accept-Language': lang,
      'X-Locale': lang,
    };
  }

  Future<T> _performRequest<T>(Future<Response<T>> Function() request, {required ApiEnvironment environment}) async {
    try {
      final dio = getDio(environment);
      String? token = sl<Storage>().getToken();
      if(token != null) {dio.options.headers['Authorization'] = 'Bearer $token';}
      final response = await request();
      final data = response.data;
      if (data == null) {
        // Common for 204 No Content endpoints (e.g. logout).
        if (null is T) return null as T;
        throw AppException('Empty response');
      }
      return data;
    } on DioException catch (e) {
      log(
        'DioException error: ${e.type} - ${e.message} '
        '(uri=${e.requestOptions.uri}, method=${e.requestOptions.method}, '
        'underlying=${e.error})',
      );
      throw ErrorHelper.handleDioError(e);
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      log('Unexpected error: $e');
      throw AppException('Unexpected error occurred');
    }
  }


  Future<T> get<T>({required String url, Map<String, dynamic>? queryParameters, Map<String, dynamic>? body, ApiEnvironment environment = ApiEnvironment.primary}) async {
    return _performRequest<T>(() => getDio(environment).get<T>(url, queryParameters: queryParameters, data: body), environment: environment);
  }

  /// Authenticated GET returning raw bytes (e.g. chat attachment download).
  Future<Uint8List> getBytes({
    required String url,
    ApiEnvironment environment = ApiEnvironment.primary,
  }) async {
    try {
      final dio = getDio(environment);
      final token = sl<Storage>().getToken();
      if (token != null) {
        dio.options.headers['Authorization'] = 'Bearer $token';
      }
      final response = await dio.get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          headers: {'Accept': '*/*'},
        ),
      );
      final code = response.statusCode;
      if (code == null || code < 200 || code >= 300) {
        throw ServerException(message: 'Download failed (${code ?? 'unknown'})');
      }
      final data = response.data;
      if (data == null) {
        throw AppException('Empty download response');
      }
      return data is Uint8List ? data : Uint8List.fromList(data);
    } on DioException catch (e) {
      log('DioException error: ${e.type} - ${e.message}');
      throw ErrorHelper.handleDioError(e);
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      log('Unexpected error: $e');
      if (e is ServerException ||
          e is NetworkException ||
          e is AppException) {
        rethrow;
      }
      throw AppException('Unexpected error occurred');
    }
  }

  Future<T> post<T>({required String url, Map<String, dynamic>? body, FormData? formData, Options? options, ApiEnvironment environment = ApiEnvironment.primary}) async {
    return _performRequest<T>(() => getDio(environment).post<T>(url, data: formData ?? body, options: options),environment: environment,);
  }

  Future<T> put<T>({required String url, Map<String, dynamic>? body, FormData? formData, Options? options, ApiEnvironment environment = ApiEnvironment.primary}) async {
    return _performRequest<T>(() => getDio(environment).put<T>(url, data: formData ?? body, options: options), environment: environment,);
  }

  Future<T> patch<T>({required String url, Map<String, dynamic>? body, FormData? formData, Options? options, ApiEnvironment environment = ApiEnvironment.primary}) async {
    return _performRequest<T>(() => getDio(environment).patch<T>(url, data: formData ?? body, options: options), environment: environment,);
  }

  Future<T> delete<T>({
    required String url,
    Map<String, dynamic>? body,
    FormData? formData,
    Options? options,
    ApiEnvironment environment = ApiEnvironment.primary,
  }) async {
    return _performRequest<T>(
      () => getDio(environment).delete<T>(
        url,
        data: formData ?? body,
        options: options,
      ),
      environment: environment,
    );
  }
}