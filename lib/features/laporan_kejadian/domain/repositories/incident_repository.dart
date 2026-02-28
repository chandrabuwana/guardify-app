import '../entities/incident_entity.dart';
import '../entities/incident_location_entity.dart';
import '../entities/incident_type_entity.dart';

abstract class IncidentRepository {
  /// Get list of incidents with pagination
  Future<List<IncidentEntity>> getIncidentList({
    int start = 0,
    int length = 10,
    String? searchQuery,
    IncidentStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    String? picId,
    String? incidentTypeId,
    String? locationId,
  });

  /// Get list of my tasks (incidents assigned to current user)
  Future<List<IncidentEntity>> getMyTasks({
    int start = 0,
    int length = 10,
    String? searchQuery,
    IncidentStatus? status,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get incident detail by ID
  Future<IncidentEntity> getIncidentDetail(String incidentId);

  /// Create new incident report
  Future<IncidentEntity> createIncidentReport({
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
  Future<List<IncidentLocationEntity>> getIncidentLocations();

  /// Get list of incident types
  Future<List<IncidentTypeEntity>> getIncidentTypes();

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
    String? actionTakenNote,
    String? solvedAction,
    DateTime? solvedDate,
    String? evidence,
    required String status,
    Map<String, dynamic>? incidentImage,
    String? supervisorFeedback,
  });
}

