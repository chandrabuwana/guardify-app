import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/attendance.dart';
import '../entities/attendance_request.dart';
import '../repositories/attendance_repository.dart';

@injectable
class CheckInUseCase {
  final AttendanceRepository repository;

  CheckInUseCase(this.repository);

  Future<Either<Failure, Attendance>> call(CheckInRequest request) async {
    // Validate location first
    final locationValidation = await repository.validateLocation(
      request.lokasiTerkini,
      request.lokasiPenugasan,
    );

    return locationValidation.fold(
      (failure) => Left(failure),
      (isValid) async {
        if (!isValid) {
          return Left(LocationFailure('Lokasi tidak valid'));
        }

        // Check if user already checked in today
        final alreadyCheckedIn =
            await repository.hasCheckedInToday(request.userId);

        return alreadyCheckedIn.fold(
          (failure) => Left(failure),
          (hasCheckedIn) async {
            if (hasCheckedIn) {
              return Left(
                  ValidationFailure('Anda sudah melakukan check in hari ini'));
            }

            return await repository.checkIn(request);
          },
        );
      },
    );
  }
}

class LocationFailure extends Failure {
  LocationFailure(String message) : super(message);
}

class ValidationFailure extends Failure {
  ValidationFailure(String message) : super(message);
}
