import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/patrol_route.dart';
import '../entities/patrol_location.dart';
import '../entities/patrol_attendance.dart';
import '../entities/patrol_progress.dart';

abstract class PatrolRepository {
  Future<Either<Failure, List<PatrolRoute>>> getPatrolRoutes();
  Future<Either<Failure, PatrolRoute>> getPatrolRouteById(String id);
  Future<Either<Failure, PatrolProgress>> getPatrolProgress(String routeId);
  Future<Either<Failure, bool>> submitAttendance(PatrolAttendance attendance);
  Future<Either<Failure, bool>> verifyLocation(double currentLat, double currentLng, double targetLat, double targetLng);
  Future<Either<Failure, PatrolLocation>> addPatrolLocation(String routeId, PatrolLocation location);
  Future<Either<Failure, String>> uploadProofImage(String imagePath);
  Future<Either<Failure, String>> getCurrentLocation();
}