import 'package:injectable/injectable.dart';
import '../entities/cuti_entity.dart';
import '../repositories/cuti_repository.dart';

class FilterCutiParams {
  final String? status;
  final String? tipeCuti;
  final DateTime? tanggalMulai;
  final DateTime? tanggalSelesai;
  final String? userId;

  FilterCutiParams({
    this.status,
    this.tipeCuti,
    this.tanggalMulai,
    this.tanggalSelesai,
    this.userId,
  });
}

@injectable
class FilterCuti {
  final CutiRepository repository;

  FilterCuti(this.repository);

  Future<List<CutiEntity>> call(FilterCutiParams params) async {
    return await repository.filterCuti(
      status: params.status,
      tipeCuti: params.tipeCuti,
      tanggalMulai: params.tanggalMulai,
      tanggalSelesai: params.tanggalSelesai,
      userId: params.userId,
    );
  }
}
