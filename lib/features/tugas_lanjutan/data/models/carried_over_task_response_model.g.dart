// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carried_over_task_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarriedOverTaskResponseModel _$CarriedOverTaskResponseModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'CarriedOverTaskResponseModel',
      json,
      ($checkedConvert) {
        final val = CarriedOverTaskResponseModel(
          count: $checkedConvert('Count', (v) => (v as num).toInt()),
          filtered: $checkedConvert('Filtered', (v) => (v as num).toInt()),
          list: $checkedConvert(
              'List',
              (v) => (v as List<dynamic>)
                  .map((e) => CarriedOverTaskItemModel.fromJson(
                      e as Map<String, dynamic>))
                  .toList()),
          code: $checkedConvert('Code', (v) => (v as num).toInt()),
          succeeded: $checkedConvert('Succeeded', (v) => v as bool),
          message: $checkedConvert('Message', (v) => v as String?),
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

Map<String, dynamic> _$CarriedOverTaskResponseModelToJson(
        CarriedOverTaskResponseModel instance) =>
    <String, dynamic>{
      'Count': instance.count,
      'Filtered': instance.filtered,
      'List': instance.list.map((e) => e.toJson()).toList(),
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };

CarriedOverTaskItemModel _$CarriedOverTaskItemModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'CarriedOverTaskItemModel',
      json,
      ($checkedConvert) {
        final val = CarriedOverTaskItemModel(
          id: $checkedConvert('Id', (v) => v as String),
          createBy: $checkedConvert('CreateBy', (v) => v as String),
          createDate: $checkedConvert('CreateDate', (v) => v as String),
          idShift: $checkedConvert('IdShift', (v) => v as String),
          reportDate: $checkedConvert('ReportDate', (v) => v as String),
          reportId: $checkedConvert('ReportId', (v) => v as String),
          reportName: $checkedConvert(
              'ReportName',
              (v) => v == null
                  ? null
                  : ReportNameModel.fromJson(v as Map<String, dynamic>)),
          reportNote: $checkedConvert('ReportNote', (v) => v as String),
          solverDate: $checkedConvert('SolverDate', (v) => v as String?),
          solverId: $checkedConvert('SolverId', (v) => v as String?),
          solverNote: $checkedConvert('SolverNote', (v) => v as String?),
          status: $checkedConvert('Status', (v) => v as String),
          updateBy: $checkedConvert('UpdateBy', (v) => v as String?),
          updateDate: $checkedConvert('UpdateDate', (v) => v as String?),
          location: $checkedConvert('Location', (v) => v as String?),
          file: $checkedConvert('File', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'createBy': 'CreateBy',
        'createDate': 'CreateDate',
        'idShift': 'IdShift',
        'reportDate': 'ReportDate',
        'reportId': 'ReportId',
        'reportName': 'ReportName',
        'reportNote': 'ReportNote',
        'solverDate': 'SolverDate',
        'solverId': 'SolverId',
        'solverNote': 'SolverNote',
        'status': 'Status',
        'updateBy': 'UpdateBy',
        'updateDate': 'UpdateDate',
        'location': 'Location',
        'file': 'File'
      },
    );

Map<String, dynamic> _$CarriedOverTaskItemModelToJson(
        CarriedOverTaskItemModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'CreateBy': instance.createBy,
      'CreateDate': instance.createDate,
      'IdShift': instance.idShift,
      'ReportDate': instance.reportDate,
      'ReportId': instance.reportId,
      'ReportName': instance.reportName?.toJson(),
      'ReportNote': instance.reportNote,
      'SolverDate': instance.solverDate,
      'SolverId': instance.solverId,
      'SolverNote': instance.solverNote,
      'Status': instance.status,
      'UpdateBy': instance.updateBy,
      'UpdateDate': instance.updateDate,
      'Location': instance.location,
      'File': instance.file,
    };

ReportNameModel _$ReportNameModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ReportNameModel',
      json,
      ($checkedConvert) {
        final val = ReportNameModel(
          id: $checkedConvert('Id', (v) => v as String),
          fullname: $checkedConvert('Fullname', (v) => v as String),
          username: $checkedConvert('Username', (v) => v as String?),
          email: $checkedConvert('Email', (v) => v as String?),
          noNrp: $checkedConvert('NoNrp', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'fullname': 'Fullname',
        'username': 'Username',
        'email': 'Email',
        'noNrp': 'NoNrp'
      },
    );

Map<String, dynamic> _$ReportNameModelToJson(ReportNameModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Fullname': instance.fullname,
      'Username': instance.username,
      'Email': instance.email,
      'NoNrp': instance.noNrp,
    };
