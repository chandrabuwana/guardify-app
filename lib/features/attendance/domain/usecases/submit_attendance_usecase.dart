import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/attendance.dart';
import '../repositories/attendance_repository.dart';

@injectable
class SubmitAttendanceUseCase {
  final AttendanceRepository repository;

  SubmitAttendanceUseCase(this.repository);

  Future<Either<Failure, Attendance>> call(Attendance attendance) async {
    // Validate time constraints
    if (attendance.isLate) {
      return const Left(TimeValidationFailure(
        'Terlambat. Melebihi batas absen shift pagi',
      ));
    }

    // Validate location
    if (!attendance.isLocationValid) {
      return const Left(LocationFailure(
        'Di luar area penjagaan, harap dekati lokasi.',
      ));
    }

    // Validate required fields
    if (attendance.personalClothing.isEmpty ||
        attendance.securityReport.isEmpty ||
        attendance.guardLocation.isEmpty ||
        attendance.currentLocation.isEmpty ||
        attendance.patrolRoute.isEmpty) {
      return const Left(ValidationFailure(
        'Semua field harus diisi',
      ));
    }

    // Submit attendance
    return await repository.submitAttendance(attendance);
  }
}
