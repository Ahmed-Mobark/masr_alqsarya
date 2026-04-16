import 'package:dio/dio.dart';
import 'package:masr_al_qsariya/core/config/app_end_points.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/features/auth/data/models/register_response_model.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/register_usecase.dart';

abstract class AuthRemoteDataSource {
  Future<RegisterResponseModel> register(RegisterParams params);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._api);

  final ApiBaseHelper _api;

  @override
  Future<RegisterResponseModel> register(RegisterParams params) async {
    final response = await _api.post<Map<String, dynamic>>(
      url: AppEndpoints.authRegister,
      formData: FormData.fromMap(
        {
          'first_name': params.firstName,
          'last_name': params.lastName,
          'phone': params.phone,
          'email': params.email,
          'date_of_birth': params.dateOfBirth,
          'device_name': params.deviceName,
          'type': params.type,
          'password': params.password,
          'password_confirmation': params.passwordConfirmation,
        }..removeWhere((key, value) => value == null || value == ''),
      ),
    );

    return RegisterResponseModel.fromJson(response);
  }
}
