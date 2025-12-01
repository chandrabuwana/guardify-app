// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_pengawas_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SchedulePengawasResponseModel _$SchedulePengawasResponseModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'SchedulePengawasResponseModel',
      json,
      ($checkedConvert) {
        final val = SchedulePengawasResponseModel(
          data: $checkedConvert(
              'Data',
              (v) => v == null
                  ? null
                  : SchedulePengawasDataModel.fromJson(
                      v as Map<String, dynamic>)),
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

Map<String, dynamic> _$SchedulePengawasResponseModelToJson(
        SchedulePengawasResponseModel instance) =>
    <String, dynamic>{
      'Data': instance.data?.toJson(),
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };

SchedulePengawasDataModel _$SchedulePengawasDataModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'SchedulePengawasDataModel',
      json,
      ($checkedConvert) {
        final val = SchedulePengawasDataModel(
          shiftDate: $checkedConvert('ShiftDate', (v) => v as String),
          listShift: $checkedConvert(
              'ListShift',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      ShiftPengawasModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
      fieldKeyMap: const {'shiftDate': 'ShiftDate', 'listShift': 'ListShift'},
    );

Map<String, dynamic> _$SchedulePengawasDataModelToJson(
        SchedulePengawasDataModel instance) =>
    <String, dynamic>{
      'ShiftDate': instance.shiftDate,
      'ListShift': instance.listShift.map((e) => e.toJson()).toList(),
    };

ShiftPengawasModel _$ShiftPengawasModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ShiftPengawasModel',
      json,
      ($checkedConvert) {
        final val = ShiftPengawasModel(
          startTime: $checkedConvert('StartTime', (v) => v as String),
          endTime: $checkedConvert('EndTime', (v) => v as String),
          shiftName: $checkedConvert('ShiftName', (v) => v as String),
          totalPersonel:
              $checkedConvert('TotalPersonel', (v) => (v as num).toInt()),
          listRoute: $checkedConvert(
              'ListRoute',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      RoutePengawasModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
      fieldKeyMap: const {
        'startTime': 'StartTime',
        'endTime': 'EndTime',
        'shiftName': 'ShiftName',
        'totalPersonel': 'TotalPersonel',
        'listRoute': 'ListRoute'
      },
    );

Map<String, dynamic> _$ShiftPengawasModelToJson(ShiftPengawasModel instance) =>
    <String, dynamic>{
      'StartTime': instance.startTime,
      'EndTime': instance.endTime,
      'ShiftName': instance.shiftName,
      'TotalPersonel': instance.totalPersonel,
      'ListRoute': instance.listRoute.map((e) => e.toJson()).toList(),
    };

RoutePengawasModel _$RoutePengawasModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'RoutePengawasModel',
      json,
      ($checkedConvert) {
        final val = RoutePengawasModel(
          areasName: $checkedConvert('AreasName', (v) => v as String),
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
        'areasName': 'AreasName',
        'listPersonel': 'ListPersonel'
      },
    );

Map<String, dynamic> _$RoutePengawasModelToJson(RoutePengawasModel instance) =>
    <String, dynamic>{
      'AreasName': instance.areasName,
      'ListPersonel': instance.listPersonel.map((e) => e.toJson()).toList(),
    };
