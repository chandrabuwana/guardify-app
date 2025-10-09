import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/auth_token.dart';

part 'auth_token_model.g.dart';

@JsonSerializable()
class AuthTokenModel {
  @JsonKey(name: 'RawToken')
  final String rawToken;
  
  @JsonKey(name: 'RefreshToken')
  final String refreshToken;
  
  @JsonKey(name: 'ExpiredAt')
  final String expiredAt;

  const AuthTokenModel({
    required this.rawToken,
    required this.refreshToken,
    required this.expiredAt,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthTokenModelToJson(this);

  AuthToken toEntity() {
    final expiresAtDate = DateTime.parse(expiredAt);
    final now = DateTime.now();
    final expiresInSeconds = expiresAtDate.difference(now).inSeconds;
    
    return AuthToken(
      accessToken: rawToken,
      refreshToken: refreshToken,
      tokenType: 'Bearer',
      expiresIn: expiresInSeconds > 0 ? expiresInSeconds : 3600,
      issuedAt: now,
    );
  }
}
