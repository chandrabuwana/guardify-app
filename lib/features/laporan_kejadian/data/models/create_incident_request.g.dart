// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_incident_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateIncidentRequest _$CreateIncidentRequestFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'CreateIncidentRequest',
      json,
      ($checkedConvert) {
        final val = CreateIncidentRequest(
          areasDescription:
              $checkedConvert('AreasDescription', (v) => v as String),
          areasId: $checkedConvert('AreasId', (v) => v as String),
          idIncidentType:
              $checkedConvert('IdIncidentType', (v) => (v as num).toInt()),
          incidentDate: $checkedConvert(
              'IncidentDate', (v) => DateTime.parse(v as String)),
          incidentTime: $checkedConvert('IncidentTime', (v) => v as String),
          incidentDescription:
              $checkedConvert('IncidentDescription', (v) => v as String),
          notesAction: $checkedConvert('NotesAction', (v) => v as String?),
          picId: $checkedConvert('PicId', (v) => v as String?),
          pjId: $checkedConvert('PjId', (v) => v as String?),
          reportId: $checkedConvert('ReportId', (v) => v as String),
          solvedAction: $checkedConvert('SolvedAction', (v) => v as String?),
          solvedDate: $checkedConvert('SolvedDate',
              (v) => v == null ? null : DateTime.parse(v as String)),
          status: $checkedConvert('Status', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'areasDescription': 'AreasDescription',
        'areasId': 'AreasId',
        'idIncidentType': 'IdIncidentType',
        'incidentDate': 'IncidentDate',
        'incidentTime': 'IncidentTime',
        'incidentDescription': 'IncidentDescription',
        'notesAction': 'NotesAction',
        'picId': 'PicId',
        'pjId': 'PjId',
        'reportId': 'ReportId',
        'solvedAction': 'SolvedAction',
        'solvedDate': 'SolvedDate',
        'status': 'Status'
      },
    );

Map<String, dynamic> _$CreateIncidentRequestToJson(
        CreateIncidentRequest instance) =>
    <String, dynamic>{
      'AreasDescription': instance.areasDescription,
      'AreasId': instance.areasId,
      'IdIncidentType': instance.idIncidentType,
      'IncidentDate': instance.incidentDate.toIso8601String(),
      'IncidentTime': instance.incidentTime,
      'IncidentDescription': instance.incidentDescription,
      'NotesAction': instance.notesAction,
      'PicId': instance.picId,
      'PjId': instance.pjId,
      'ReportId': instance.reportId,
      'SolvedAction': instance.solvedAction,
      'SolvedDate': instance.solvedDate?.toIso8601String(),
      'Status': instance.status,
    };
