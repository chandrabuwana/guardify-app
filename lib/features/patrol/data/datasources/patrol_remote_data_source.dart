import '../models/patrol_route_model.dart';
import '../models/patrol_location_model.dart';
import '../models/patrol_attendance_model.dart';

abstract class PatrolRemoteDataSource {
  Future<List<PatrolRouteModel>> getPatrolRoutes();
  Future<PatrolRouteModel> getPatrolRouteById(String id);
  Future<Map<String, int>> getPatrolProgress(String routeId);
  Future<bool> submitAttendance(PatrolAttendanceModel attendance);
  Future<bool> verifyLocation(double currentLat, double currentLng, double targetLat, double targetLng);
  Future<PatrolLocationModel> addPatrolLocation(String routeId, PatrolLocationModel location);
  Future<String> uploadProofImage(String imagePath);
}