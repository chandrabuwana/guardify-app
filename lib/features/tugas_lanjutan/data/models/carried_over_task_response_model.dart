import 'package:json_annotation/json_annotation.dart';

part 'carried_over_task_response_model.g.dart';

/// Response model for CarriedOverTask/list API
@JsonSerializable()
class CarriedOverTaskResponseModel {
  @JsonKey(name: 'Count')
  final int count;

  @JsonKey(name: 'Filtered')
  final int filtered;

  @JsonKey(name: 'List')
  final List<CarriedOverTaskItemModel> list;

  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String? message;

  @JsonKey(name: 'Description')
  final String? description;

  CarriedOverTaskResponseModel({
    required this.count,
    required this.filtered,
    required this.list,
    required this.code,
    required this.succeeded,
    this.message,
    this.description,
  });

  factory CarriedOverTaskResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CarriedOverTaskResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CarriedOverTaskResponseModelToJson(this);
}

/// Item model for CarriedOverTask
@JsonSerializable()
class CarriedOverTaskItemModel {
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

  @JsonKey(name: 'ReportName')
  final ReportNameModel? reportName;

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

  @JsonKey(name: 'Location')
  final String? location;

  @JsonKey(name: 'File')
  final String? file;

  CarriedOverTaskItemModel({
    required this.id,
    required this.createBy,
    required this.createDate,
    required this.idShift,
    required this.reportDate,
    required this.reportId,
    this.reportName,
    required this.reportNote,
    this.solverDate,
    this.solverId,
    this.solverNote,
    required this.status,
    this.updateBy,
    this.updateDate,
    this.location,
    this.file,
  });

  factory CarriedOverTaskItemModel.fromJson(Map<String, dynamic> json) =>
      _$CarriedOverTaskItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CarriedOverTaskItemModelToJson(this);
}

/// Report Name Model (User information)
@JsonSerializable()
class ReportNameModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Fullname')
  final String fullname;

  @JsonKey(name: 'Username')
  final String? username;

  @JsonKey(name: 'Email')
  final String? email;

  @JsonKey(name: 'NoNrp')
  final String? noNrp;

  ReportNameModel({
    required this.id,
    required this.fullname,
    this.username,
    this.email,
    this.noNrp,
  });

  factory ReportNameModel.fromJson(Map<String, dynamic> json) =>
      _$ReportNameModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReportNameModelToJson(this);
}

