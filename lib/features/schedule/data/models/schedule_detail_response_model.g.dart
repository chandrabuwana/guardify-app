// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_detail_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleDetailResponseModel _$ScheduleDetailResponseModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'ScheduleDetailResponseModel',
      json,
      ($checkedConvert) {
        final val = ScheduleDetailResponseModel(
          data: $checkedConvert(
              'Data',
              (v) => v == null
                  ? null
                  : ScheduleDetailDataModel.fromJson(
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

Map<String, dynamic> _$ScheduleDetailResponseModelToJson(
        ScheduleDetailResponseModel instance) =>
    <String, dynamic>{
      'Data': instance.data?.toJson(),
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };

ScheduleDetailDataModel _$ScheduleDetailDataModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'ScheduleDetailDataModel',
      json,
      ($checkedConvert) {
        final val = ScheduleDetailDataModel(
          shiftName: $checkedConvert('ShiftName', (v) => v as String),
          startTime: $checkedConvert('StartTime', (v) => v as String),
          endTime: $checkedConvert('EndTime', (v) => v as String),
          location: $checkedConvert('Location', (v) => v as String),
          routeName: $checkedConvert('RouteName', (v) => v as String),
          listPersonel: $checkedConvert(
              'ListPersonel',
              (v) => (v as List<dynamic>)
                  .map(
                      (e) => PersonnelModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
          listRoute: $checkedConvert('ListRoute', (v) => v as List<dynamic>),
        );
        return val;
      },
      fieldKeyMap: const {
        'shiftName': 'ShiftName',
        'startTime': 'StartTime',
        'endTime': 'EndTime',
        'location': 'Location',
        'routeName': 'RouteName',
        'listPersonel': 'ListPersonel',
        'listRoute': 'ListRoute'
      },
    );

Map<String, dynamic> _$ScheduleDetailDataModelToJson(
        ScheduleDetailDataModel instance) =>
    <String, dynamic>{
      'ShiftName': instance.shiftName,
      'StartTime': instance.startTime,
      'EndTime': instance.endTime,
      'Location': instance.location,
      'RouteName': instance.routeName,
      'ListPersonel': instance.listPersonel.map((e) => e.toJson()).toList(),
      'ListRoute': instance.listRoute,
    };

PersonnelModel _$PersonnelModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PersonnelModel',
      json,
      ($checkedConvert) {
        final val = PersonnelModel(
          userId: $checkedConvert('UserId', (v) => v as String),
          fullname: $checkedConvert('Fullname', (v) => v as String),
          images: $checkedConvert('Images', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'userId': 'UserId',
        'fullname': 'Fullname',
        'images': 'Images'
      },
    );

Map<String, dynamic> _$PersonnelModelToJson(PersonnelModel instance) =>
    <String, dynamic>{
      'UserId': instance.userId,
      'Fullname': instance.fullname,
      'Images': instance.images,
    };
