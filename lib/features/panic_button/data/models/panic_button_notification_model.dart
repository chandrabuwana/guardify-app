import 'panic_button_area_model.dart';
import 'panic_button_incident_type_model.dart';
import 'panic_button_reporter_model.dart';
import 'panic_button_file_model.dart';

/// Model for Panic Button notification from Firebase
/// This model represents the data structure sent in Firebase notification
class PanicButtonNotificationModel {
  final String? id;
  final String? action;
  final String? areasId;
  final PanicButtonAreaModel? areas;
  final String? createBy;
  final String? createDate;
  final String? description;
  final String? feedback;
  final int? idIncidentType;
  final PanicButtonIncidentTypeModel? incidentType;
  final String? reporterDate;
  final String? reporterId;
  final PanicButtonReporterModel? reporter;
  final String? resolveAction;
  final String? solverDate;
  final String? solverId;
  final PanicButtonReporterModel? solver;
  final String? status;
  final String? updateBy;
  final String? updateDate;
  final List<PanicButtonFileModel>? files;
  final bool? isOpen;

  PanicButtonNotificationModel({
    this.id,
    this.action,
    this.areasId,
    this.areas,
    this.createBy,
    this.createDate,
    this.description,
    this.feedback,
    this.idIncidentType,
    this.incidentType,
    this.reporterDate,
    this.reporterId,
    this.reporter,
    this.resolveAction,
    this.solverDate,
    this.solverId,
    this.solver,
    this.status,
    this.updateBy,
    this.updateDate,
    this.files,
    this.isOpen,
  });

  factory PanicButtonNotificationModel.fromJson(Map<String, dynamic> json) {
    try {
      return PanicButtonNotificationModel(
        id: json['Id']?.toString(),
        action: json['Action']?.toString(),
        areasId: json['AreasId']?.toString(),
        areas: json['Areas'] != null 
            ? PanicButtonAreaModel.fromJson(json['Areas'] as Map<String, dynamic>)
            : null,
        createBy: json['CreateBy']?.toString(),
        createDate: json['CreateDate']?.toString(),
        description: json['Description']?.toString(),
        feedback: json['Feedback']?.toString(),
        idIncidentType: json['IdIncidentType'] as int?,
        incidentType: json['IncidentType'] != null
            ? PanicButtonIncidentTypeModel.fromJson(json['IncidentType'] as Map<String, dynamic>)
            : null,
        reporterDate: json['ReporterDate']?.toString(),
        reporterId: json['ReporterId']?.toString(),
        reporter: json['Reporter'] != null
            ? PanicButtonReporterModel.fromJson(json['Reporter'] as Map<String, dynamic>)
            : null,
        resolveAction: json['ResolveAction']?.toString(),
        solverDate: json['SolverDate']?.toString(),
        solverId: json['SolverId']?.toString(),
        solver: json['Solver'] != null
            ? PanicButtonReporterModel.fromJson(json['Solver'] as Map<String, dynamic>)
            : null,
        status: json['Status']?.toString(),
        updateBy: json['UpdateBy']?.toString(),
        updateDate: json['UpdateDate']?.toString(),
        files: json['Files'] != null
            ? (json['Files'] as List)
                .map((e) => PanicButtonFileModel.fromJson(e as Map<String, dynamic>))
                .toList()
            : null,
        isOpen: json['IsOpen'] as bool?,
      );
    } catch (e) {
      print('⚠️ Error parsing PanicButtonNotificationModel: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Action': action,
      'AreasId': areasId,
      'Areas': areas?.toJson(),
      'CreateBy': createBy,
      'CreateDate': createDate,
      'Description': description,
      'Feedback': feedback,
      'IdIncidentType': idIncidentType,
      'IncidentType': incidentType?.toJson(),
      'ReporterDate': reporterDate,
      'ReporterId': reporterId,
      'Reporter': reporter?.toJson(),
      'ResolveAction': resolveAction,
      'SolverDate': solverDate,
      'SolverId': solverId,
      'Solver': solver?.toJson(),
      'Status': status,
      'UpdateBy': updateBy,
      'UpdateDate': updateDate,
      'Files': files?.map((e) => e.toJson()).toList(),
      'IsOpen': isOpen,
    };
  }
}
