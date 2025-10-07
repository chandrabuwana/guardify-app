import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/laporan_kegiatan_entity.dart';
import '../repositories/laporan_kegiatan_repository.dart';

/// Use case untuk get detail laporan kegiatan
@injectable
class GetLaporanDetail {
  final LaporanKegiatanRepository repository;

  GetLaporanDetail(this.repository);

  Future<Either<Failure, LaporanKegiatanEntity>> call(String id) async {
    return await repository.getLaporanDetail(id);
  }
}
