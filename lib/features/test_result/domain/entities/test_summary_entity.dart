import 'package:equatable/equatable.dart';

/// Entity untuk ringkasan hasil Test
class TestSummaryEntity extends Equatable {
  final int jumlahPesertaLulus;
  final int jumlahPesertaTidakLulus;
  final double nilaiRataRata;
  final double nilaiMinimal;
  final String? picPeserta;
  final String? tipeTest;
  final DateTime? tanggalPelaksanaan;
  final String? namaPenguji;
  final List<String>? anggotaList; // List nama anggota untuk PJO/Deputy
  
  const TestSummaryEntity({
    required this.jumlahPesertaLulus,
    required this.jumlahPesertaTidakLulus,
    required this.nilaiRataRata,
    required this.nilaiMinimal,
    this.picPeserta,
    this.tipeTest,
    this.tanggalPelaksanaan,
    this.namaPenguji,
    this.anggotaList,
  });

  /// Total peserta Test
  int get totalPeserta => jumlahPesertaLulus + jumlahPesertaTidakLulus;

  @override
  List<Object?> get props => [
        jumlahPesertaLulus,
        jumlahPesertaTidakLulus,
        nilaiRataRata,
        nilaiMinimal,
        picPeserta,
        tipeTest,
        tanggalPelaksanaan,
        namaPenguji,
        anggotaList,
      ];
}

