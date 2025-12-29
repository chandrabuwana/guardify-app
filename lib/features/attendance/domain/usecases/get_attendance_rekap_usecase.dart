import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/attendance_rekap_request_entity.dart';
import '../entities/attendance_rekap_response_entity.dart';
import '../repositories/attendance_rekap_repository.dart';

@injectable
class GetAttendanceRekapUseCase {
  final AttendanceRekapRepository repository;

  GetAttendanceRekapUseCase(this.repository);

  Future<Either<Failure, AttendanceRekapResponseEntity>> call(
      AttendanceRekapRequestEntity request) async {
    return await repository.getRekap(request);
  }
}

