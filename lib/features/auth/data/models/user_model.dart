import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';
import 'role_model.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: 'Id')
  final String id;
  
  @JsonKey(name: 'Role')
  final List<RoleModel> role;
  
  @JsonKey(name: 'Username')
  final String username;
  
  @JsonKey(name: 'FullName')
  final String fullName;
  
  @JsonKey(name: 'Mail')
  final String mail;

  const UserModel({
    required this.id,
    required this.role,
    required this.username,
    required this.fullName,
    required this.mail,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  User toEntity() {
    return User(
      id: id,
      email: mail,
      name: fullName,
      phoneNumber: null,
      profileImageUrl: null,
      isEmailVerified: true,
      isBiometricEnabled: false,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
      username: username,
      roles: role.map((r) => r.nama).toList(),
    );
  }
}
