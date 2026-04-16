import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/auth/domain/entities/register_response.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/register_usecase.dart';

abstract class AuthRepository {
  Future<Either<Failure, RegisterResponse>> register(RegisterParams params);
}
