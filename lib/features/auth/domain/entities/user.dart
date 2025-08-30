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
        other.lastLoginAt == lastLoginAt;
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
    );
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, phoneNumber: $phoneNumber, profileImageUrl: $profileImageUrl, isEmailVerified: $isEmailVerified, isBiometricEnabled: $isBiometricEnabled, createdAt: $createdAt, lastLoginAt: $lastLoginAt)';
  }
}
