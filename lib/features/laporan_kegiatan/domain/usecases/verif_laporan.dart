import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/laporan_kegiatan_repository.dart';

/// Use case untuk verifikasi laporan kegiatan menggunakan API Attendance/verif
@injectable
class VerifLaporan {
  final LaporanKegiatanRepository repository;

  VerifLaporan(this.repository);

  Future<Either<Failure, bool>> call({
    required String idAttendance,
    required bool isVerif,
    String? feedback,
  }) async {
    return await repository.verifLaporan(
      idAttendance: idAttendance,
      isVerif: isVerif,
      feedback: feedback,
    );
  }
}

