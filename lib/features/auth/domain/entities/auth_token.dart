class AuthToken {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final DateTime issuedAt;

  const AuthToken({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    required this.issuedAt,
  });

  bool get isExpired {
    final expiryTime = issuedAt.add(Duration(seconds: expiresIn));
    return DateTime.now().isAfter(expiryTime);
  }

  bool get willExpireSoon {
    final expiryTime = issuedAt.add(Duration(seconds: expiresIn));
    final warningTime = expiryTime.subtract(const Duration(minutes: 5));
    return DateTime.now().isAfter(warningTime);
  }

  AuthToken copyWith({
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    int? expiresIn,
    DateTime? issuedAt,
  }) {
    return AuthToken(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenType: tokenType ?? this.tokenType,
      expiresIn: expiresIn ?? this.expiresIn,
      issuedAt: issuedAt ?? this.issuedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthToken &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken &&
        other.tokenType == tokenType &&
        other.expiresIn == expiresIn &&
        other.issuedAt == issuedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      accessToken,
      refreshToken,
      tokenType,
      expiresIn,
      issuedAt,
    );
  }

  @override
  String toString() {
    return 'AuthToken(accessToken: ${accessToken.substring(0, 20)}..., refreshToken: ${refreshToken.substring(0, 20)}..., tokenType: $tokenType, expiresIn: $expiresIn, issuedAt: $issuedAt)';
  }
}
