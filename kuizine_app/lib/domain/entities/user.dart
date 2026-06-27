/// User entity for KUIZINE
class User {
  final int id;
  final String phone;
  final String? fullName;
  final String? address;
  final String? quarter;
  final UserRole role;
  final bool isVerified;
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.phone,
    this.fullName,
    this.address,
    this.quarter,
    this.role = UserRole.client,
    this.isVerified = false,
    this.createdAt,
  });

  /// Check if profile is complete
  bool get isProfileComplete =>
      fullName != null && fullName!.isNotEmpty &&
      address != null && address!.isNotEmpty;

  /// Check if user is admin
  bool get isAdmin => role == UserRole.admin;

  /// Display name or phone number
  String get displayName => fullName ?? phone;

  /// Initials for avatar
  String get initials {
    if (fullName == null || fullName!.isEmpty) return '?';
    final parts = fullName!.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fullName![0].toUpperCase();
  }

  User copyWith({
    String? fullName,
    String? address,
    String? quarter,
    UserRole? role,
    bool? isVerified,
  }) {
    return User(
      id: id,
      phone: phone,
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      quarter: quarter ?? this.quarter,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      phone: json['phone'] as String,
      fullName: json['full_name'] as String?,
      address: json['address'] as String?,
      quarter: json['quarter'] as String?,
      role: UserRole.fromString(json['role'] as String? ?? 'CLIENT'),
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'full_name': fullName,
      'address': address,
      'quarter': quarter,
      'role': role.value,
      'is_verified': isVerified,
    };
  }
}

/// User role enum
enum UserRole {
  client('CLIENT', 'Client'),
  admin('ADMIN', 'Administrateur'),
  delivery('DELIVERY', 'Livreur');

  final String value;
  final String label;

  const UserRole(this.value, this.label);

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (e) => e.value == value.toUpperCase(),
      orElse: () => UserRole.client,
    );
  }
}
