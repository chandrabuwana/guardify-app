import '../../domain/entities/test_summary_entity.dart';

/// Model data untuk ringkasan hasil Test (DTO)
class TestSummaryModel extends TestSummaryEntity {
  const TestSummaryModel({
    required super.jumlahPesertaLulus,
    required super.jumlahPesertaTidakLulus,
    required super.nilaiRataRata,
    required super.nilaiMinimal,
    super.picPeserta,
    super.tipeTest,
    super.tanggalPelaksanaan,
    super.namaPenguji,
    super.anggotaList,
  });

  /// Create model dari JSON
  factory TestSummaryModel.fromJson(Map<String, dynamic> json) {
    return TestSummaryModel(
      jumlahPesertaLulus: json['jumlah_peserta_lulus'] as int? ?? 0,
      jumlahPesertaTidakLulus: json['jumlah_peserta_tidak_lulus'] as int? ?? 0,
      nilaiRataRata: (json['nilai_rata_rata'] as num?)?.toDouble() ?? 0.0,
      nilaiMinimal: (json['nilai_minimal'] as num?)?.toDouble() ?? 0.0,
      picPeserta: json['pic_peserta'] as String?,
      tipeTest: json['tipe_Test'] as String?,
      tanggalPelaksanaan: json['tanggal_pelaksanaan'] != null
          ? DateTime.parse(json['tanggal_pelaksanaan'] as String)
          : null,
      namaPenguji: json['nama_penguji'] as String?,
      anggotaList: (json['anggota_list'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  /// Convert model ke JSON
  Map<String, dynamic> toJson() {
    return {
      'jumlah_peserta_lulus': jumlahPesertaLulus,
      'jumlah_peserta_tidak_lulus': jumlahPesertaTidakLulus,
      'nilai_rata_rata': nilaiRataRata,
      'nilai_minimal': nilaiMinimal,
      'pic_peserta': picPeserta,
      'tipe_Test': tipeTest,
      'tanggal_pelaksanaan': tanggalPelaksanaan?.toIso8601String(),
      'nama_penguji': namaPenguji,
      'anggota_list': anggotaList,
    };
  }

  /// Mapping ke Entity
  TestSummaryEntity toEntity() {
    return TestSummaryEntity(
      jumlahPesertaLulus: jumlahPesertaLulus,
      jumlahPesertaTidakLulus: jumlahPesertaTidakLulus,
      nilaiRataRata: nilaiRataRata,
      nilaiMinimal: nilaiMinimal,
      picPeserta: picPeserta,
      tipeTest: tipeTest,
      tanggalPelaksanaan: tanggalPelaksanaan,
      namaPenguji: namaPenguji,
      anggotaList: anggotaList,
    );
  }

  /// Create model dari Entity
  factory TestSummaryModel.fromEntity(TestSummaryEntity entity) {
    return TestSummaryModel(
      jumlahPesertaLulus: entity.jumlahPesertaLulus,
      jumlahPesertaTidakLulus: entity.jumlahPesertaTidakLulus,
      nilaiRataRata: entity.nilaiRataRata,
      nilaiMinimal: entity.nilaiMinimal,
      picPeserta: entity.picPeserta,
      tipeTest: entity.tipeTest,
      tanggalPelaksanaan: entity.tanggalPelaksanaan,
      namaPenguji: entity.namaPenguji,
      anggotaList: entity.anggotaList,
    );
  }
}

