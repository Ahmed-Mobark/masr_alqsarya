import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/core/network/network_service/failures.dart';
import 'package:masr_al_qsariya/features/auth/domain/repositories/auth_repository.dart';

class AddChildUseCase {
  const AddChildUseCase(this._repo);

  final AuthRepository _repo;

  Future<Either<Failure, void>> call(AddChildParams params) {
    return _repo.addChild(params);
  }
}

/// Payload for `POST /family-workspace/add-child` (multipart). **Only** these six fields.
class AddChildParams extends Equatable {
  const AddChildParams({
    required this.displayName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
  });

  final String displayName;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String dateOfBirth;

  @override
  List<Object?> get props => [
        displayName,
        firstName,
        lastName,
        email,
        phone,
        dateOfBirth,
      ];
}
