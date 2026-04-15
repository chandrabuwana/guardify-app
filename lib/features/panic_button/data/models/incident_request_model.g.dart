// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncidentRequestModel _$IncidentRequestModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'IncidentRequestModel',
      json,
      ($checkedConvert) {
        final val = IncidentRequestModel(
          action: $checkedConvert('Action', (v) => v as String?),
          areasId: $checkedConvert('AreasId', (v) => v as String),
          description: $checkedConvert('Description', (v) => v as String),
          feedback: $checkedConvert('Feedback', (v) => v as String?),
          idIncidentType:
              $checkedConvert('IdIncidentType', (v) => (v as num).toInt()),
          reporterDate: $checkedConvert('ReporterDate', (v) => v as String),
          reporterId: $checkedConvert('ReporterId', (v) => v as String),
          resolveAction: $checkedConvert('ResolveAction', (v) => v as String?),
          solverDate: $checkedConvert('SolverDate', (v) => v as String?),
          solverId: $checkedConvert('SolverId', (v) => v as String?),
          status: $checkedConvert('Status', (v) => v as String),
          files: $checkedConvert(
              'Files',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      IncidentFileModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
      fieldKeyMap: const {
        'action': 'Action',
        'areasId': 'AreasId',
        'description': 'Description',
        'feedback': 'Feedback',
        'idIncidentType': 'IdIncidentType',
        'reporterDate': 'ReporterDate',
        'reporterId': 'ReporterId',
        'resolveAction': 'ResolveAction',
        'solverDate': 'SolverDate',
        'solverId': 'SolverId',
        'status': 'Status',
        'files': 'Files'
      },
    );

Map<String, dynamic> _$IncidentRequestModelToJson(
        IncidentRequestModel instance) =>
    <String, dynamic>{
      'Action': instance.action,
      'AreasId': instance.areasId,
      'Description': instance.description,
      'Feedback': instance.feedback,
      'IdIncidentType': instance.idIncidentType,
      'ReporterDate': instance.reporterDate,
      'ReporterId': instance.reporterId,
      'ResolveAction': instance.resolveAction,
      'SolverDate': instance.solverDate,
      'SolverId': instance.solverId,
      'Status': instance.status,
      'Files': instance.files.map((e) => e.toJson()).toList(),
    };

IncidentFileModel _$IncidentFileModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'IncidentFileModel',
      json,
      ($checkedConvert) {
        final val = IncidentFileModel(
          filename: $checkedConvert('Filename', (v) => v as String),
          mimeType: $checkedConvert('MimeType', (v) => v as String),
          base64: $checkedConvert('Base64', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'filename': 'Filename',
        'mimeType': 'MimeType',
        'base64': 'Base64'
      },
    );

Map<String, dynamic> _$IncidentFileModelToJson(IncidentFileModel instance) =>
    <String, dynamic>{
      'Filename': instance.filename,
      'MimeType': instance.mimeType,
      'Base64': instance.base64,
    };
