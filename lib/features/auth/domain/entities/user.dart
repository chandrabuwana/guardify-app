class User {
  final String id;
  final String email;
  final String name;
  final String? phoneNumber;
  final String? profileImageUrl;
  final bool isEmailVerified;
  final bool isBiometricEnabled;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final String? username;
  final List<String>? roles;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    this.profileImageUrl,
    required this.isEmailVerified,
    required this.isBiometricEnabled,
    required this.createdAt,
    this.lastLoginAt,
    this.username,
    this.roles,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
    bool? isEmailVerified,
    bool? isBiometricEnabled,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    String? username,
    List<String>? roles,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      username: username ?? this.username,
      roles: roles ?? this.roles,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.phoneNumber == phoneNumber &&
        other.profileImageUrl == profileImageUrl &&
        other.isEmailVerified == isEmailVerified &&
        other.isBiometricEnabled == isBiometricEnabled &&
        other.createdAt == createdAt &&
        other.lastLoginAt == lastLoginAt &&
        other.username == username;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      email,
      name,
      phoneNumber,
      profileImageUrl,
      isEmailVerified,
      isBiometricEnabled,
      createdAt,
      lastLoginAt,
      username,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, phoneNumber: $phoneNumber, profileImageUrl: $profileImageUrl, isEmailVerified: $isEmailVerified, isBiometricEnabled: $isBiometricEnabled, createdAt: $createdAt, lastLoginAt: $lastLoginAt, username: $username, roles: $roles)';
  }
}
