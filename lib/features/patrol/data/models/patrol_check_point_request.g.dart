// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patrol_check_point_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotoPatroliModel _$PhotoPatroliModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PhotoPatroliModel',
      json,
      ($checkedConvert) {
        final val = PhotoPatroliModel(
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

Map<String, dynamic> _$PhotoPatroliModelToJson(PhotoPatroliModel instance) =>
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

PatrolCheckPointRequest _$PatrolCheckPointRequestFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'PatrolCheckPointRequest',
      json,
      ($checkedConvert) {
        final val = PatrolCheckPointRequest(
          idShiftDetail: $checkedConvert('IdShiftDetail', (v) => v as String),
          photoPatroli: $checkedConvert(
              'PhotoPatroli',
              (v) => v == null
                  ? null
                  : PhotoPatroliModel.fromJson(v as Map<String, dynamic>)),
          idAreas: $checkedConvert('IdAreas', (v) => v as String),
          deviceName: $checkedConvert('DeviceName', (v) => v as String),
          latitude: $checkedConvert('Latitude', (v) => (v as num).toDouble()),
          longitude: $checkedConvert('Longitude', (v) => (v as num).toDouble()),
          token: $checkedConvert(
              'Token', (v) => TokenModel.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {
        'idShiftDetail': 'IdShiftDetail',
        'photoPatroli': 'PhotoPatroli',
        'idAreas': 'IdAreas',
        'deviceName': 'DeviceName',
        'latitude': 'Latitude',
        'longitude': 'Longitude',
        'token': 'Token'
      },
    );

Map<String, dynamic> _$PatrolCheckPointRequestToJson(
        PatrolCheckPointRequest instance) =>
    <String, dynamic>{
      'IdShiftDetail': instance.idShiftDetail,
      'PhotoPatroli': instance.photoPatroli?.toJson(),
      'IdAreas': instance.idAreas,
      'DeviceName': instance.deviceName,
      'Latitude': instance.latitude,
      'Longitude': instance.longitude,
      'Token': instance.token.toJson(),
    };
