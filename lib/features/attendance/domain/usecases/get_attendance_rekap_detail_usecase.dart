import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/attendance_rekap_detail_response_entity.dart';
import '../repositories/attendance_rekap_repository.dart';

@injectable
class GetAttendanceRekapDetailUseCase {
  final AttendanceRekapRepository repository;

  GetAttendanceRekapDetailUseCase(this.repository);

  Future<Either<Failure, AttendanceRekapDetailResponseEntity>> call(
      String idAttendance) async {
    return await repository.getDetail(idAttendance);
  }
}

