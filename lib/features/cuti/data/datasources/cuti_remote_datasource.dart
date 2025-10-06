import 'package:injectable/injectable.dart';
import '../models/cuti_model.dart';
import '../models/cuti_kuota_model.dart';
import '../../domain/entities/cuti_entity.dart';

abstract class CutiRemoteDataSource {
  Future<CutiKuotaModel> getCutiKuota(String userId);
  Future<List<CutiModel>> getDaftarCutiSaya(String userId);
  Future<List<CutiModel>> getDaftarCutiAnggota({
    String? status,
    String? tipeCuti,
    DateTime? tanggalMulai,
    DateTime? tanggalSelesai,
  });
  Future<CutiModel> buatAjuanCuti({
    required String userId,
    required String nama,
    required CutiType tipeCuti,
    required DateTime tanggalMulai,
    required DateTime tanggalSelesai,
    required String alasan,
    required int jumlahHari,
  });
  Future<CutiModel> updateStatusCuti({
    required String cutiId,
    required CutiStatus status,
    required String reviewerId,
    required String reviewerName,
    String? umpanBalik,
  });
  Future<List<CutiModel>> filterCuti({
    String? status,
    String? tipeCuti,
    DateTime? tanggalMulai,
    DateTime? tanggalSelesai,
    String? userId,
  });
  Future<CutiModel> getDetailCuti(String cutiId);
  Future<List<CutiModel>> getRekapCuti({
    DateTime? tanggalMulai,
    DateTime? tanggalSelesai,
    String? status,
  });
}

@LazySingleton(as: CutiRemoteDataSource)
class CutiRemoteDataSourceImpl implements CutiRemoteDataSource {
  // Mock data untuk testing
  final List<CutiModel> _mockCutiData = [
    CutiModel(
      id: '1',
      nama: 'John Doe',
      userId: 'user_1',
      tipeCuti: CutiType.tahunan,
      tanggalMulai: DateTime(2025, 10, 15),
      tanggalSelesai: DateTime(2025, 10, 17),
      alasan: 'Liburan keluarga',
      status: CutiStatus.approved,
      umpanBalik: 'Disetujui untuk liburan keluarga',
      reviewerId: 'reviewer_1',
      reviewerName: 'Manager HR',
      tanggalPengajuan: DateTime(2025, 10, 1),
      tanggalReview: DateTime(2025, 10, 2),
      jumlahHari: 3,
    ),
    CutiModel(
      id: '2',
      nama: 'Jane Smith',
      userId: 'user_2',
      tipeCuti: CutiType.sakit,
      tanggalMulai: DateTime(2025, 10, 20),
      tanggalSelesai: DateTime(2025, 10, 22),
      alasan: 'Demam dan flu',
      status: CutiStatus.pending,
      tanggalPengajuan: DateTime(2025, 10, 19),
      jumlahHari: 3,
    ),
    CutiModel(
      id: '3',
      nama: 'Bob Wilson',
      userId: 'user_3',
      tipeCuti: CutiType.menikah,
      tanggalMulai: DateTime(2025, 11, 5),
      tanggalSelesai: DateTime(2025, 11, 7),
      alasan: 'Menikah',
      status: CutiStatus.approved,
      reviewerId: 'reviewer_1',
      reviewerName: 'Manager HR',
      tanggalPengajuan: DateTime(2025, 10, 15),
      tanggalReview: DateTime(2025, 10, 16),
      jumlahHari: 3,
    ),
    CutiModel(
      id: '4',
      nama: 'Alice Brown',
      userId: 'user_4',
      tipeCuti: CutiType.keluargaMeninggal,
      tanggalMulai: DateTime(2025, 9, 10),
      tanggalSelesai: DateTime(2025, 9, 12),
      alasan: 'Keluarga meninggal dunia',
      status: CutiStatus.rejected,
      umpanBalik: 'Dokumen tidak lengkap',
      reviewerId: 'reviewer_2',
      reviewerName: 'Supervisor',
      tanggalPengajuan: DateTime(2025, 9, 8),
      tanggalReview: DateTime(2025, 9, 9),
      jumlahHari: 3,
    ),
  ];

  final List<CutiKuotaModel> _mockKuotaData = [
    CutiKuotaModel(
      userId: 'user_1',
      totalKuotaPerTahun: 12,
      kuotaTerpakai: 3,
      kuotaSisa: 9,
      tahun: 2025,
      lastUpdated: DateTime.now(),
    ),
    CutiKuotaModel(
      userId: 'user_2',
      totalKuotaPerTahun: 12,
      kuotaTerpakai: 5,
      kuotaSisa: 7,
      tahun: 2025,
      lastUpdated: DateTime.now(),
    ),
    CutiKuotaModel(
      userId: 'user_3',
      totalKuotaPerTahun: 12,
      kuotaTerpakai: 2,
      kuotaSisa: 10,
      tahun: 2025,
      lastUpdated: DateTime.now(),
    ),
  ];

