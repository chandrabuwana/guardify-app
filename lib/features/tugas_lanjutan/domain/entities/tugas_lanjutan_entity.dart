import 'package:equatable/equatable.dart';

/// Status tugas lanjutan
enum TugasLanjutanStatus {
  belum('belum', 'Belum'),
  selesai('selesai', 'Selesai'),
  terverifikasi('terverifikasi', 'Terverifikasi');

  const TugasLanjutanStatus(this.value, this.displayName);

  final String value;
  final String displayName;

  static TugasLanjutanStatus fromValue(String value) {
    return TugasLanjutanStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => TugasLanjutanStatus.belum,
    );
  }
}

/// Entity untuk Tugas Lanjutan
class TugasLanjutanEntity extends Equatable {
  final String id;
  final String title;
  final String lokasi;
  final String pelapor;
  final DateTime tanggal;
  final String deskripsi;
  final TugasLanjutanStatus status;
  final String? diselesaikanOleh;
  final String? diselesaikanOlehId;
  final DateTime? tanggalSelesai;
  final String? buktiUrl;
  final String? catatan;

  const TugasLanjutanEntity({
    required this.id,
    required this.title,
    required this.lokasi,
    required this.pelapor,
    required this.tanggal,
    required this.deskripsi,
    required this.status,
    this.diselesaikanOleh,
    this.diselesaikanOlehId,
    this.tanggalSelesai,
    this.buktiUrl,
    this.catatan,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        lokasi,
        pelapor,
        tanggal,
        deskripsi,
        status,
        diselesaikanOleh,
        diselesaikanOlehId,
        tanggalSelesai,
        buktiUrl,
        catatan,
      ];

  TugasLanjutanEntity copyWith({
    String? id,
    String? title,
    String? lokasi,
    String? pelapor,
    DateTime? tanggal,
    String? deskripsi,
    TugasLanjutanStatus? status,
    String? diselesaikanOleh,
    String? diselesaikanOlehId,
    DateTime? tanggalSelesai,
    String? buktiUrl,
    String? catatan,
  }) {
    return TugasLanjutanEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      lokasi: lokasi ?? this.lokasi,
      pelapor: pelapor ?? this.pelapor,
      tanggal: tanggal ?? this.tanggal,
      deskripsi: deskripsi ?? this.deskripsi,
      status: status ?? this.status,
      diselesaikanOleh: diselesaikanOleh ?? this.diselesaikanOleh,
      diselesaikanOlehId: diselesaikanOlehId ?? this.diselesaikanOlehId,
      tanggalSelesai: tanggalSelesai ?? this.tanggalSelesai,
      buktiUrl: buktiUrl ?? this.buktiUrl,
      catatan: catatan ?? this.catatan,
    );
  }
}

