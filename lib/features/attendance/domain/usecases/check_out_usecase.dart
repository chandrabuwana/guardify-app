import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/attendance.dart';
import '../entities/attendance_request.dart';
import '../repositories/attendance_repository.dart';

@injectable
class CheckOutUseCase {
  final AttendanceRepository repository;

  CheckOutUseCase(this.repository);

  Future<Either<Failure, Attendance>> call(CheckOutRequest request) async {
    // Get current attendance status to validate check out
    final currentStatus =
        await repository.getCurrentAttendanceStatus(request.userId);

    return currentStatus.fold(
      (failure) => Left(failure),
      (attendance) async {
        if (attendance == null) {
          return Left(ValidationFailure('Tidak ada sesi check in yang aktif'));
        }

        if (attendance.type == AttendanceType.clockOut) {
          return Left(ValidationFailure('Anda sudah melakukan check out'));
        }

        // Validate task completion if required
        if (request.statusTugas == 'tidak selesai') {
          // You can add additional validation here if needed
          // For now, we'll allow check out even with incomplete tasks
        }

        return await repository.checkOut(request);
      },
    );
  }
}

class ValidationFailure extends Failure {
  ValidationFailure(String message) : super(message);
}
