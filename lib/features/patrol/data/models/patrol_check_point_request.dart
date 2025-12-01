import 'package:json_annotation/json_annotation.dart';
import '../../../auth/data/models/role_model.dart';

part 'patrol_check_point_request.g.dart';

@JsonSerializable()
class PhotoPatroliModel {
  @JsonKey(name: 'Filename')
  final String filename;

  @JsonKey(name: 'MimeType')
  final String mimeType;

  @JsonKey(name: 'Base64')
  final String base64;

  PhotoPatroliModel({
    required this.filename,
    required this.mimeType,
    required this.base64,
  });

  factory PhotoPatroliModel.fromJson(Map<String, dynamic> json) =>
      _$PhotoPatroliModelFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoPatroliModelToJson(this);
}

@JsonSerializable()
class TokenModel {
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

  TokenModel({
    required this.id,
    required this.role,
    required this.username,
    required this.fullName,
    required this.mail,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) =>
      _$TokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokenModelToJson(this);
}

@JsonSerializable()
class PatrolCheckPointRequest {
  @JsonKey(name: 'IdShiftDetail')
  final String idShiftDetail;

  @JsonKey(name: 'PhotoPatroli')
  final PhotoPatroliModel? photoPatroli;

  @JsonKey(name: 'IdAreas')
  final String idAreas;

  @JsonKey(name: 'DeviceName')
  final String deviceName;

  @JsonKey(name: 'Latitude')
  final double latitude;

  @JsonKey(name: 'Longitude')
  final double longitude;

  @JsonKey(name: 'Token')
  final TokenModel token;

  PatrolCheckPointRequest({
    required this.idShiftDetail,
    this.photoPatroli,
    required this.idAreas,
    required this.deviceName,
    required this.latitude,
    required this.longitude,
    required this.token,
  });

  factory PatrolCheckPointRequest.fromJson(Map<String, dynamic> json) =>
      _$PatrolCheckPointRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PatrolCheckPointRequestToJson(this);
}