  @override
  Future<CutiKuotaModel> getCutiKuota(String userId) async {
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulate network delay

    try {
      return _mockKuotaData.firstWhere(
        (kuota) => kuota.userId == userId,
        orElse: () => CutiKuotaModel(
          userId: userId,
          totalKuotaPerTahun: 12,
          kuotaTerpakai: 0,
          kuotaSisa: 12,
          tahun: DateTime.now().year,
          lastUpdated: DateTime.now(),
        ),
      );
    } catch (e) {
      throw Exception('Failed to get kuota cuti: $e');
    }
  }

  @override
  Future<List<CutiModel>> getDaftarCutiSaya(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      return _mockCutiData.where((cuti) => cuti.userId == userId).toList();
    } catch (e) {
      throw Exception('Failed to get daftar cuti saya: $e');
    }
  }

  @override
  Future<List<CutiModel>> getDaftarCutiAnggota({
    String? status,
    String? tipeCuti,
    DateTime? tanggalMulai,
    DateTime? tanggalSelesai,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      var result = List<CutiModel>.from(_mockCutiData);

      if (status != null) {
        result = result
            .where((cuti) => cuti.status.toString().split('.').last == status)
            .toList();
      }

      if (tipeCuti != null) {
        result = result
            .where(
                (cuti) => cuti.tipeCuti.toString().split('.').last == tipeCuti)
            .toList();
      }

      if (tanggalMulai != null) {
        result = result
            .where((cuti) =>
                cuti.tanggalMulai.isAfter(tanggalMulai) ||
                cuti.tanggalMulai.isAtSameMomentAs(tanggalMulai))
            .toList();
      }

      if (tanggalSelesai != null) {
        result = result
            .where((cuti) =>
                cuti.tanggalSelesai.isBefore(tanggalSelesai) ||
                cuti.tanggalSelesai.isAtSameMomentAs(tanggalSelesai))
            .toList();
      }

      return result;
    } catch (e) {
      throw Exception('Failed to get daftar cuti anggota: $e');
    }
  }

  @override
  Future<CutiModel> buatAjuanCuti({
    required String userId,
    required String nama,
    required CutiType tipeCuti,
    required DateTime tanggalMulai,
    required DateTime tanggalSelesai,
    required String alasan,
    required int jumlahHari,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      final newCuti = CutiModel(
        id: 'cuti_${DateTime.now().millisecondsSinceEpoch}',
        nama: nama,
        userId: userId,
        tipeCuti: tipeCuti,
        tanggalMulai: tanggalMulai,
        tanggalSelesai: tanggalSelesai,
        alasan: alasan,
        status: CutiStatus.pending,
        tanggalPengajuan: DateTime.now(),
        jumlahHari: jumlahHari,
      );

      _mockCutiData.add(newCuti);
      return newCuti;
    } catch (e) {
      throw Exception('Failed to create ajuan cuti: $e');
    }
  }

  @override
  Future<CutiModel> updateStatusCuti({
    required String cutiId,
    required CutiStatus status,
    required String reviewerId,
    required String reviewerName,
    String? umpanBalik,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    try {
      final index = _mockCutiData.indexWhere((cuti) => cuti.id == cutiId);
      if (index == -1) {
        throw Exception('Cuti not found');
      }

      final updatedCuti = CutiModel(
        id: _mockCutiData[index].id,
        nama: _mockCutiData[index].nama,
        userId: _mockCutiData[index].userId,
        tipeCuti: _mockCutiData[index].tipeCuti,
        tanggalMulai: _mockCutiData[index].tanggalMulai,
        tanggalSelesai: _mockCutiData[index].tanggalSelesai,
        alasan: _mockCutiData[index].alasan,
        status: status,
        umpanBalik: umpanBalik,
        reviewerId: reviewerId,
        reviewerName: reviewerName,
        tanggalPengajuan: _mockCutiData[index].tanggalPengajuan,
        tanggalReview: DateTime.now(),
        jumlahHari: _mockCutiData[index].jumlahHari,
      );

      _mockCutiData[index] = updatedCuti;
      return updatedCuti;
    } catch (e) {
      throw Exception('Failed to update status cuti: $e');
    }
  }

  @override
  Future<List<CutiModel>> filterCuti({
    String? status,
    String? tipeCuti,
    DateTime? tanggalMulai,
    DateTime? tanggalSelesai,
    String? userId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      return await getDaftarCutiAnggota(
        status: status,
        tipeCuti: tipeCuti,
        tanggalMulai: tanggalMulai,
        tanggalSelesai: tanggalSelesai,
      );
    } catch (e) {
      throw Exception('Failed to filter cuti: $e');
    }
  }

  @override
  Future<CutiModel> getDetailCuti(String cutiId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      return _mockCutiData.firstWhere(
        (cuti) => cuti.id == cutiId,
        orElse: () => throw Exception('Cuti not found'),
      );
    } catch (e) {
      throw Exception('Failed to get detail cuti: $e');
    }
  }

  @override
  Future<List<CutiModel>> getRekapCuti({
    DateTime? tanggalMulai,
    DateTime? tanggalSelesai,
    String? status,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    try {
      return await getDaftarCutiAnggota(
        status: status,
        tanggalMulai: tanggalMulai,
        tanggalSelesai: tanggalSelesai,
      );
    } catch (e) {
      throw Exception('Failed to get rekap cuti: $e');
    }
  }
}
