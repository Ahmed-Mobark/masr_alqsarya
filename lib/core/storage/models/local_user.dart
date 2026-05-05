import 'dart:convert';

class LocalUser {
  const LocalUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.type,
    this.permissions = const [],
    this.imageUrl,
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
  final List<String> permissions;
  final String? imageUrl;
  final bool isVerified;
  final String? emailVerifiedAt;
  final String? createdAt;
  final String? updatedAt;

  String get fullName => '${firstName.trim()} ${lastName.trim()}'.trim();

  Map<String, dynamic> toMap() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
        'type': type,
        'permissions': permissions,
        'image_url': imageUrl,
        'is_verified': isVerified,
        'email_verified_at': emailVerifiedAt,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  factory LocalUser.fromMap(Map<String, dynamic> map) => LocalUser(
        id: (map['id'] as num?)?.toInt() ?? 0,
        firstName: (map['first_name'] as String?) ?? '',
        lastName: (map['last_name'] as String?) ?? '',
        email: (map['email'] as String?) ?? '',
        phone: map['phone'] as String?,
        type: map['type'] as String?,
        permissions: (map['permissions'] as List?)
                ?.map((e) => e.toString().trim())
                .where((e) => e.isNotEmpty)
                .toList(growable: false) ??
            const [],
        imageUrl: map['image_url'] as String?,
        isVerified: (map['is_verified'] as bool?) ?? false,
        emailVerifiedAt: map['email_verified_at'] as String?,
        createdAt: map['created_at'] as String?,
        updatedAt: map['updated_at'] as String?,
      );

  String toJson() => jsonEncode(toMap());

  factory LocalUser.fromJson(String source) {
    final decoded = jsonDecode(source);
    final map = decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
    return LocalUser.fromMap(map);
  }

  bool get isMotherOrFather {
    final t = type?.trim().toLowerCase();
    return t == 'mother' || t == 'father';
  }

  bool hasPermission(String permission) {
    if (isMotherOrFather) return true;
    final key = permission.trim().toLowerCase();
    if (key.isEmpty) return true;
    for (final p in permissions) {
      if (p.trim().toLowerCase() == key) return true;
    }
    return false;
  }
}

