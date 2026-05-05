import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/auth/domain/repositories/auth_repository.dart';

class DeleteAccountUseCase {
  const DeleteAccountUseCase(this._repo);

  final AuthRepository _repo;

  Future<Either<Failure, void>> call(DeleteAccountParams params) {
    return _repo.deleteAccount(params);
  }
}

class DeleteAccountParams extends Equatable {
  const DeleteAccountParams({required this.currentPassword});

  final String currentPassword;

  @override
  List<Object?> get props => [currentPassword];
}
