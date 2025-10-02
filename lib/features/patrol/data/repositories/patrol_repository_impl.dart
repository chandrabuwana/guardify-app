import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/patrol_route.dart';
import '../../domain/entities/patrol_location.dart';
import '../../domain/entities/patrol_attendance.dart';
import '../../domain/entities/patrol_progress.dart';
import '../../domain/repositories/patrol_repository.dart';
import '../datasources/patrol_remote_data_source.dart';
import '../models/patrol_attendance_model.dart';
import '../models/patrol_location_model.dart';

@Injectable(as: PatrolRepository)
class PatrolRepositoryImpl implements PatrolRepository {
  final PatrolRemoteDataSource remoteDataSource;

  PatrolRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<PatrolRoute>>> getPatrolRoutes() async {
    try {
      final routes = await remoteDataSource.getPatrolRoutes();
      return Right(routes);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PatrolRoute>> getPatrolRouteById(String id) async {
    try {
      final route = await remoteDataSource.getPatrolRouteById(id);
      return Right(route);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PatrolProgress>> getPatrolProgress(String routeId) async {
    try {
      final progressData = await remoteDataSource.getPatrolProgress(routeId);
      final progress = PatrolProgress(
        completedCount: progressData['completed'] ?? 0,
        totalCount: progressData['total'] ?? 0,
      );
      return Right(progress);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> submitAttendance(PatrolAttendance attendance) async {
    try {
      final attendanceModel = PatrolAttendanceModel(
        id: attendance.id,
        patrolLocationId: attendance.patrolLocationId,
        userId: attendance.userId,
        timestamp: attendance.timestamp,
        currentLatitude: attendance.currentLatitude,
        currentLongitude: attendance.currentLongitude,
        currentAddress: attendance.currentAddress,
        proofImagePath: attendance.proofImagePath,
        notes: attendance.notes,
        isLocationVerified: attendance.isLocationVerified,
        status: attendance.status,
      );

      final result = await remoteDataSource.submitAttendance(attendanceModel);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyLocation(
    double currentLat,
    double currentLng,
    double targetLat,
    double targetLng,
  ) async {
    try {
      final result = await remoteDataSource.verifyLocation(
        currentLat,
        currentLng,
        targetLat,
        targetLng,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PatrolLocation>> addPatrolLocation(
    String routeId,
    PatrolLocation location,
  ) async {
    try {
      final locationModel = PatrolLocationModel(
        id: location.id,
        name: location.name,
        description: location.description,
        latitude: location.latitude,
        longitude: location.longitude,
        address: location.address,
        status: location.status,
        completedAt: location.completedAt,
        proofImagePath: location.proofImagePath,
        notes: location.notes,
        isAdditional: location.isAdditional,
      );

      final result = await remoteDataSource.addPatrolLocation(routeId, locationModel);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProofImage(String imagePath) async {
    try {
      final result = await remoteDataSource.uploadProofImage(imagePath);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getCurrentLocation() async {
    try {
      // Mock current location for development
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock location coordinates (Jakarta area)
      const mockLat = -6.2088;
      const mockLng = 106.8456;
      
      final address = 'Current Location: $mockLat, $mockLng';
      return Right(address);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}