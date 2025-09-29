import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/attendance.dart';
import '../repositories/attendance_repository.dart';

@injectable
class CheckAttendanceStatusUseCase {
  final AttendanceRepository repository;

  CheckAttendanceStatusUseCase(this.repository);

  Future<Either<Failure, AttendanceCheckResult>> call(String userId) async {
    final hasCheckedInResult = await repository.hasCheckedInToday(userId);

    return hasCheckedInResult.fold(
      (failure) => Left(failure),
      (hasCheckedIn) async {
        if (hasCheckedIn) {
          final currentStatusResult =
              await repository.getCurrentAttendanceStatus(userId);
          return currentStatusResult.fold(
            (failure) => Left(failure),
            (attendance) => Right(AttendanceCheckResult(
              hasCheckedIn: true,
              currentAttendance: attendance,
            )),
          );
        } else {
          return const Right(AttendanceCheckResult(
            hasCheckedIn: false,
            currentAttendance: null,
          ));
        }
      },
    );
  }
}

class AttendanceCheckResult {
  final bool hasCheckedIn;
  final Attendance? currentAttendance;

  const AttendanceCheckResult({
    required this.hasCheckedIn,
    this.currentAttendance,
  });
}
