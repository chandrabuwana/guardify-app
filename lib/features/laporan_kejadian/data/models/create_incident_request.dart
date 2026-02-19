import 'package:json_annotation/json_annotation.dart';

part 'create_incident_request.g.dart';

/// Token model untuk Create Incident API
class TokenModel {
  final String id;
  final List<RoleModel> role;
  final String username;
  final String fullName;
  final String mail;

  TokenModel({
    required this.id,
    required this.role,
    required this.username,
    required this.fullName,
    required this.mail,
  });

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Role': role.map((r) => r.toJson()).toList(),
      'Username': username,
      'FullName': fullName,
      'Mail': mail,
    };
  }
}

/// Role model untuk Token
class RoleModel {
  final String id;
  final String nama;

  RoleModel({
    required this.id,
    required this.nama,
  });

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Nama': nama,
    };
  }
}

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

  @JsonKey(name: 'Token', includeToJson: false, includeFromJson: false)
  final TokenModel? token;

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
    this.token,
  });

  factory CreateIncidentRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateIncidentRequestFromJson(json);

  Map<String, dynamic> toJson() {
    final json = _$CreateIncidentRequestToJson(this);
    // Manually add Token if it exists
    if (token != null) {
      json['Token'] = token!.toJson();
    }
    return json;
  }
}

