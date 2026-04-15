// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthTokenModel _$AuthTokenModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'AuthTokenModel',
      json,
      ($checkedConvert) {
        final val = AuthTokenModel(
          rawToken: $checkedConvert('RawToken', (v) => v as String),
          refreshToken: $checkedConvert('RefreshToken', (v) => v as String),
          expiredAt: $checkedConvert('ExpiredAt', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'rawToken': 'RawToken',
        'refreshToken': 'RefreshToken',
        'expiredAt': 'ExpiredAt'
      },
    );

Map<String, dynamic> _$AuthTokenModelToJson(AuthTokenModel instance) =>
    <String, dynamic>{
      'RawToken': instance.rawToken,
      'RefreshToken': instance.refreshToken,
      'ExpiredAt': instance.expiredAt,
    };
