import 'package:injectable/injectable.dart';
import '../../../../core/constants/enums.dart';
import '../models/laporan_kegiatan_model.dart';
import '../../domain/entities/laporan_kegiatan_entity.dart';

/// Remote data source untuk Laporan Kegiatan
abstract class LaporanKegiatanRemoteDataSource {
  Future<List<LaporanKegiatanModel>> getLaporanList({
    LaporanStatus? status,
    UserRole? role,
    String? userId,
  });

  Future<LaporanKegiatanModel> getLaporanDetail(String id);

  Future<LaporanKegiatanModel> updateStatusLaporan({
    required String id,
    required LaporanStatus status,
    required String reviewerId,
    required String reviewerName,
    String? umpanBalik,
  });
}

@LazySingleton(as: LaporanKegiatanRemoteDataSource)
class LaporanKegiatanRemoteDataSourceImpl
    implements LaporanKegiatanRemoteDataSource {
  // Mock data sesuai dengan UI design
  final List<LaporanKegiatanModel> _mockData = [
    LaporanKegiatanModel(
      id: '1',
      namaPersonil: 'Aiman Hafiz',
      userId: 'user_1',
      role: UserRole.anggota,
      nrp: 'NRP02982',
      tanggal: DateTime(2025, 9, 11),
      shift: 'Shift Pagi',
      jamKerja: '06.40 - 19.10',
      lokasiJaga: 'Pos Satpam Gedung A',
      tugasTertunda: true,
      status: LaporanStatus.menungguVerifikasi,
      kehadiran: 'Masuk',
      lembur: false,
      laporanPengamanan: 'Situasi aman terkendali',
      routeName: 'Rute A (Belum Selesai Diperiksa)',
      checkpoints: const [
        PatrolCheckpointModel(
          id: 'cp1',
          name: 'Pos Gajah A',
          status: 'Selesai',
          buktiUrl: 'bukti.jpg',
          isDiperiksa: true,
        ),
        PatrolCheckpointModel(
          id: 'cp2',
          name: 'Pos Singa B',
          status: 'Selesai',
          buktiUrl: 'bukti.jpg',
          isDiperiksa: true,
        ),
        PatrolCheckpointModel(
          id: 'cp3',
          name: 'Pos Merpati',
          status: 'Belum Diperiksa',
          isDiperiksa: false,
        ),
        PatrolCheckpointModel(
          id: 'cp4',
          name: 'Pos Merak A',
          status: 'Selesai',
          buktiUrl: 'bukti.jpg',
          isDiperiksa: true,
        ),
        PatrolCheckpointModel(
          id: 'cp5',
          name: 'Pos Ayam C',
          status: 'Selesai',
          buktiUrl: 'bukti.jpg',
          isDiperiksa: true,
        ),
      ],
    ),
    LaporanKegiatanModel(
      id: '2',
      namaPersonil: 'Robis Hafiz',
      userId: 'user_2',
      role: UserRole.anggota,
      nrp: 'NRP02983',
      tanggal: DateTime(2025, 9, 11),
      shift: 'Shift Pagi',
      jamKerja: '06.40 - 19.10',
      lokasiJaga: 'Pos Satpam Gedung A',
      tugasTertunda: true,
      status: LaporanStatus.revisi,
      kehadiran: 'Masuk',
      lembur: false,
      laporanPengamanan: 'Perlu perbaikan laporan',
      umpanBalik: 'Mohon lengkapi foto pengamanan',
    ),
    LaporanKegiatanModel(
      id: '3',
      namaPersonil: 'Roger Hafiz',
      userId: 'user_3',
      role: UserRole.anggota,
      nrp: 'NRP02984',
      tanggal: DateTime(2025, 9, 10),
      shift: 'Shift Pagi',
      jamKerja: '06.40 - 19.10',
      lokasiJaga: 'Pos Satpam Gedung B',
      tugasTertunda: true,
      status: LaporanStatus.terverifikasi,
      kehadiran: 'Masuk',
      lembur: false,
      laporanPengamanan: 'Semua berjalan lancar',
      reviewerId: 'reviewer_1',
      reviewerName: 'Supervisor A',
      tanggalReview: DateTime(2025, 9, 11),
    ),
    LaporanKegiatanModel(
      id: '4',
      namaPersonil: 'Aiman Simala',
      userId: 'user_4',
      role: UserRole.anggota,
      nrp: 'NRP02985',
      tanggal: DateTime(2025, 9, 10),
      shift: 'Shift Pagi',
      jamKerja: '06.40 - 19.10',
      lokasiJaga: 'Pos Satpam Gedung C',
      tugasTertunda: true,
      status: LaporanStatus.terverifikasi,
      kehadiran: 'Masuk',
      lembur: false,
      laporanPengamanan: 'Tidak ada insiden',
      reviewerId: 'reviewer_1',
      reviewerName: 'Supervisor A',
      tanggalReview: DateTime(2025, 9, 11),
    ),
    LaporanKegiatanModel(
      id: '5',
      namaPersonil: 'Sabana Pier',
      userId: 'user_5',
      role: UserRole.anggota,
      nrp: 'NRP02986',
      tanggal: DateTime(2025, 9, 9),
      shift: 'Shift Pagi',
      jamKerja: '-',
      lokasiJaga: '-',
      tugasTertunda: true,
      status: LaporanStatus.terverifikasi,
      kehadiran: 'Tidak Masuk',
      lembur: false,
      laporanPengamanan: '-',
    ),
    LaporanKegiatanModel(
      id: '6',
      namaPersonil: 'Dandelion Musk',
      userId: 'user_6',
      role: UserRole.anggota,
      nrp: 'NRP02987',
      tanggal: DateTime(2025, 9, 8),
      shift: 'Shift Pagi',
      jamKerja: '-',
      lokasiJaga: '-',
      tugasTertunda: false,
      status: LaporanStatus.terverifikasi,
      kehadiran: 'Cuti',
      lembur: false,
      laporanPengamanan: '-',
    ),
  ];

  @override
  Future<List<LaporanKegiatanModel>> getLaporanList({
    LaporanStatus? status,
    UserRole? role,
    String? userId,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    var result = _mockData;

    // Filter by status
    if (status != null) {
      result = result.where((laporan) => laporan.status == status).toList();
    }

    // Filter by role
    if (role != null) {
      result = result.where((laporan) => laporan.role == role).toList();
    }

    // Filter by userId
    if (userId != null) {
      result = result.where((laporan) => laporan.userId == userId).toList();
    }

    return result;
  }

  @override
  Future<LaporanKegiatanModel> getLaporanDetail(String id) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    final laporan = _mockData.firstWhere(
      (laporan) => laporan.id == id,
      orElse: () => throw Exception('Laporan not found'),
    );

    return laporan;
  }

  @override
  Future<LaporanKegiatanModel> updateStatusLaporan({
    required String id,
    required LaporanStatus status,
    required String reviewerId,
    required String reviewerName,
    String? umpanBalik,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _mockData.indexWhere((laporan) => laporan.id == id);

    if (index == -1) {
      throw Exception('Laporan not found');
    }

    // Update the status
    final updatedLaporan = LaporanKegiatanModel.fromEntity(
      _mockData[index].copyWith(
        status: status,
        reviewerId: reviewerId,
        reviewerName: reviewerName,
        umpanBalik: umpanBalik,
        tanggalReview: DateTime.now(),
      ),
    );

    _mockData[index] = updatedLaporan;

    return updatedLaporan;
  }
}
