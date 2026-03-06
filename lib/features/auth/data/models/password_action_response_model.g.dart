// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_action_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PasswordActionResponseModel _$PasswordActionResponseModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'PasswordActionResponseModel',
      json,
      ($checkedConvert) {
        final val = PasswordActionResponseModel(
          code: $checkedConvert('Code', (v) => (v as num).toInt()),
          succeeded: $checkedConvert('Succeeded', (v) => v as bool),
          message: $checkedConvert('Message', (v) => v as String?),
          description: $checkedConvert('Description', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'code': 'Code',
        'succeeded': 'Succeeded',
        'message': 'Message',
        'description': 'Description'
      },
    );

Map<String, dynamic> _$PasswordActionResponseModelToJson(
        PasswordActionResponseModel instance) =>
    <String, dynamic>{
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };
