import 'package:masr_al_qsariya/features/auth/domain/entities/user_profile.dart';

class UserProfileModel {
  const UserProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.type,
    this.dateOfBirth,
  });

  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? type;
  final String? dateOfBirth;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final dataMap = data is Map<String, dynamic> ? data : <String, dynamic>{};

    return UserProfileModel(
      id: (dataMap['id'] as num?)?.toInt() ?? 0,
      firstName: (dataMap['first_name'] as String?) ?? '',
      lastName: (dataMap['last_name'] as String?) ?? '',
      email: (dataMap['email'] as String?) ?? '',
      phone: dataMap['phone'] as String?,
      type: dataMap['type'] as String?,
      dateOfBirth: dataMap['date_of_birth'] as String?,
    );
  }

  UserProfile toEntity() => UserProfile(
        id: id,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        type: type,
        dateOfBirth: dateOfBirth,
      );
}
