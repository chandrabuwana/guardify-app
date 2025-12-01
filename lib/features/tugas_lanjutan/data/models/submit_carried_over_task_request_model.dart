import 'package:json_annotation/json_annotation.dart';

part 'submit_carried_over_task_request_model.g.dart';

@JsonSerializable()
class SubmitCarriedOverTaskRequestModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Notes')
  final String? notes;

  @JsonKey(name: 'File')
  final FileModel? file;

  @JsonKey(name: 'Token')
  final TokenModel token;

  const SubmitCarriedOverTaskRequestModel({
    required this.id,
    this.notes,
    this.file,
    required this.token,
  });

  factory SubmitCarriedOverTaskRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SubmitCarriedOverTaskRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitCarriedOverTaskRequestModelToJson(this);
}

@JsonSerializable()
class FileModel {
  @JsonKey(name: 'Filename')
  final String filename;

  @JsonKey(name: 'MimeType')
  final String mimeType;

  @JsonKey(name: 'Base64')
  final String base64;

  const FileModel({
    required this.filename,
    required this.mimeType,
    required this.base64,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) =>
      _$FileModelFromJson(json);

  Map<String, dynamic> toJson() => _$FileModelToJson(this);
}

@JsonSerializable()
class TokenModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Role')
  final List<RoleItemModel> role;

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

@JsonSerializable()
class RoleItemModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Nama')
  final String nama;

  const RoleItemModel({
    required this.id,
    required this.nama,
  });

  factory RoleItemModel.fromJson(Map<String, dynamic> json) =>
      _$RoleItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoleItemModelToJson(this);
}

