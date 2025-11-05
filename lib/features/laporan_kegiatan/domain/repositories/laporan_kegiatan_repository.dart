import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/constants/enums.dart';
import '../entities/laporan_kegiatan_entity.dart';

/// Repository interface untuk Laporan Kegiatan
abstract class LaporanKegiatanRepository {
  /// Get list laporan kegiatan berdasarkan status dan role
  Future<Either<Failure, List<LaporanKegiatanEntity>>> getLaporanList({
    LaporanStatus? status,
    UserRole? role,
    String? userId,
  });

  /// Get detail laporan kegiatan by ID
  Future<Either<Failure, LaporanKegiatanEntity>> getLaporanDetail(String id);

  /// Update status laporan kegiatan (approve/reject/revisi)
  Future<Either<Failure, LaporanKegiatanEntity>> updateStatusLaporan({
    required String id,
    required LaporanStatus status,
    required String reviewerId,
    required String reviewerName,
    String? umpanBalik,
  });

  /// Accept laporan kegiatan (shortcut untuk approve)
  Future<Either<Failure, LaporanKegiatanEntity>> acceptLaporan(String id);

  /// Request revisi laporan kegiatan
  Future<Either<Failure, LaporanKegiatanEntity>> requestRevisi({
    required String id,
    required String note,
  });

  /// Get laporan list untuk anggota/danton (own reports)
  Future<Either<Failure, List<LaporanKegiatanEntity>>> getMyLaporanList(
    String userId,
  );

  /// Get laporan list untuk supervisor (all reports under their supervision)
  Future<Either<Failure, List<LaporanKegiatanEntity>>>
      getSupervisedLaporanList({
    required String supervisorId,
    LaporanStatus? status,
  });
}
