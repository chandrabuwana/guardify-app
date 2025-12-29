import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/attendance_update_request.dart';
import '../repositories/attendance_rekap_repository.dart';

@injectable
class UpdateAttendanceRekapUseCase {
  final AttendanceRekapRepository repository;

  UpdateAttendanceRekapUseCase(this.repository);

  Future<Either<Failure, void>> call(AttendanceUpdateRequest request) async {
    return await repository.updateAttendance(request);
  }
}

