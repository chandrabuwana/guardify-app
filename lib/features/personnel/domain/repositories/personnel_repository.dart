import '../entities/personnel.dart';

abstract class PersonnelRepository {
  /// Get list personil berdasarkan status (Aktif, Pending, Non Aktif)
  Future<List<Personnel>> getPersonnelByStatus(String status, {int page = 1, int pageSize = 20});
  
  /// Get detail personil by ID
  Future<Personnel?> getPersonnelById(String personnelId);
  
  /// Search personil by name or NRP
  Future<List<Personnel>> searchPersonnel(String query, String status);
  
  /// Approve personil (update status from Pending to Aktif)
  Future<bool> approvePersonnel(String personnelId, String feedback);
  
  /// Revise personil (request revision)
  Future<bool> revisePersonnel(String personnelId, String feedback);
  
  /// Update status personil (Aktif, Pending, Non Aktif)
  Future<bool> updatePersonnelStatus(String personnelId, String newStatus);
}
