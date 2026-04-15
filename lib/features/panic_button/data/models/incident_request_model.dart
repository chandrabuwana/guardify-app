import 'package:json_annotation/json_annotation.dart';

part 'incident_request_model.g.dart';

@JsonSerializable()
class IncidentRequestModel {
  @JsonKey(name: 'Action')
  final String? action;

  @JsonKey(name: 'AreasId')
  final String areasId;

  @JsonKey(name: 'Description')
  final String description;

  @JsonKey(name: 'Feedback')
  final String? feedback;

  @JsonKey(name: 'IdIncidentType')
  final int idIncidentType;

  @JsonKey(name: 'ReporterDate')
  final String reporterDate;

  @JsonKey(name: 'ReporterId')
  final String reporterId;

  @JsonKey(name: 'ResolveAction')
  final String? resolveAction;

  @JsonKey(name: 'SolverDate')
  final String? solverDate;

  @JsonKey(name: 'SolverId')
  final String? solverId;

  @JsonKey(name: 'Status')
  final String status;

  @JsonKey(name: 'Files')
  final List<IncidentFileModel> files;

  IncidentRequestModel({
    this.action,
    required this.areasId,
    required this.description,
    this.feedback,
    required this.idIncidentType,
    required this.reporterDate,
    required this.reporterId,
    this.resolveAction,
    this.solverDate,
    this.solverId,
    required this.status,
    required this.files,
  });

  factory IncidentRequestModel.fromJson(Map<String, dynamic> json) =>
      _$IncidentRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$IncidentRequestModelToJson(this);
}

@JsonSerializable()
class IncidentFileModel {
  @JsonKey(name: 'Filename')
  final String filename;

  @JsonKey(name: 'MimeType')
  final String mimeType;

  @JsonKey(name: 'Base64')
  final String base64;

  IncidentFileModel({
    required this.filename,
    required this.mimeType,
    required this.base64,
  });

  factory IncidentFileModel.fromJson(Map<String, dynamic> json) =>
      _$IncidentFileModelFromJson(json);

  Map<String, dynamic> toJson() => _$IncidentFileModelToJson(this);
}

