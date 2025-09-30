import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/attendance.dart';
import '../repositories/attendance_repository.dart';

enum UserAttendanceStatus {
  notCheckedIn, // Belum absen
  checkedIn, // Sedang bekerja
  checkedOut, // Sudah check out
}

class AttendanceStatusResult {
  final UserAttendanceStatus status;
  final Attendance? currentAttendance;

  AttendanceStatusResult({
    required this.status,
    this.currentAttendance,
  });
}

@injectable
class GetAttendanceStatusUseCase {
  final AttendanceRepository repository;

  GetAttendanceStatusUseCase(this.repository);

  Future<Either<Failure, AttendanceStatusResult>> call(String userId) async {
    final result = await repository.getCurrentAttendanceStatus(userId);

    return result.fold(
      (failure) => Left(failure),
      (attendance) {
        if (attendance == null) {
          return Right(AttendanceStatusResult(
            status: UserAttendanceStatus.notCheckedIn,
          ));
        }

        if (attendance.type == AttendanceType.clockIn) {
          return Right(AttendanceStatusResult(
            status: UserAttendanceStatus.checkedIn,
            currentAttendance: attendance,
          ));
        } else {
          return Right(AttendanceStatusResult(
            status: UserAttendanceStatus.checkedOut,
            currentAttendance: attendance,
          ));
        }
      },
    );
  }
}
