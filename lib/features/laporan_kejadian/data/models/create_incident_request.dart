import 'package:json_annotation/json_annotation.dart';

part 'create_incident_request.g.dart';

/// Request model untuk Create Incident API
@JsonSerializable()
class CreateIncidentRequest {
  @JsonKey(name: 'AreasDescription')
  final String areasDescription;

  @JsonKey(name: 'AreasId')
  final String areasId;

  @JsonKey(name: 'IdIncidentType')
  final int idIncidentType;

  @JsonKey(name: 'IncidentDate')
  final DateTime incidentDate;

  @JsonKey(name: 'IncidentTime')
  final String incidentTime; // Format: HH:mm:ss

  @JsonKey(name: 'IncidentDescription')
  final String incidentDescription;

  @JsonKey(name: 'NotesAction')
  final String? notesAction;

  @JsonKey(name: 'PicId')
  final String? picId;

  @JsonKey(name: 'PjId')
  final String? pjId;

  @JsonKey(name: 'ReportId')
  final String reportId;

  @JsonKey(name: 'SolvedAction')
  final String? solvedAction;

  @JsonKey(name: 'SolvedDate')
  final DateTime? solvedDate;

  @JsonKey(name: 'Status')
  final String status;

  CreateIncidentRequest({
    required this.areasDescription,
    required this.areasId,
    required this.idIncidentType,
    required this.incidentDate,
    required this.incidentTime,
    required this.incidentDescription,
    this.notesAction,
    this.picId,
    this.pjId,
    required this.reportId,
    this.solvedAction,
    this.solvedDate,
    required this.status,
  });

  factory CreateIncidentRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateIncidentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateIncidentRequestToJson(this);
}

