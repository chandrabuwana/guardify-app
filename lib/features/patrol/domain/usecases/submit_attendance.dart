import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/patrol_attendance.dart';
import '../repositories/patrol_repository.dart';

@injectable
class SubmitAttendance {
  final PatrolRepository repository;

  SubmitAttendance(this.repository);

  Future<Either<Failure, bool>> call(PatrolAttendance attendance) async {
    return await repository.submitAttendance(attendance);
  }
}