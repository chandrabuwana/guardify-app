import 'package:json_annotation/json_annotation.dart';

part 'current_task_response_model.g.dart';

/// Response model for Shift/get_current_task API
@JsonSerializable()
class CurrentTaskResponseModel {
  @JsonKey(name: 'Data')
  final CurrentTaskDataModel? data;

  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String? message;

  @JsonKey(name: 'Description')
  final String? description;

  CurrentTaskResponseModel({
    this.data,
    required this.code,
    required this.succeeded,
    this.message,
    this.description,
  });

  factory CurrentTaskResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CurrentTaskResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentTaskResponseModelToJson(this);
}

/// Data model for current task
@JsonSerializable()
class CurrentTaskDataModel {
  @JsonKey(name: 'ListRoute')
  final List<RouteTaskModel> listRoute;

  @JsonKey(name: 'ListCarryOver')
  final List<CarryOverTaskModel> listCarryOver;

  CurrentTaskDataModel({
    required this.listRoute,
    required this.listCarryOver,
  });

  factory CurrentTaskDataModel.fromJson(Map<String, dynamic> json) =>
      _$CurrentTaskDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentTaskDataModelToJson(this);
}

/// Route Task Model from ListRoute
@JsonSerializable()
class RouteTaskModel {
  @JsonKey(name: 'IdAreas')
  final String idAreas;

  @JsonKey(name: 'AreasName')
  final String areasName;

  @JsonKey(name: 'CheckIn')
  final String? checkIn;

  @JsonKey(name: 'Filename')
  final String? filename;

  @JsonKey(name: 'FileUrl')
  final String? fileUrl;

  @JsonKey(name: 'Status')
  final String status; // "BELUM" or other status

  RouteTaskModel({
    required this.idAreas,
    required this.areasName,
    this.checkIn,
    this.filename,
    this.fileUrl,
    required this.status,
  });

  factory RouteTaskModel.fromJson(Map<String, dynamic> json) =>
      _$RouteTaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$RouteTaskModelToJson(this);
}

/// Carry Over Task Model from ListCarryOver
@JsonSerializable()
class CarryOverTaskModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'CreateBy')
  final String createBy;

  @JsonKey(name: 'CreateDate')
  final String createDate;

  @JsonKey(name: 'IdShift')
  final String idShift;

  @JsonKey(name: 'ReportDate')
  final String reportDate;

  @JsonKey(name: 'ReportId')
  final String reportId;

  @JsonKey(name: 'ReportNote')
  final String reportNote;

  @JsonKey(name: 'SolverDate')
  final String? solverDate;

  @JsonKey(name: 'SolverId')
  final String? solverId;

  @JsonKey(name: 'SolverNote')
  final String? solverNote;

  @JsonKey(name: 'Status')
  final String status; // "OPEN" or other status

  @JsonKey(name: 'UpdateBy')
  final String? updateBy;

  @JsonKey(name: 'UpdateDate')
  final String? updateDate;

  CarryOverTaskModel({
    required this.id,
    required this.createBy,
    required this.createDate,
    required this.idShift,
    required this.reportDate,
    required this.reportId,
    required this.reportNote,
    this.solverDate,
    this.solverId,
    this.solverNote,
    required this.status,
    this.updateBy,
    this.updateDate,
  });

  factory CarryOverTaskModel.fromJson(Map<String, dynamic> json) =>
      _$CarryOverTaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$CarryOverTaskModelToJson(this);
}

