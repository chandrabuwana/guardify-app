// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panic_button_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PanicButtonDetailResponse _$PanicButtonDetailResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'PanicButtonDetailResponse',
      json,
      ($checkedConvert) {
        final val = PanicButtonDetailResponse(
          data: $checkedConvert(
              'Data',
              (v) => v == null
                  ? null
                  : PanicButtonItemModel.fromJson(v as Map<String, dynamic>)),
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

Map<String, dynamic> _$PanicButtonDetailResponseToJson(
        PanicButtonDetailResponse instance) =>
    <String, dynamic>{
      'Data': instance.data?.toJson(),
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };
