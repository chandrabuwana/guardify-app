import 'package:equatable/equatable.dart';

enum CutiStatus {
  pending,
  approved,
  rejected,
  cancelled,
}

enum CutiType {
  tahunan,
  sakit,
  melahirkan,
  menikah,
  keluargaMeninggal,
  lainnya,
}

class CutiEntity extends Equatable {
  final String id;
  final String nama;
  final String userId;
  final CutiType tipeCuti;
  final DateTime tanggalMulai;
  final DateTime tanggalSelesai;
  final String alasan;
  final CutiStatus status;
  final String? umpanBalik;
  final String? reviewerId;
  final String? reviewerName;
  final DateTime tanggalPengajuan;
  final DateTime? tanggalReview;
  final int jumlahHari;

  const CutiEntity({
    required this.id,
    required this.nama,
    required this.userId,
    required this.tipeCuti,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.alasan,
    required this.status,
    this.umpanBalik,
    this.reviewerId,
    this.reviewerName,
    required this.tanggalPengajuan,
    this.tanggalReview,
    required this.jumlahHari,
  });

  String get tipeCutiDisplayName {
    switch (tipeCuti) {
      case CutiType.tahunan:
        return 'Cuti Tahunan';
      case CutiType.sakit:
        return 'Cuti Sakit';
      case CutiType.melahirkan:
        return 'Cuti Melahirkan';
      case CutiType.menikah:
        return 'Cuti Menikah';
      case CutiType.keluargaMeninggal:
        return 'Cuti Keluarga Meninggal';
      case CutiType.lainnya:
        return 'Lainnya';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case CutiStatus.pending:
        return 'Menunggu';
      case CutiStatus.approved:
        return 'Disetujui';
      case CutiStatus.rejected:
        return 'Ditolak';
      case CutiStatus.cancelled:
        return 'Dibatalkan';
    }
  }

  CutiEntity copyWith({
    String? id,
    String? nama,
    String? userId,
    CutiType? tipeCuti,
    DateTime? tanggalMulai,
    DateTime? tanggalSelesai,
    String? alasan,
    CutiStatus? status,
    String? umpanBalik,
    String? reviewerId,
    String? reviewerName,
    DateTime? tanggalPengajuan,
    DateTime? tanggalReview,
    int? jumlahHari,
  }) {
    return CutiEntity(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      userId: userId ?? this.userId,
      tipeCuti: tipeCuti ?? this.tipeCuti,
      tanggalMulai: tanggalMulai ?? this.tanggalMulai,
      tanggalSelesai: tanggalSelesai ?? this.tanggalSelesai,
      alasan: alasan ?? this.alasan,
      status: status ?? this.status,
      umpanBalik: umpanBalik ?? this.umpanBalik,
      reviewerId: reviewerId ?? this.reviewerId,
      reviewerName: reviewerName ?? this.reviewerName,
      tanggalPengajuan: tanggalPengajuan ?? this.tanggalPengajuan,
      tanggalReview: tanggalReview ?? this.tanggalReview,
      jumlahHari: jumlahHari ?? this.jumlahHari,
    );
  }

  @override
  List<Object?> get props => [
        id,
        nama,
        userId,
        tipeCuti,
        tanggalMulai,
        tanggalSelesai,
        alasan,
        status,
        umpanBalik,
        reviewerId,
        reviewerName,
        tanggalPengajuan,
        tanggalReview,
        jumlahHari,
      ];
}
