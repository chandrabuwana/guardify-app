import 'package:injectable/injectable.dart';
import '../entities/cuti_entity.dart';
import '../repositories/cuti_repository.dart';

class GetDaftarCutiAnggotaParams {
  final String? status;
  final String? tipeCuti;
  final DateTime? tanggalMulai;
  final DateTime? tanggalSelesai;

  GetDaftarCutiAnggotaParams({
    this.status,
    this.tipeCuti,
    this.tanggalMulai,
    this.tanggalSelesai,
  });
}

@injectable
class GetDaftarCutiAnggota {
  final CutiRepository repository;

  GetDaftarCutiAnggota(this.repository);

  Future<List<CutiEntity>> call(GetDaftarCutiAnggotaParams params) async {
    return await repository.getDaftarCutiAnggota(
      status: params.status,
      tipeCuti: params.tipeCuti,
      tanggalMulai: params.tanggalMulai,
      tanggalSelesai: params.tanggalSelesai,
    );
  }
}
