import 'package:injectable/injectable.dart';
import '../entities/cuti_entity.dart';
import '../repositories/cuti_repository.dart';

class GetRekapCutiParams {
  final DateTime? tanggalMulai;
  final DateTime? tanggalSelesai;
  final String? status;
  final String? tipeCuti;

  GetRekapCutiParams({
    this.tanggalMulai,
    this.tanggalSelesai,
    this.status,
    this.tipeCuti,
  });
}

@injectable
class GetRekapCuti {
  final CutiRepository repository;

  GetRekapCuti(this.repository);

  Future<List<CutiEntity>> call(GetRekapCutiParams params) async {
    return await repository.getRekapCuti(
      tanggalMulai: params.tanggalMulai,
      tanggalSelesai: params.tanggalSelesai,
      status: params.status,
      tipeCuti: params.tipeCuti,
    );
  }
}
