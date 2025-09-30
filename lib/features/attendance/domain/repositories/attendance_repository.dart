import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/attendance.dart';
import '../entities/attendance_request.dart';

abstract class AttendanceRepository {
  /// Submit attendance record
  Future<Either<Failure, Attendance>> submitAttendance(Attendance attendance);

  /// Get attendance records for a specific user
  Future<Either<Failure, List<Attendance>>> getAttendanceHistory(String userId);

  /// Get attendance record by ID
  Future<Either<Failure, Attendance>> getAttendanceById(String attendanceId);

  /// Check if user has already checked in today
  Future<Either<Failure, bool>> hasCheckedInToday(String userId);

  /// Get user's current attendance status
  Future<Either<Failure, Attendance?>> getCurrentAttendanceStatus(
      String userId);

  /// Update attendance approval status
  Future<Either<Failure, Attendance>> updateAttendanceStatus({
    required String attendanceId,
    required AttendanceStatus status,
    String? rejectionReason,
    String? approvedBy,
  });

  /// Get pending approvals for a specific role
  Future<Either<Failure, List<Attendance>>> getPendingApprovals(
      String userRole);

  /// Validate attendance data
  Future<Either<Failure, bool>> validateAttendanceData(Attendance attendance);

  /// Check in user with provided data
  Future<Either<Failure, Attendance>> checkIn(CheckInRequest request);

  /// Check out user with provided data
  Future<Either<Failure, Attendance>> checkOut(CheckOutRequest request);

  /// Validate location for check in/out
  Future<Either<Failure, bool>> validateLocation(
    String currentLocation,
    String requiredLocation,
  );
}
