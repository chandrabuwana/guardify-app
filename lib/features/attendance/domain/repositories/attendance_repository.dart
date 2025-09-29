import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/attendance.dart';

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
}
