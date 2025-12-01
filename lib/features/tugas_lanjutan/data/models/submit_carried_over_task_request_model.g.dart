// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_carried_over_task_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmitCarriedOverTaskRequestModel _$SubmitCarriedOverTaskRequestModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'SubmitCarriedOverTaskRequestModel',
      json,
      ($checkedConvert) {
        final val = SubmitCarriedOverTaskRequestModel(
          id: $checkedConvert('Id', (v) => v as String),
          notes: $checkedConvert('Notes', (v) => v as String?),
          file: $checkedConvert(
              'File',
              (v) => v == null
                  ? null
                  : FileModel.fromJson(v as Map<String, dynamic>)),
          token: $checkedConvert(
              'Token', (v) => TokenModel.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'notes': 'Notes',
        'file': 'File',
        'token': 'Token'
      },
    );

Map<String, dynamic> _$SubmitCarriedOverTaskRequestModelToJson(
        SubmitCarriedOverTaskRequestModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Notes': instance.notes,
      'File': instance.file?.toJson(),
      'Token': instance.token.toJson(),
    };

FileModel _$FileModelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'FileModel',
      json,
      ($checkedConvert) {
        final val = FileModel(
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

Map<String, dynamic> _$FileModelToJson(FileModel instance) => <String, dynamic>{
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
                  .map((e) => RoleItemModel.fromJson(e as Map<String, dynamic>))
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

RoleItemModel _$RoleItemModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'RoleItemModel',
      json,
      ($checkedConvert) {
        final val = RoleItemModel(
          id: $checkedConvert('Id', (v) => v as String),
          nama: $checkedConvert('Nama', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'id': 'Id', 'nama': 'Nama'},
    );

Map<String, dynamic> _$RoleItemModelToJson(RoleItemModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Nama': instance.nama,
    };
