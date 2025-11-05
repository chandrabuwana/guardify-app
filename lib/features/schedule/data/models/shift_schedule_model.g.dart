// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftScheduleModel _$ShiftScheduleModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ShiftScheduleModel',
      json,
      ($checkedConvert) {
        final val = ShiftScheduleModel(
          id: $checkedConvert('Id', (v) => v as String),
          date: $checkedConvert('Date', (v) => v as String),
          shiftName: $checkedConvert('ShiftName', (v) => v as String),
          shiftTime: $checkedConvert('ShiftTime', (v) => v as String),
          location: $checkedConvert('Location', (v) => v as String),
          position: $checkedConvert('Position', (v) => v as String),
          route: $checkedConvert('Route', (v) => v as String),
          patrolLocations: $checkedConvert(
              'PatrolLocations',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      PatrolLocationModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
          teamMembers: $checkedConvert(
              'TeamMembers',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      TeamMemberModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'date': 'Date',
        'shiftName': 'ShiftName',
        'shiftTime': 'ShiftTime',
        'location': 'Location',
        'position': 'Position',
        'route': 'Route',
        'patrolLocations': 'PatrolLocations',
        'teamMembers': 'TeamMembers'
      },
    );

Map<String, dynamic> _$ShiftScheduleModelToJson(ShiftScheduleModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Date': instance.date,
      'ShiftName': instance.shiftName,
      'ShiftTime': instance.shiftTime,
      'Location': instance.location,
      'Position': instance.position,
      'Route': instance.route,
      'PatrolLocations':
          instance.patrolLocations.map((e) => e.toJson()).toList(),
      'TeamMembers': instance.teamMembers.map((e) => e.toJson()).toList(),
    };

PatrolLocationModel _$PatrolLocationModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PatrolLocationModel',
      json,
      ($checkedConvert) {
        final val = PatrolLocationModel(
          id: $checkedConvert('Id', (v) => v as String),
          name: $checkedConvert('Name', (v) => v as String),
          type: $checkedConvert('Type', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'id': 'Id', 'name': 'Name', 'type': 'Type'},
    );

Map<String, dynamic> _$PatrolLocationModelToJson(
        PatrolLocationModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Type': instance.type,
    };

TeamMemberModel _$TeamMemberModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'TeamMemberModel',
      json,
      ($checkedConvert) {
        final val = TeamMemberModel(
          id: $checkedConvert('Id', (v) => v as String),
          name: $checkedConvert('Name', (v) => v as String),
          position: $checkedConvert('Position', (v) => v as String),
          photoUrl: $checkedConvert('PhotoUrl', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'name': 'Name',
        'position': 'Position',
        'photoUrl': 'PhotoUrl'
      },
    );

Map<String, dynamic> _$TeamMemberModelToJson(TeamMemberModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Position': instance.position,
      'PhotoUrl': instance.photoUrl,
    };

DailyAgendaModel _$DailyAgendaModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'DailyAgendaModel',
      json,
      ($checkedConvert) {
        final val = DailyAgendaModel(
          date: $checkedConvert('Date', (v) => v as String),
          shiftType: $checkedConvert('ShiftType', (v) => v as String),
          position: $checkedConvert('Position', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'date': 'Date',
        'shiftType': 'ShiftType',
        'position': 'Position'
      },
    );

Map<String, dynamic> _$DailyAgendaModelToJson(DailyAgendaModel instance) =>
    <String, dynamic>{
      'Date': instance.date,
      'ShiftType': instance.shiftType,
      'Position': instance.position,
    };
