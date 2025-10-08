import '../../domain/entities/test_result_entity.dart';

/// Model data untuk hasil Test (DTO)
class TestResultModel extends TestResultEntity {
  const TestResultModel({
    required super.id,
    required super.userId,
    required super.namaTest,
    required super.tanggalTest,
    required super.nilaiTest,
    required super.nilaiKKM,
    required super.status,
    super.tipeTest,
    super.keterangan,
  });

  /// Create model dari JSON
  factory TestResultModel.fromJson(Map<String, dynamic> json) {
    return TestResultModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      namaTest: json['nama_Test'] as String,
      tanggalTest: DateTime.parse(json['tanggal_Test'] as String),
      nilaiTest: json['nilai_Test'] as int,
      nilaiKKM: json['nilai_kkm'] as int,
      status: TestKelulusanStatus.fromValue(
          json['status'] as String? ?? 'belum_dinilai'),
      tipeTest: json['tipe_Test'] as String?,
      keterangan: json['keterangan'] as String?,
    );
  }

  /// Convert model ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'nama_Test': namaTest,
      'tanggal_Test': tanggalTest.toIso8601String(),
      'nilai_Test': nilaiTest,
      'nilai_kkm': nilaiKKM,
      'status': status.value,
      'tipe_Test': tipeTest,
      'keterangan': keterangan,
    };
  }

  /// Mapping ke Entity
  TestResultEntity toEntity() {
    return TestResultEntity(
      id: id,
      userId: userId,
      namaTest: namaTest,
      tanggalTest: tanggalTest,
      nilaiTest: nilaiTest,
      nilaiKKM: nilaiKKM,
      status: status,
      tipeTest: tipeTest,
      keterangan: keterangan,
    );
  }

  /// Create model dari Entity
  factory TestResultModel.fromEntity(TestResultEntity entity) {
    return TestResultModel(
      id: entity.id,
      userId: entity.userId,
      namaTest: entity.namaTest,
      tanggalTest: entity.tanggalTest,
      nilaiTest: entity.nilaiTest,
      nilaiKKM: entity.nilaiKKM,
      status: entity.status,
      tipeTest: entity.tipeTest,
      keterangan: entity.keterangan,
    );
  }
}

