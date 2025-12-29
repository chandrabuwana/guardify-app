// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_update_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceUpdateRequestModel _$AttendanceUpdateRequestModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'AttendanceUpdateRequestModel',
      json,
      ($checkedConvert) {
        final val = AttendanceUpdateRequestModel(
          idAttendance: $checkedConvert('IdAttendance', (v) => v as String),
          photoAbsen: $checkedConvert(
              'PhotoAbsen',
              (v) => v == null
                  ? null
                  : PhotoInfoModel.fromJson(v as Map<String, dynamic>)),
          photoPengamanan: $checkedConvert(
              'PhotoPengamanan',
              (v) => v == null
                  ? null
                  : PhotoInfoModel.fromJson(v as Map<String, dynamic>)),
          laporan: $checkedConvert('Laporan', (v) => v as String?),
          isOvertime: $checkedConvert('IsOvertime', (v) => v as bool?),
          photoOvertime: $checkedConvert(
              'PhotoOvertime',
              (v) => v == null
                  ? null
                  : PhotoInfoModel.fromJson(v as Map<String, dynamic>)),
          token: $checkedConvert(
              'Token', (v) => TokenModel.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {
        'idAttendance': 'IdAttendance',
        'photoAbsen': 'PhotoAbsen',
        'photoPengamanan': 'PhotoPengamanan',
        'laporan': 'Laporan',
        'isOvertime': 'IsOvertime',
        'photoOvertime': 'PhotoOvertime',
        'token': 'Token'
      },
    );

Map<String, dynamic> _$AttendanceUpdateRequestModelToJson(
        AttendanceUpdateRequestModel instance) =>
    <String, dynamic>{
      'IdAttendance': instance.idAttendance,
      'PhotoAbsen': instance.photoAbsen?.toJson(),
      'PhotoPengamanan': instance.photoPengamanan?.toJson(),
      'Laporan': instance.laporan,
      'IsOvertime': instance.isOvertime,
      'PhotoOvertime': instance.photoOvertime?.toJson(),
      'Token': instance.token.toJson(),
    };

PhotoInfoModel _$PhotoInfoModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PhotoInfoModel',
      json,
      ($checkedConvert) {
        final val = PhotoInfoModel(
          filename: $checkedConvert('Filename', (v) => v as String),
          mimeType: $checkedConvert('MimeType', (v) => v as String),
          base64: $checkedConvert('Base64', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'filename': 'Filename',
        'mimeType': 'MimeType',
        'base64': 'Base64'
      },
    );

Map<String, dynamic> _$PhotoInfoModelToJson(PhotoInfoModel instance) =>
    <String, dynamic>{
      'Filename': instance.filename,
      'MimeType': instance.mimeType,
      'Base64': instance.base64,
    };

TokenModel _$TokenModelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'TokenModel',
      json,
      ($checkedConvert) {
        final val = TokenModel(
          id: $checkedConvert('Id', (v) => v as String),
          role: $checkedConvert(
              'Role',
              (v) => (v as List<dynamic>)
                  .map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
          username: $checkedConvert('Username', (v) => v as String),
          fullName: $checkedConvert('FullName', (v) => v as String),
          mail: $checkedConvert('Mail', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'role': 'Role',
        'username': 'Username',
        'fullName': 'FullName',
        'mail': 'Mail'
      },
    );

Map<String, dynamic> _$TokenModelToJson(TokenModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Role': instance.role.map((e) => e.toJson()).toList(),
      'Username': instance.username,
      'FullName': instance.fullName,
      'Mail': instance.mail,
    };
