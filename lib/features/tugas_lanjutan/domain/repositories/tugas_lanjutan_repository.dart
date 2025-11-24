import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/tugas_lanjutan_entity.dart';

/// Repository interface untuk Tugas Lanjutan
abstract class TugasLanjutanRepository {
  /// Get list tugas lanjutan
  /// - filterByToday: true untuk tugas hari ini, false untuk riwayat
  Future<Either<Failure, List<TugasLanjutanEntity>>> getTugasLanjutanList({
    bool filterByToday = false,
    String? userId,
  });

  /// Get detail tugas lanjutan by ID
  Future<Either<Failure, TugasLanjutanEntity>> getTugasLanjutanDetail(
    String id,
  );

  /// Selesaikan tugas lanjutan
  Future<Either<Failure, TugasLanjutanEntity>> selesaikanTugas({
    required String id,
    required String lokasi,
    required String buktiUrl,
    String? catatan,
    required String userId,
    required String userName,
  });

  /// Get progress summary (untuk home page)
  Future<Either<Failure, Map<String, dynamic>>> getProgressSummary({
    String? userId,
  });
}

