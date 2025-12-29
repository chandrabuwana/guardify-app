// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_rekap_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceRekapResponseModel _$AttendanceRekapResponseModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'AttendanceRekapResponseModel',
      json,
      ($checkedConvert) {
        final val = AttendanceRekapResponseModel(
          count: $checkedConvert('Count', (v) => (v as num).toInt()),
          filtered: $checkedConvert('Filtered', (v) => (v as num).toInt()),
          list: $checkedConvert(
              'List',
              (v) => (v as List<dynamic>)
                  .map((e) => AttendanceRekapItemModel.fromJson(
                      e as Map<String, dynamic>))
                  .toList()),
          code: $checkedConvert('Code', (v) => (v as num).toInt()),
          succeeded: $checkedConvert('Succeeded', (v) => v as bool),
          message: $checkedConvert('Message', (v) => v as String),
          description: $checkedConvert('Description', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'count': 'Count',
        'filtered': 'Filtered',
        'list': 'List',
        'code': 'Code',
        'succeeded': 'Succeeded',
        'message': 'Message',
        'description': 'Description'
      },
    );

Map<String, dynamic> _$AttendanceRekapResponseModelToJson(
        AttendanceRekapResponseModel instance) =>
    <String, dynamic>{
      'Count': instance.count,
      'Filtered': instance.filtered,
      'List': instance.list.map((e) => e.toJson()).toList(),
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };

AttendanceRekapItemModel _$AttendanceRekapItemModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'AttendanceRekapItemModel',
      json,
      ($checkedConvert) {
        final val = AttendanceRekapItemModel(
          idAttendance: $checkedConvert('IdAttendance', (v) => v as String?),
          shiftDate: $checkedConvert('ShiftDate', (v) => v as String),
          shiftName: $checkedConvert('ShiftName', (v) => v as String),
          isOvertime: $checkedConvert('IsOvertime', (v) => v as bool),
          status: $checkedConvert('Status', (v) => v as String?),
          statusAttendance:
              $checkedConvert('StatusAttendance', (v) => v as String),
          statusCarryOver:
              $checkedConvert('StatusCarryOver', (v) => v as String),
          patrol: $checkedConvert('Patrol', (v) => v as String),
          checkIn: $checkedConvert('CheckIn', (v) => v as String?),
          checkOut: $checkedConvert('CheckOut', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'idAttendance': 'IdAttendance',
        'shiftDate': 'ShiftDate',
        'shiftName': 'ShiftName',
        'isOvertime': 'IsOvertime',
        'status': 'Status',
        'statusAttendance': 'StatusAttendance',
        'statusCarryOver': 'StatusCarryOver',
        'patrol': 'Patrol',
        'checkIn': 'CheckIn',
        'checkOut': 'CheckOut'
      },
    );

Map<String, dynamic> _$AttendanceRekapItemModelToJson(
        AttendanceRekapItemModel instance) =>
    <String, dynamic>{
      'IdAttendance': instance.idAttendance,
      'ShiftDate': instance.shiftDate,
      'ShiftName': instance.shiftName,
      'IsOvertime': instance.isOvertime,
      'Status': instance.status,
      'StatusAttendance': instance.statusAttendance,
      'StatusCarryOver': instance.statusCarryOver,
      'Patrol': instance.patrol,
      'CheckIn': instance.checkIn,
      'CheckOut': instance.checkOut,
    };
