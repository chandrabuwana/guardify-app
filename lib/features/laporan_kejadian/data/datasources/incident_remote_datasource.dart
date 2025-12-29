import '../models/incident_model.dart';
import '../models/incident_location_model.dart';
import '../models/incident_type_model.dart';

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

  /// Create new incident report
  Future<IncidentModel> createIncidentReport({
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
}

