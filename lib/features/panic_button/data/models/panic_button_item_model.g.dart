// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panic_button_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PanicButtonItemModel _$PanicButtonItemModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'PanicButtonItemModel',
      json,
      ($checkedConvert) {
        final val = PanicButtonItemModel(
          id: $checkedConvert('Id', (v) => v as String),
          action: $checkedConvert('Action', (v) => v as String?),
          areasId: $checkedConvert('AreasId', (v) => v as String),
          areas: $checkedConvert(
              'Areas',
              (v) => v == null
                  ? null
                  : PanicButtonAreaModel.fromJson(v as Map<String, dynamic>)),
          createBy: $checkedConvert('CreateBy', (v) => v as String?),
          createDate: $checkedConvert('CreateDate', (v) => v as String?),
          description: $checkedConvert('Description', (v) => v as String),
          feedback: $checkedConvert('Feedback', (v) => v as String?),
          idIncidentType:
              $checkedConvert('IdIncidentType', (v) => (v as num).toInt()),
          incidentType: $checkedConvert(
              'IncidentType',
              (v) => v == null
                  ? null
                  : PanicButtonIncidentTypeModel.fromJson(
                      v as Map<String, dynamic>)),
          reporterDate: $checkedConvert('ReporterDate', (v) => v as String),
          reporterId: $checkedConvert('ReporterId', (v) => v as String),
          reporter: $checkedConvert(
              'Reporter',
              (v) => v == null
                  ? null
                  : PanicButtonReporterModel.fromJson(
                      v as Map<String, dynamic>)),
          resolveAction: $checkedConvert('ResolveAction', (v) => v as String?),
          solverDate: $checkedConvert('SolverDate', (v) => v as String?),
          solverId: $checkedConvert('SolverId', (v) => v as String?),
          solver: $checkedConvert('Solver', (v) => v),
          status: $checkedConvert('Status', (v) => v as String),
          updateBy: $checkedConvert('UpdateBy', (v) => v as String?),
          updateDate: $checkedConvert('UpdateDate', (v) => v as String?),
          files: $checkedConvert(
              'Files',
              (v) => (v as List<dynamic>?)
                  ?.map((e) =>
                      PanicButtonFileModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'action': 'Action',
        'areasId': 'AreasId',
        'areas': 'Areas',
        'createBy': 'CreateBy',
        'createDate': 'CreateDate',
        'description': 'Description',
        'feedback': 'Feedback',
        'idIncidentType': 'IdIncidentType',
        'incidentType': 'IncidentType',
        'reporterDate': 'ReporterDate',
        'reporterId': 'ReporterId',
        'reporter': 'Reporter',
        'resolveAction': 'ResolveAction',
        'solverDate': 'SolverDate',
        'solverId': 'SolverId',
        'solver': 'Solver',
        'status': 'Status',
        'updateBy': 'UpdateBy',
        'updateDate': 'UpdateDate',
        'files': 'Files'
      },
    );

Map<String, dynamic> _$PanicButtonItemModelToJson(
        PanicButtonItemModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Action': instance.action,
      'AreasId': instance.areasId,
      'Areas': instance.areas?.toJson(),
      'CreateBy': instance.createBy,
      'CreateDate': instance.createDate,
      'Description': instance.description,
      'Feedback': instance.feedback,
      'IdIncidentType': instance.idIncidentType,
      'IncidentType': instance.incidentType?.toJson(),
      'ReporterDate': instance.reporterDate,
      'ReporterId': instance.reporterId,
      'Reporter': instance.reporter?.toJson(),
      'ResolveAction': instance.resolveAction,
      'SolverDate': instance.solverDate,
      'SolverId': instance.solverId,
      'Solver': instance.solver,
      'Status': instance.status,
      'UpdateBy': instance.updateBy,
      'UpdateDate': instance.updateDate,
      'Files': instance.files?.map((e) => e.toJson()).toList(),
    };
