import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.type,
    this.dateOfBirth,
    this.isVerified = false,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? type;
  final String? dateOfBirth;
  final bool isVerified;
  final String? emailVerifiedAt;
  final String? createdAt;
  final String? updatedAt;

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phone,
        type,
        dateOfBirth,
        isVerified,
        emailVerifiedAt,
        createdAt,
        updatedAt,
      ];
}
