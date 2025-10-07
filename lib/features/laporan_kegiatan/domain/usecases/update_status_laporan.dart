import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/laporan_kegiatan_entity.dart';
import '../repositories/laporan_kegiatan_repository.dart';

/// Use case untuk update status laporan kegiatan
@injectable
class UpdateStatusLaporan {
  final LaporanKegiatanRepository repository;

  UpdateStatusLaporan(this.repository);

  Future<Either<Failure, LaporanKegiatanEntity>> call({
    required String id,
    required LaporanStatus status,
    required String reviewerId,
    required String reviewerName,
    String? umpanBalik,
  }) async {
    return await repository.updateStatusLaporan(
      id: id,
      status: status,
      reviewerId: reviewerId,
      reviewerName: reviewerName,
      umpanBalik: umpanBalik,
    );
  }
}
