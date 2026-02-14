import '../models/incident_model.dart';
import '../models/incident_location_model.dart';
import '../models/incident_type_model.dart';
import '../models/incident_api_model.dart';

abstract class IncidentRemoteDataSource {
  /// Get list of incidents with pagination
  Future<List<IncidentModel>> getIncidentList({
    int start = 0,
    int length = 10,
    String? searchQuery,
    String? status,
  });

  /// Get list of my tasks (incidents assigned to current user)
  Future<List<IncidentModel>> getMyTasks({
    int start = 0,
    int length = 10,
    String? searchQuery,
    String? status,
  });

  /// Get incident detail by ID
  Future<IncidentModel> getIncidentDetail(String incidentId);

  /// Get raw incident detail API model by ID (for edit form)
  Future<IncidentApiModel> getIncidentDetailApiModel(String incidentId);

  /// Create new incident report
  Future<IncidentModel> createIncidentReport({
    required String reporterId,
    required DateTime tanggalInsiden,
    required DateTime jamInsiden,
    required String lokasiInsidenId,
    required String lokasiInsidenName,
    required String detailLokasiInsiden,
    required String tipeInsidenId,
    required String deskripsiInsiden,
    String? fotoInsiden,
    List<String>? fileUrls,
  });

  /// Get list of incident locations
  Future<List<IncidentLocationModel>> getIncidentLocations();

  /// Get list of incident types
  Future<List<IncidentTypeModel>> getIncidentTypes();

  /// Update incident status
  Future<bool> updateIncidentStatus({
    required String incidentId,
    required String status, // "PROGRESS" or "COMPLETED"
    String? notes,
    Map<String, dynamic>? file, // {Filename, MimeType, Base64}
  });

  /// Edit incident (for PJO/Deputy to assign)
  Future<bool> editIncident({
    required String incidentId,
    required String areasDescription,
    required String areasId,
    required int idIncidentType,
    required DateTime incidentDate,
    required String incidentTime,
    required String incidentDescription,
    required String reportId,
    String? notesAction,
    String? picId,
    String? pjId,
    String? solvedAction,
    DateTime? solvedDate,
    required String status,
  });

  /// Get user list for dropdown (Penanggung Jawab and Tim)
  Future<List<Map<String, String>>> getUserList();

  /// Update all incident (for PJO/Deputy to assign PIC and Team)
  Future<bool> updateAllIncident({
    required String incidentId,
    required String areasDescription,
    required String areasId,
    required int idIncidentType,
    required DateTime incidentDate,
    required String incidentTime,
    required String incidentDescription,
    required String reportId,
    String? notesAction,
    String? picId,
    required List<String> team,
    String? handlingTask,
    String? solvedAction,
    DateTime? solvedDate,
    String? evidence,
    required String status,
    Map<String, dynamic>? incidentImage, // {Filename, MimeType, Base64, FileSize}
  });
}

