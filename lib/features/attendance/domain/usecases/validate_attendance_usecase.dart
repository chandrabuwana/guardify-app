import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/attendance.dart';
import '../entities/attendance_validation_rules.dart';
import '../repositories/attendance_repository.dart';

@injectable
class ValidateAttendanceUseCase {
  final AttendanceRepository repository;

  ValidateAttendanceUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required DateTime currentTime,
    required ShiftType shiftType,
    required String guardLocation,
    required String currentLocation,
    required String personalClothing,
    required String securityReport,
    required String patrolRoute,
    required UserRole userRole,
  }) async {
    // Create validation rules
    final morningCutoff = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
      7,
      10,
    );

    final nightCutoff = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
      19,
      10,
    );

    final rules = AttendanceValidationRules(
      shiftType: shiftType,
      morningCutoffTime: morningCutoff,
      nightCutoffTime: nightCutoff,
    );

    // Validate time
    if (!rules.isTimeValid(currentTime)) {
      if (shiftType == ShiftType.morning) {
        return const Left(TimeValidationFailure(
          'Terlambat. Melebihi batas absen shift pagi',
        ));
      } else {
        return const Left(TimeValidationFailure(
          'Terlambat. Melebihi batas absen shift malam',
        ));
      }
    }

    // Validate location
    if (guardLocation.toLowerCase() != currentLocation.toLowerCase()) {
      return const Left(LocationFailure(
        'Di luar area penjagaan, harap dekati lokasi.',
      ));
    }

    // Validate required fields
    if (personalClothing.trim().isEmpty) {
      return const Left(ValidationFailure('Pakaian Personil harus diisi'));
    }

    if (securityReport.trim().isEmpty) {
      return const Left(ValidationFailure('Laporan Pengamanan harus diisi'));
    }

    if (patrolRoute.trim().isEmpty) {
      return const Left(ValidationFailure('Rute Patroli harus diisi'));
    }

    // Validate user authorization
    if (!rules.isUserAuthorized(userRole)) {
      return const Left(AuthorizationFailure(
        'Anda tidak memiliki akses untuk melakukan absensi ini',
      ));
    }

    return const Right('Verifikasi lokasi dan waktu berhasil.');
  }
}
