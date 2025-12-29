import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/attendance_rekap_request_entity.dart';
import '../entities/attendance_rekap_response_entity.dart';
import '../entities/attendance_rekap_detail_response_entity.dart';
import '../entities/attendance_update_request.dart';

abstract class AttendanceRekapRepository {
  Future<Either<Failure, AttendanceRekapResponseEntity>> getRekap(
      AttendanceRekapRequestEntity request);
  
  Future<Either<Failure, AttendanceRekapDetailResponseEntity>> getDetail(
      String idAttendance);
  
  Future<Either<Failure, void>> updateAttendance(
      AttendanceUpdateRequest request);
}

