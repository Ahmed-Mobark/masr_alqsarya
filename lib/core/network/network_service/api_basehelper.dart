import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
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
    _dioInstances[environment] = Dio(
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
    if (environment != null) {getDio(environment).options.headers['Accept-Language'] = locale;}
    else {for (var dio in _dioInstances.values) {dio.options.headers['Accept-Language'] = locale;}}
  }

  static Map<String, String> _defaultHeaders() => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'app-type': 'client',
    'Accept-Language': sl<Storage>().getLang(),
  };

  Future<T> _performRequest<T>(Future<Response<T>> Function() request, {required ApiEnvironment environment}) async {
    try {
      final dio = getDio(environment);
      String? token = sl<Storage>().getToken();
      if(token != null) {dio.options.headers['Authorization'] = 'Bearer $token';}
      final response = await request();
      return response.data!;
    } on DioException catch (e) {
      log('DioException error: ${e.type} - ${e.message}');
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

  Future<T> post<T>({required String url, Map<String, dynamic>? body, FormData? formData, Options? options, ApiEnvironment environment = ApiEnvironment.primary}) async {
    return _performRequest<T>(() => getDio(environment).post<T>(url, data: formData ?? body, options: options),environment: environment,);
  }

  Future<T> put<T>({required String url, Map<String, dynamic>? body, FormData? formData, Options? options, ApiEnvironment environment = ApiEnvironment.primary}) async {
    return _performRequest<T>(() => getDio(environment).put<T>(url, data: formData ?? body, options: options), environment: environment,);
  }

  Future<T> patch<T>({required String url, Map<String, dynamic>? body, FormData? formData, Options? options, ApiEnvironment environment = ApiEnvironment.primary}) async {
    return _performRequest<T>(() => getDio(environment).patch<T>(url, data: formData ?? body, options: options), environment: environment,);
  }

  Future<T> delete<T>({required String url, Map<String, dynamic>? body, ApiEnvironment environment = ApiEnvironment.primary,}) async {
    return _performRequest<T>(() => getDio(environment).delete<T>(url, data: body), environment: environment);
  }
}