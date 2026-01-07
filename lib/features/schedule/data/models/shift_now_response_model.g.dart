// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_now_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftNowResponseModel _$ShiftNowResponseModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'ShiftNowResponseModel',
      json,
      ($checkedConvert) {
        final val = ShiftNowResponseModel(
          data: $checkedConvert(
              'Data',
              (v) => v == null
                  ? null
                  : ShiftNowDataModel.fromJson(v as Map<String, dynamic>)),
          code: $checkedConvert('Code', (v) => (v as num).toInt()),
          succeeded: $checkedConvert('Succeeded', (v) => v as bool),
          message: $checkedConvert('Message', (v) => v as String?),
          description: $checkedConvert('Description', (v) => v as String?),
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

Map<String, dynamic> _$ShiftNowResponseModelToJson(
        ShiftNowResponseModel instance) =>
    <String, dynamic>{
      'Data': instance.data?.toJson(),
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };

ShiftNowDataModel _$ShiftNowDataModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ShiftNowDataModel',
      json,
      ($checkedConvert) {
        final val = ShiftNowDataModel(
          shiftDate: $checkedConvert('ShiftDate', (v) => v as String),
          shiftName: $checkedConvert('ShiftName', (v) => v as String),
          totalPersonel:
              $checkedConvert('TotalPersonel', (v) => (v as num).toInt()),
          totalAttendance:
              $checkedConvert('TotalAttendance', (v) => (v as num).toInt()),
          listPersonel: $checkedConvert(
              'ListPersonel',
              (v) => (v as List<dynamic>)
                  .map(
                      (e) => PersonnelModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
      fieldKeyMap: const {
        'shiftDate': 'ShiftDate',
        'shiftName': 'ShiftName',
        'totalPersonel': 'TotalPersonel',
        'totalAttendance': 'TotalAttendance',
        'listPersonel': 'ListPersonel'
      },
    );

Map<String, dynamic> _$ShiftNowDataModelToJson(ShiftNowDataModel instance) =>
    <String, dynamic>{
      'ShiftDate': instance.shiftDate,
      'ShiftName': instance.shiftName,
      'TotalPersonel': instance.totalPersonel,
      'TotalAttendance': instance.totalAttendance,
      'ListPersonel': instance.listPersonel.map((e) => e.toJson()).toList(),
    };
