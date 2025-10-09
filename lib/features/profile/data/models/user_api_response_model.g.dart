// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoleApiModel _$RoleApiModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'RoleApiModel',
      json,
      ($checkedConvert) {
        final val = RoleApiModel(
          id: $checkedConvert('Id', (v) => v as String),
          nama: $checkedConvert('Nama', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'id': 'Id', 'nama': 'Nama'},
    );

Map<String, dynamic> _$RoleApiModelToJson(RoleApiModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Nama': instance.nama,
    };

UserApiDataModel _$UserApiDataModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UserApiDataModel',
      json,
      ($checkedConvert) {
        final val = UserApiDataModel(
          id: $checkedConvert('Id', (v) => v as String),
          username: $checkedConvert('Username', (v) => v as String),
          fullname: $checkedConvert('Fullname', (v) => v as String),
          mail: $checkedConvert('Mail', (v) => v as String),
          token: $checkedConvert('Token', (v) => v as String),
          phoneNumber: $checkedConvert('PhoneNumber', (v) => v as String),
          status: $checkedConvert('Status', (v) => v as String),
          accessFailedCount:
              $checkedConvert('AccessFailedCount', (v) => (v as num).toInt()),
          roles: $checkedConvert(
              'Roles',
              (v) => (v as List<dynamic>)
                  .map((e) => RoleApiModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
          lastSynchronize:
              $checkedConvert('LastSynchronize', (v) => v as String),
          createBy: $checkedConvert('CreateBy', (v) => v as String),
          createDate: $checkedConvert('CreateDate', (v) => v as String),
          updateBy: $checkedConvert('UpdateBy', (v) => v as String),
          updateDate: $checkedConvert('UpdateDate', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'username': 'Username',
        'fullname': 'Fullname',
        'mail': 'Mail',
        'token': 'Token',
        'phoneNumber': 'PhoneNumber',
        'status': 'Status',
        'accessFailedCount': 'AccessFailedCount',
        'roles': 'Roles',
        'lastSynchronize': 'LastSynchronize',
        'createBy': 'CreateBy',
        'createDate': 'CreateDate',
        'updateBy': 'UpdateBy',
        'updateDate': 'UpdateDate'
      },
    );

Map<String, dynamic> _$UserApiDataModelToJson(UserApiDataModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Username': instance.username,
      'Fullname': instance.fullname,
      'Mail': instance.mail,
      'Token': instance.token,
      'PhoneNumber': instance.phoneNumber,
      'Status': instance.status,
      'AccessFailedCount': instance.accessFailedCount,
      'Roles': instance.roles.map((e) => e.toJson()).toList(),
      'LastSynchronize': instance.lastSynchronize,
      'CreateBy': instance.createBy,
      'CreateDate': instance.createDate,
      'UpdateBy': instance.updateBy,
      'UpdateDate': instance.updateDate,
    };

UserApiResponseModel _$UserApiResponseModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'UserApiResponseModel',
      json,
      ($checkedConvert) {
        final val = UserApiResponseModel(
          data: $checkedConvert(
              'Data',
              (v) => v == null
                  ? null
                  : UserApiDataModel.fromJson(v as Map<String, dynamic>)),
          code: $checkedConvert('Code', (v) => (v as num).toInt()),
          succeeded: $checkedConvert('Succeeded', (v) => v as bool),
          message: $checkedConvert('Message', (v) => v as String),
          description: $checkedConvert('Description', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'data': 'Data',
        'code': 'Code',
        'succeeded': 'Succeeded',
        'message': 'Message',
        'description': 'Description'
      },
    );

Map<String, dynamic> _$UserApiResponseModelToJson(
        UserApiResponseModel instance) =>
    <String, dynamic>{
      'Data': instance.data?.toJson(),
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };
