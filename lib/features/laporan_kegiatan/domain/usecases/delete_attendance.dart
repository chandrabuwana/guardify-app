import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/laporan_kegiatan_repository.dart';

/// Use case untuk delete attendance (mark as tidak masuk)
@injectable
class DeleteAttendance {
  final LaporanKegiatanRepository repository;

  DeleteAttendance(this.repository);

  Future<Either<Failure, bool>> call(String attendanceId) async {
    return await repository.deleteAttendance(attendanceId);
  }
}
