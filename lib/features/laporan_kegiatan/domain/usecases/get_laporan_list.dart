import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/constants/enums.dart';
import '../entities/laporan_kegiatan_entity.dart';
import '../repositories/laporan_kegiatan_repository.dart';

/// Use case untuk get list laporan kegiatan
@injectable
class GetLaporanList {
  final LaporanKegiatanRepository repository;

  GetLaporanList(this.repository);

  Future<Either<Failure, List<LaporanKegiatanEntity>>> call({
    LaporanStatus? status,
    UserRole? role,
    String? userId,
  }) async {
    return await repository.getLaporanList(
      status: status,
      role: role,
      userId: userId,
    );
  }
}
