// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_task_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentTaskResponseModel _$CurrentTaskResponseModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'CurrentTaskResponseModel',
      json,
      ($checkedConvert) {
        final val = CurrentTaskResponseModel(
          data: $checkedConvert(
              'Data',
              (v) => v == null
                  ? null
                  : CurrentTaskDataModel.fromJson(v as Map<String, dynamic>)),
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

Map<String, dynamic> _$CurrentTaskResponseModelToJson(
        CurrentTaskResponseModel instance) =>
    <String, dynamic>{
      'Data': instance.data?.toJson(),
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };

CurrentTaskDataModel _$CurrentTaskDataModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'CurrentTaskDataModel',
      json,
      ($checkedConvert) {
        final val = CurrentTaskDataModel(
          routeName: $checkedConvert('RouteName', (v) => v as String?),
          listRoute: $checkedConvert(
              'ListRoute',
              (v) => (v as List<dynamic>)
                  .map(
                      (e) => RouteTaskModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
          listCarryOver: $checkedConvert(
              'ListCarryOver',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      CarryOverTaskModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
      fieldKeyMap: const {
        'routeName': 'RouteName',
        'listRoute': 'ListRoute',
        'listCarryOver': 'ListCarryOver'
      },
    );

Map<String, dynamic> _$CurrentTaskDataModelToJson(
        CurrentTaskDataModel instance) =>
    <String, dynamic>{
      'RouteName': instance.routeName,
      'ListRoute': instance.listRoute.map((e) => e.toJson()).toList(),
      'ListCarryOver': instance.listCarryOver.map((e) => e.toJson()).toList(),
    };

RouteTaskModel _$RouteTaskModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'RouteTaskModel',
      json,
      ($checkedConvert) {
        final val = RouteTaskModel(
          idAreas: $checkedConvert('IdAreas', (v) => v as String),
          areasName: $checkedConvert('AreasName', (v) => v as String),
          checkIn: $checkedConvert('CheckIn', (v) => v as String?),
          filename: $checkedConvert('Filename', (v) => v as String?),
          fileUrl: $checkedConvert('FileUrl', (v) => v as String?),
          status: $checkedConvert('Status', (v) => v as String),
          latitude: $checkedConvert('Latitude', (v) => (v as num?)?.toDouble()),
          longitude:
              $checkedConvert('Longitude', (v) => (v as num?)?.toDouble()),
        );
        return val;
      },
      fieldKeyMap: const {
        'idAreas': 'IdAreas',
        'areasName': 'AreasName',
        'checkIn': 'CheckIn',
        'filename': 'Filename',
        'fileUrl': 'FileUrl',
        'status': 'Status',
        'latitude': 'Latitude',
        'longitude': 'Longitude'
      },
    );

Map<String, dynamic> _$RouteTaskModelToJson(RouteTaskModel instance) =>
    <String, dynamic>{
      'IdAreas': instance.idAreas,
      'AreasName': instance.areasName,
      'CheckIn': instance.checkIn,
      'Filename': instance.filename,
      'FileUrl': instance.fileUrl,
      'Status': instance.status,
      'Latitude': instance.latitude,
      'Longitude': instance.longitude,
    };

CarryOverTaskModel _$CarryOverTaskModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'CarryOverTaskModel',
      json,
      ($checkedConvert) {
        final val = CarryOverTaskModel(
          id: $checkedConvert('Id', (v) => v as String),
          createBy: $checkedConvert('CreateBy', (v) => v as String),
          createDate: $checkedConvert('CreateDate', (v) => v as String),
          idShift: $checkedConvert('IdShift', (v) => v as String),
          reportDate: $checkedConvert('ReportDate', (v) => v as String),
          reportId: $checkedConvert('ReportId', (v) => v as String),
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

Map<String, dynamic> _$CarryOverTaskModelToJson(CarryOverTaskModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'CreateBy': instance.createBy,
      'CreateDate': instance.createDate,
      'IdShift': instance.idShift,
      'ReportDate': instance.reportDate,
      'ReportId': instance.reportId,
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
