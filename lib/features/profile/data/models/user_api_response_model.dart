import 'package:json_annotation/json_annotation.dart';
import 'profile_user_model.dart';

part 'user_api_response_model.g.dart';

/// Model untuk role dari API
@JsonSerializable()
class RoleApiModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Nama')
  final String nama;

  const RoleApiModel({
    required this.id,
    required this.nama,
  });

  factory RoleApiModel.fromJson(Map<String, dynamic> json) =>
      _$RoleApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoleApiModelToJson(this);
}

/// Model untuk data user dari API
@JsonSerializable()
class UserApiDataModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Username')
  final String username;

  @JsonKey(name: 'Fullname')
  final String fullname;

  @JsonKey(name: 'Mail')
  final String mail;

  @JsonKey(name: 'Token')
  final String token;

  @JsonKey(name: 'PhoneNumber')
  final String phoneNumber;

  @JsonKey(name: 'Status')
  final String status;

  @JsonKey(name: 'AccessFailedCount')
  final int accessFailedCount;

  @JsonKey(name: 'Roles')
  final List<RoleApiModel> roles;

  @JsonKey(name: 'LastSynchronize')
  final String lastSynchronize;

  @JsonKey(name: 'CreateBy')
  final String createBy;

  @JsonKey(name: 'CreateDate')
  final String createDate;

  @JsonKey(name: 'UpdateBy')
  final String updateBy;

  @JsonKey(name: 'UpdateDate')
  final String updateDate;

  const UserApiDataModel({
    required this.id,
    required this.username,
    required this.fullname,
    required this.mail,
    required this.token,
    required this.phoneNumber,
    required this.status,
    required this.accessFailedCount,
    required this.roles,
    required this.lastSynchronize,
    required this.createBy,
    required this.createDate,
    required this.updateBy,
    required this.updateDate,
  });

  factory UserApiDataModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiDataModelToJson(this);

  /// Convert to ProfileUserModel
  /// Note: API ini hanya return basic info, jadi field lain menggunakan placeholder
  ProfileUserModel toProfileUserModel() {
    return ProfileUserModel(
      id: id,
      nrp: username, // Menggunakan username sebagai NRP
      noKtp: '', // Tidak ada di API response
      name: fullname,
      tempatLahir: '', // Tidak ada di API response
      tanggalLahir: DateTime.now(), // Placeholder
      jenisKelamin: '', // Tidak ada di API response
      pendidikan: '', // Tidak ada di API response
      teleponPribadi: phoneNumber,
      teleponDarurat: '', // Tidak ada di API response
      site: '', // Tidak ada di API response
      jabatan: roles.isNotEmpty ? roles.first.nama : '', // Menggunakan role sebagai jabatan
      atasan: '', // Tidak ada di API response
      tglPenerimaanKaryawan: DateTime.parse(createDate),
      masaBerlakuPermit: DateTime.now().add(const Duration(days: 365)), // Placeholder
      kompetensiPekerjaan: '', // Tidak ada di API response
      wargaNegara: '', // Tidak ada di API response
      provinsi: '', // Tidak ada di API response
      kotaKabupaten: '', // Tidak ada di API response
      kecamatan: '', // Tidak ada di API response
      kelurahan: '', // Tidak ada di API response
      alamatDomisili: '', // Tidak ada di API response
      profileImageUrl: null,
      documents: null,
    );
  }
}

/// Model untuk response dari User API
@JsonSerializable()
class UserApiResponseModel {
  @JsonKey(name: 'Data')
  final UserApiDataModel? data;

  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String message;

  @JsonKey(name: 'Description')
  final String description;

  const UserApiResponseModel({
    this.data,
    required this.code,
    required this.succeeded,
    required this.message,
    required this.description,
  });

  factory UserApiResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiResponseModelToJson(this);
}
