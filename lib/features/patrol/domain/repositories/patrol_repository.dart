import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/domain/entities/paginated_response.dart';
import '../entities/patrol_route.dart';
import '../entities/patrol_location.dart';
import '../entities/patrol_attendance.dart';
import '../entities/patrol_progress.dart';

abstract class PatrolRepository {
  /// Get paginated patrol routes from API (using /Route/list for home)
  Future<Either<Failure, PaginatedResponse<PatrolRoute>>>
      getPatrolRoutesPaginated({
    required int page,
    required int pageSize,
  });

  /// Get route detail by ID with all locations (using /RouteDetail/list)
  Future<Either<Failure, PatrolRoute>> getRouteDetailById(String routeId);

  Future<Either<Failure, List<PatrolRoute>>> getPatrolRoutes();
  Future<Either<Failure, PatrolRoute>> getPatrolRouteById(String id);
  Future<Either<Failure, PatrolProgress>> getPatrolProgress(String routeId);
  Future<Either<Failure, bool>> submitAttendance(PatrolAttendance attendance);
  Future<Either<Failure, bool>> verifyLocation(
      double currentLat, double currentLng, double targetLat, double targetLng);
  Future<Either<Failure, PatrolLocation>> addPatrolLocation(
      String routeId, PatrolLocation location);
  Future<Either<Failure, String>> uploadProofImage(String imagePath);
  Future<Either<Failure, String>> getCurrentLocation();

  /// Get areas list filtered by IdAreas
  Future<Either<Failure, List<PatrolLocation>>> getAreasByIdAreas(String idAreas);

  /// Get all areas list (for dropdown in add location form)
  Future<Either<Failure, List<PatrolLocation>>> getAllAreas();

  /// Submit patrol check point
  Future<Either<Failure, bool>> submitCheckPoint({
    required String idShiftDetail,
    required String idAreas,
    String? photoPath,
    required double latitude,
    required double longitude,
  });

  /// Insert attendance detail for patrol location
  Future<Either<Failure, bool>> insertAttendanceDetail({
    required String idShiftDetail,
    required String device,
    required String idAreas,
    String? photoPath,
    required double latitude,
    required String locationName,
    required double longitude,
  });
}
