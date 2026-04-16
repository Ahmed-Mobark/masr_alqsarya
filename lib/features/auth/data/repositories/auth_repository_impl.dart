import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/core/network/network_service/repository_helper.dart';
import 'package:masr_al_qsariya/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:masr_al_qsariya/features/auth/domain/entities/register_response.dart';
import 'package:masr_al_qsariya/features/auth/domain/repositories/auth_repository.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/register_usecase.dart';

class AuthRepositoryImpl with RepositoryHelper implements AuthRepository {
  const AuthRepositoryImpl(this._remote);

  final AuthRemoteDataSource _remote;

  @override
  Future<Either<Failure, RegisterResponse>> register(RegisterParams params) {
    return handleEither(() async {
      final model = await _remote.register(params);
      return model.toEntity();
    });
  }
}
