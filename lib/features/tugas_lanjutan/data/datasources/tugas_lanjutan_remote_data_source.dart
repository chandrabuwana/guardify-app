import 'package:injectable/injectable.dart';
import '../models/tugas_lanjutan_model.dart';
import '../../domain/entities/tugas_lanjutan_entity.dart';

/// Remote data source untuk Tugas Lanjutan
abstract class TugasLanjutanRemoteDataSource {
  Future<List<TugasLanjutanModel>> getTugasLanjutanList({
    bool filterByToday = false,
    String? userId,
  });

  Future<TugasLanjutanModel> getTugasLanjutanDetail(String id);

  Future<TugasLanjutanModel> selesaikanTugas({
    required String id,
    required String lokasi,
    required String buktiUrl,
    String? catatan,
    required String userId,
    required String userName,
  });

  Future<Map<String, dynamic>> getProgressSummary({
    String? userId,
  });
}

@LazySingleton(as: TugasLanjutanRemoteDataSource)
class TugasLanjutanRemoteDataSourceImpl
    implements TugasLanjutanRemoteDataSource {
  // Mock data sesuai dengan UI design
  final List<TugasLanjutanModel> _mockData = [
    TugasLanjutanModel(
      id: '1',
      title: 'Tugas Lanjutan 1',
      lokasi: 'Pos Gajah',
      pelapor: 'Supriadi Aham',
      tanggal: DateTime(2025, 9, 29, 7, 10),
      deskripsi:
          'Pemeriksaan area gudang belum sepenuhnya selesai karena keterbatasan waktu. Beberapa titik masih belum dicek, terutama bagian pintu belakang dan rak penyimpanan barang berharga. Lanjutkan pemeriksaan menyeluruh, memastikan semua akses dalam kondisi aman, serta melaporkan hasil ke pengawas.',
      status: TugasLanjutanStatus.selesai,
      diselesaikanOleh: 'Afif Azami - 9218211',
      diselesaikanOlehId: '9218211',
      tanggalSelesai: DateTime(2025, 9, 29, 11, 23),
      buktiUrl: 'bukti.jpg',
    ),
    TugasLanjutanModel(
      id: '2',
      title: 'Tugas Lanjutan 1',
      lokasi: 'Pos Gajah',
      pelapor: 'Supriadi Aham',
      tanggal: DateTime(2025, 9, 29, 7, 10),
      deskripsi:
          'Pemeriksaan area gudang belum sepenuhnya selesai karena keterbatasan waktu. Beberapa titik masih belum dicek, terutama bagian pintu belakang dan rak penyimpanan barang berharga. Lanjutkan pemeriksaan menyeluruh, memastikan semua akses dalam kondisi aman, serta melaporkan hasil ke pengawas.',
      status: TugasLanjutanStatus.selesai,
      diselesaikanOleh: 'Afif Azami - 9218211',
      diselesaikanOlehId: '9218211',
      tanggalSelesai: DateTime(2025, 9, 29, 11, 23),
      buktiUrl: 'bukti.jpg',
    ),
    TugasLanjutanModel(
      id: '3',
      title: 'Tugas Lanjutan 2',
      lokasi: 'Pos Gajah',
      pelapor: 'Supriadi Aham',
      tanggal: DateTime(2025, 9, 29, 7, 10),
      deskripsi:
          'Pemeriksaan area gudang belum sepenuhnya selesai karena keterbatasan waktu. Beberapa titik masih belum dicek, terutama bagian pintu belakang dan rak penyimpanan barang berharga. Lanjutkan pemeriksaan menyeluruh, memastikan semua akses dalam kondisi aman, serta melaporkan hasil ke pengawas.',
      status: TugasLanjutanStatus.belum,
    ),
    TugasLanjutanModel(
      id: '4',
      title: 'Tugas Lanjutan 3',
      lokasi: 'Pos Singa',
      pelapor: 'Budi Santoso',
      tanggal: DateTime(2025, 9, 28, 8, 0),
      deskripsi:
          'Perbaikan sistem keamanan di area parkir belum selesai. Perlu pengecekan ulang dan dokumentasi.',
      status: TugasLanjutanStatus.selesai,
      diselesaikanOleh: 'John Doe - 9218212',
      diselesaikanOlehId: '9218212',
      tanggalSelesai: DateTime(2025, 9, 28, 14, 30),
      buktiUrl: 'bukti2.jpg',
    ),
  ];

  @override
  Future<List<TugasLanjutanModel>> getTugasLanjutanList({
    bool filterByToday = false,
    String? userId,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    var result = List<TugasLanjutanModel>.from(_mockData);

    // Filter by today
    if (filterByToday) {
      final today = DateTime.now();
      result = result
          .where((tugas) =>
              tugas.tanggal.year == today.year &&
              tugas.tanggal.month == today.month &&
              tugas.tanggal.day == today.day)
          .toList();
    }

    // Filter by userId if provided
    if (userId != null) {
      // In real implementation, filter by assigned user
      // For now, return all tasks
    }

    return result;
  }

  @override
  Future<TugasLanjutanModel> getTugasLanjutanDetail(String id) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    final tugas = _mockData.firstWhere(
      (tugas) => tugas.id == id,
      orElse: () => throw Exception('Tugas lanjutan not found'),
    );

    return tugas;
  }

  @override
  Future<TugasLanjutanModel> selesaikanTugas({
    required String id,
    required String lokasi,
    required String buktiUrl,
    String? catatan,
    required String userId,
    required String userName,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _mockData.indexWhere((tugas) => tugas.id == id);

    if (index == -1) {
      throw Exception('Tugas lanjutan not found');
    }

    // Update the task
    final updatedTugas = TugasLanjutanModel.fromEntity(
      _mockData[index].copyWith(
        status: TugasLanjutanStatus.selesai,
        diselesaikanOleh: '$userName - $userId',
        diselesaikanOlehId: userId,
        tanggalSelesai: DateTime.now(),
        buktiUrl: buktiUrl,
        catatan: catatan,
        lokasi: lokasi,
      ),
    );

    _mockData[index] = updatedTugas;

    return updatedTugas;
  }

  @override
  Future<Map<String, dynamic>> getProgressSummary({
    String? userId,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));

    final today = DateTime.now();
    final todayTasks = _mockData
        .where((tugas) =>
            tugas.tanggal.year == today.year &&
            tugas.tanggal.month == today.month &&
            tugas.tanggal.day == today.day)
        .toList();

    final total = todayTasks.length;
    final selesai = todayTasks
        .where((tugas) => tugas.status == TugasLanjutanStatus.selesai)
        .length;
    final belum = todayTasks
        .where((tugas) => tugas.status == TugasLanjutanStatus.belum)
        .length;
    final terverifikasi = todayTasks
        .where((tugas) => tugas.status == TugasLanjutanStatus.terverifikasi)
        .length;

    return {
      'total': total,
      'selesai': selesai,
      'belum': belum,
      'terverifikasi': terverifikasi,
      'progress': total > 0 ? selesai / total : 0.0,
    };
  }
}

