import 'package:json_annotation/json_annotation.dart';
import '../../../auth/data/models/role_model.dart';

part 'attendance_update_request_model.g.dart';

@JsonSerializable()
class AttendanceUpdateRequestModel {
  @JsonKey(name: 'IdAttendance')
  final String idAttendance;

  @JsonKey(name: 'PhotoAbsen')
  final PhotoInfoModel? photoAbsen;

  @JsonKey(name: 'PhotoPengamanan')
  final PhotoInfoModel? photoPengamanan;

  @JsonKey(name: 'Laporan')
  final String? laporan;

  @JsonKey(name: 'IsOvertime')
  final bool? isOvertime;

  @JsonKey(name: 'PhotoOvertime')
  final PhotoInfoModel? photoOvertime;

  @JsonKey(name: 'Token')
  final TokenModel token;

  const AttendanceUpdateRequestModel({
    required this.idAttendance,
    this.photoAbsen,
    this.photoPengamanan,
    this.laporan,
    this.isOvertime,
    this.photoOvertime,
    required this.token,
  });

  factory AttendanceUpdateRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceUpdateRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceUpdateRequestModelToJson(this);
}

@JsonSerializable()
class PhotoInfoModel {
  @JsonKey(name: 'Filename')
  final String filename;

  @JsonKey(name: 'MimeType')
  final String mimeType;

  @JsonKey(name: 'Base64')
  final String base64;

  const PhotoInfoModel({
    required this.filename,
    required this.mimeType,
    required this.base64,
  });

  factory PhotoInfoModel.fromJson(Map<String, dynamic> json) =>
      _$PhotoInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoInfoModelToJson(this);
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

  const TokenModel({
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

