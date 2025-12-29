import 'package:json_annotation/json_annotation.dart';
import 'panic_button_area_model.dart';
import 'panic_button_incident_type_model.dart';
import 'panic_button_reporter_model.dart';
import 'panic_button_file_model.dart';

part 'panic_button_item_model.g.dart';

@JsonSerializable()
class PanicButtonItemModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Action')
  final String? action;

  @JsonKey(name: 'AreasId')
  final String areasId;

  @JsonKey(name: 'Areas')
  final PanicButtonAreaModel? areas;

  @JsonKey(name: 'CreateBy')
  final String? createBy;

  @JsonKey(name: 'CreateDate')
  final String? createDate;

  @JsonKey(name: 'Description')
  final String description;

  @JsonKey(name: 'Feedback')
  final String? feedback;

  @JsonKey(name: 'IdIncidentType')
  final int idIncidentType;

  @JsonKey(name: 'IncidentType')
  final PanicButtonIncidentTypeModel? incidentType;

  @JsonKey(name: 'ReporterDate')
  final String reporterDate;

  @JsonKey(name: 'ReporterId')
  final String reporterId;

  @JsonKey(name: 'Reporter')
  final PanicButtonReporterModel? reporter;

  @JsonKey(name: 'ResolveAction')
  final String? resolveAction;

  @JsonKey(name: 'SolverDate')
  final String? solverDate;

  @JsonKey(name: 'SolverId')
  final String? solverId;

  @JsonKey(name: 'Solver')
  final dynamic solver;

  @JsonKey(name: 'Status')
  final String status;

  @JsonKey(name: 'UpdateBy')
  final String? updateBy;

  @JsonKey(name: 'UpdateDate')
  final String? updateDate;

  @JsonKey(name: 'Files')
  final List<PanicButtonFileModel>? files;

  PanicButtonItemModel({
    required this.id,
    this.action,
    required this.areasId,
    this.areas,
    this.createBy,
    this.createDate,
    required this.description,
    this.feedback,
    required this.idIncidentType,
    this.incidentType,
    required this.reporterDate,
    required this.reporterId,
    this.reporter,
    this.resolveAction,
    this.solverDate,
    this.solverId,
    this.solver,
    required this.status,
    this.updateBy,
    this.updateDate,
    this.files,
  });

  factory PanicButtonItemModel.fromJson(Map<String, dynamic> json) =>
      _$PanicButtonItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$PanicButtonItemModelToJson(this);
}

