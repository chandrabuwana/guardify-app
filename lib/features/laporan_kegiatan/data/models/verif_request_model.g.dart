// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verif_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifRequestModel _$VerifRequestModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'VerifRequestModel',
      json,
      ($checkedConvert) {
        final val = VerifRequestModel(
          idAttendance: $checkedConvert('IdAttendance', (v) => v as String),
          isVerif: $checkedConvert('IsVerif', (v) => v as bool),
          feedback: $checkedConvert('Feedback', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'idAttendance': 'IdAttendance',
        'isVerif': 'IsVerif',
        'feedback': 'Feedback'
      },
    );

Map<String, dynamic> _$VerifRequestModelToJson(VerifRequestModel instance) =>
    <String, dynamic>{
      'IdAttendance': instance.idAttendance,
      'IsVerif': instance.isVerif,
      'Feedback': instance.feedback,
    };

VerifResponseModel _$VerifResponseModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'VerifResponseModel',
      json,
      ($checkedConvert) {
        final val = VerifResponseModel(
          code: $checkedConvert('Code', (v) => (v as num).toInt()),
          succeeded: $checkedConvert('Succeeded', (v) => v as bool),
          message: $checkedConvert('Message', (v) => v as String),
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

Map<String, dynamic> _$VerifResponseModelToJson(VerifResponseModel instance) =>
    <String, dynamic>{
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };
