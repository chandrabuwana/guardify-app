import '../models/patrol_route_model.dart';
import '../models/patrol_location_model.dart';
import '../models/patrol_attendance_model.dart';
import '../models/route_detail_api_response.dart';
import '../models/route_list_api_response.dart';

abstract class PatrolRemoteDataSource {
  /// Get route list (for home page)
  Future<RouteListResponse> getRouteList({
    required int start,
    required int length,
    List<FilterModel>? filter,
    SortModel? sort,
  });

  /// Get route detail list with pagination
  Future<RouteDetailListResponse> getRouteDetailList({
    required int start,
    required int length,
    List<FilterModel>? filter,
    SortModel? sort,
  });

  Future<List<PatrolRouteModel>> getPatrolRoutes();
  Future<PatrolRouteModel> getPatrolRouteById(String id);
  Future<Map<String, int>> getPatrolProgress(String routeId);
  Future<bool> submitAttendance(PatrolAttendanceModel attendance);
  Future<bool> verifyLocation(
      double currentLat, double currentLng, double targetLat, double targetLng);
  Future<PatrolLocationModel> addPatrolLocation(
      String routeId, PatrolLocationModel location);
  Future<String> uploadProofImage(String imagePath);
}
