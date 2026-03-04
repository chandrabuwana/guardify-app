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
    String? search,
    int start = 1,
    int length = 10,
    String? startDate,
    String? endDate,
  }) async {
    return await repository.getLaporanList(
      status: status,
      role: role,
      userId: userId,
      search: search,
      start: start,
      length: length,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
