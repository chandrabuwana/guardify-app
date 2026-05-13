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
    super.remedialGrade,
    required super.status,
    super.tipeTest,
    super.keterangan,
    super.userFullname,
    super.userJabatan,
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
      remedialGrade: json['remedial_grade'] as int?,
      status: TestKelulusanStatus.fromValue(
          json['status'] as String? ?? 'belum_dinilai'),
      tipeTest: json['tipe_Test'] as String?,
      keterangan: json['keterangan'] as String?,
      userFullname: json['UserFullname'] as String?,
      userJabatan: json['UserJabatan'] as String?,
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
      'remedial_grade': remedialGrade,
      'status': status.value,
      'tipe_Test': tipeTest,
      'keterangan': keterangan,
      'UserFullname': userFullname,
      'UserJabatan': userJabatan,
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
      remedialGrade: remedialGrade,
      status: status,
      tipeTest: tipeTest,
      keterangan: keterangan,
      userFullname: userFullname,
      userJabatan: userJabatan,
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
      remedialGrade: entity.remedialGrade,
      status: entity.status,
      tipeTest: entity.tipeTest,
      keterangan: entity.keterangan,
      userFullname: entity.userFullname,
      userJabatan: entity.userJabatan,
    );
  }
}

