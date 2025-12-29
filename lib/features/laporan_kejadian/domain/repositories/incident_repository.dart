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
  });

  /// Get list of my tasks (incidents assigned to current user)
  Future<List<IncidentEntity>> getMyTasks({
    int start = 0,
    int length = 10,
    String? searchQuery,
    IncidentStatus? status,
  });

  /// Get incident detail by ID
  Future<IncidentEntity> getIncidentDetail(String incidentId);

  /// Create new incident report
  Future<IncidentEntity> createIncidentReport({
    required String reporterId,
    required DateTime tanggalInsiden,
    required DateTime jamInsiden,
    required String lokasiInsidenId,
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
}

