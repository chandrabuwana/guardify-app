import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_remote_data_source.dart';
import '../datasources/attendance_local_data_source.dart';
import '../models/attendance_model.dart';

@Injectable(as: AttendanceRepository)
class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource remoteDataSource;
  final AttendanceLocalDataSource localDataSource;

  AttendanceRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Attendance>> submitAttendance(
      Attendance attendance) async {
    try {
      final attendanceModel = AttendanceModel.fromEntity(attendance);
      final result = await remoteDataSource.submitAttendance(attendanceModel);

      // Cache the submitted attendance
      await localDataSource.cacheLastAttendance(result);

      return Right(result.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<Attendance>>> getAttendanceHistory(
      String userId) async {
    try {
      final result = await remoteDataSource.getAttendanceHistory(userId);

      // Cache the result
      await localDataSource.cacheAttendanceHistory(result);

      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      // Try to get cached data on network failure
      try {
        final cachedResult = await localDataSource.getCachedAttendanceHistory();
        if (cachedResult.isNotEmpty) {
          return Right(cachedResult.map((model) => model.toEntity()).toList());
        }
      } catch (_) {}

      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, Attendance>> getAttendanceById(
      String attendanceId) async {
    try {
      final result = await remoteDataSource.getAttendanceById(attendanceId);
      return Right(result.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> hasCheckedInToday(String userId) async {
    try {
      final result = await remoteDataSource.hasCheckedInToday(userId);
      return Right(result);
    } catch (e) {
      // Try to check from local cache
      try {
        final lastAttendance = await localDataSource.getLastAttendance();
        if (lastAttendance != null) {
          final today = DateTime.now();
          final attendanceDate = lastAttendance.timestamp;
          final isSameDay = today.year == attendanceDate.year &&
              today.month == attendanceDate.month &&
              today.day == attendanceDate.day;

          return Right(
              isSameDay && lastAttendance.type == AttendanceType.clockIn);
        }
      } catch (_) {}

      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, Attendance?>> getCurrentAttendanceStatus(
      String userId) async {
    try {
      final result = await remoteDataSource.getCurrentAttendanceStatus(userId);
      return Right(result?.toEntity());
    } catch (e) {
      // Try to get from local cache
      try {
        final lastAttendance = await localDataSource.getLastAttendance();
        return Right(lastAttendance?.toEntity());
      } catch (_) {}

      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, Attendance>> updateAttendanceStatus({
    required String attendanceId,
    required AttendanceStatus status,
    String? rejectionReason,
    String? approvedBy,
  }) async {
    try {
      final result = await remoteDataSource.updateAttendanceStatus(
        attendanceId: attendanceId,
        status: status,
        rejectionReason: rejectionReason,
        approvedBy: approvedBy,
      );
      return Right(result.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<Attendance>>> getPendingApprovals(
      String userRole) async {
    try {
      final result = await remoteDataSource.getPendingApprovals(userRole);
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> validateAttendanceData(
      Attendance attendance) async {
    try {
      // Perform local validation
      if (attendance.personalClothing.isEmpty ||
          attendance.securityReport.isEmpty ||
          attendance.guardLocation.isEmpty ||
          attendance.currentLocation.isEmpty ||
          attendance.patrolRoute.isEmpty) {
        return const Left(ValidationFailure('Semua field harus diisi'));
      }

      if (attendance.isLate) {
        return const Left(TimeValidationFailure('Terlambat absen'));
      }

      if (!attendance.isLocationValid) {
        return const Left(LocationFailure('Lokasi tidak sesuai'));
      }

      return const Right(true);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  Failure _handleException(dynamic exception) {
    if (exception.toString().contains('Network')) {
      return NetworkFailure(exception.toString());
    } else if (exception.toString().contains('Unauthorized')) {
      return const AuthenticationFailure('Session expired');
    } else if (exception.toString().contains('Forbidden')) {
      return const AuthorizationFailure('Access denied');
    } else if (exception.toString().contains('Bad request')) {
      return ValidationFailure(exception.toString());
    } else {
      return ServerFailure(exception.toString());
    }
  }
}
