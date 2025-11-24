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
    // Validasi checkout sudah dilakukan di home_page melalui /Shift/get_current
    // yang mengecek Checkin: true dan Checkout: false
    // Tidak perlu lagi validasi melalui getCurrentAttendanceStatus karena endpoint tidak ada di backend
    
    // Validate task completion if required
    if (request.statusTugas == 'tidak selesai') {
      // You can add additional validation here if needed
      // For now, we'll allow check out even with incomplete tasks
    }

    return await repository.checkOut(request);
  }
}

class ValidationFailure extends Failure {
  ValidationFailure(String message) : super(message);
}
