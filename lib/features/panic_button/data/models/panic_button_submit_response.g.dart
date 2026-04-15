// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panic_button_submit_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PanicButtonSubmitResponse _$PanicButtonSubmitResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'PanicButtonSubmitResponse',
      json,
      ($checkedConvert) {
        final val = PanicButtonSubmitResponse(
          code: $checkedConvert('Code', (v) => (v as num).toInt()),
          succeeded: $checkedConvert('Succeeded', (v) => v as bool),
          message: $checkedConvert('Message', (v) => v as String),
          description: $checkedConvert('Description', (v) => v as String),
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

Map<String, dynamic> _$PanicButtonSubmitResponseToJson(
        PanicButtonSubmitResponse instance) =>
    <String, dynamic>{
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };
