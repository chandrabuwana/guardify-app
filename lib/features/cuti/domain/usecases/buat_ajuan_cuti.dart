import 'package:injectable/injectable.dart';
import '../entities/cuti_entity.dart';
import '../repositories/cuti_repository.dart';

class BuatAjuanCutiParams {
  final String userId;
  final String nama;
  final CutiType tipeCuti;
  final DateTime tanggalMulai;
  final DateTime tanggalSelesai;
  final String alasan;
  final int jumlahHari;

  BuatAjuanCutiParams({
    required this.userId,
    required this.nama,
    required this.tipeCuti,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.alasan,
    required this.jumlahHari,
  });
}

@injectable
class BuatAjuanCuti {
  final CutiRepository repository;

  BuatAjuanCuti(this.repository);

  Future<CutiEntity> call(BuatAjuanCutiParams params) async {
    return await repository.buatAjuanCuti(
      userId: params.userId,
      nama: params.nama,
      tipeCuti: params.tipeCuti,
      tanggalMulai: params.tanggalMulai,
      tanggalSelesai: params.tanggalSelesai,
      alasan: params.alasan,
      jumlahHari: params.jumlahHari,
    );
  }
}
