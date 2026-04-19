import 'package:dartz/dartz.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/core/network/network_service/repository_helper.dart';
import 'package:masr_al_qsariya/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:masr_al_qsariya/features/auth/domain/entities/login_response.dart';
import 'package:masr_al_qsariya/features/auth/domain/entities/register_response.dart';
import 'package:masr_al_qsariya/features/auth/domain/entities/user_profile.dart';
import 'package:masr_al_qsariya/features/auth/domain/entities/verify_email_response.dart';
import 'package:masr_al_qsariya/features/auth/domain/repositories/auth_repository.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/login_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/add_child_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/invite_co_partner_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/register_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/verify_email_usecase.dart';

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

  @override
  Future<Either<Failure, LoginResponse>> login(LoginParams params) {
    return handleEither(() async {
      final model = await _remote.login(params);
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, VerifyEmailResponse>> verifyEmail(
    VerifyEmailParams params,
  ) {
    return handleEither(() async {
      final model = await _remote.verifyEmail(params);
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> resendVerificationCode(String email) {
    return handleEither(() async {
      await _remote.resendVerificationCode(email);
    });
  }

  @override
  Future<Either<Failure, void>> logout() {
    return handleEither(() async {
      await _remote.logout();
    });
  }

  @override
  Future<Either<Failure, UserProfile>> getProfile() {
    return handleEither(() async {
      final model = await _remote.getProfile();
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> inviteCoPartner(InviteCoPartnerParams params) {
    return handleEither(() async {
      await _remote.inviteCoPartner(params);
    });
  }

  @override
  Future<Either<Failure, void>> addChild(AddChildParams params) {
    return handleEither(() async {
      await _remote.addChild(params);
    });
  }
}
