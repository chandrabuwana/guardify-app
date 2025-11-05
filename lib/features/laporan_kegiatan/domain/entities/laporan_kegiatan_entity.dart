import 'package:equatable/equatable.dart';
import '../../../../core/constants/enums.dart';

/// Status laporan kegiatan
enum LaporanStatus {
  menungguVerifikasi('menunggu_verifikasi', 'Menunggu Verifikasi'),
  revisi('revisi', 'Revisi'),
  terverifikasi('terverifikasi', 'Terverifikasi');

  const LaporanStatus(this.value, this.displayName);

  final String value;
  final String displayName;

  static LaporanStatus fromValue(String value) {
    return LaporanStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => LaporanStatus.menungguVerifikasi,
    );
  }
}

/// Entity untuk Laporan Kegiatan
class LaporanKegiatanEntity extends Equatable {
  final String id;
  final String namaPersonil;
  final String userId;
  final UserRole role;
  final String? profileImageUrl;
  final String nrp;
  final DateTime tanggal;
  final String shift;
  final String jamKerja;
  final String lokasiJaga;
  final String? jamAbsensi;
  final String? pakaianPersonil;
  final String? fotoPakaianPersonil;
  final String laporanPengamanan;
  final List<String>? fotoPengamanan;
  final String? tugasLanjutan;
  final bool tugasTertunda;
  final LaporanStatus status;
  final String kehadiran; // "Masuk", "Tidak Masuk", "Cuti"
  final bool lembur;
  final String? fotoLembur;
  final String? jamSelesaiBekerja;
  final String? umpanBalik;

  // Untuk Patrol Route/Timeline
  final String? routeName;
  final List<PatrolCheckpoint>? checkpoints;

  // Review info
  final String? reviewerId;
  final String? reviewerName;
  final DateTime? tanggalReview;

  const LaporanKegiatanEntity({
    required this.id,
    required this.namaPersonil,
    required this.userId,
    required this.role,
    this.profileImageUrl,
    required this.nrp,
    required this.tanggal,
    required this.shift,
    required this.jamKerja,
    required this.lokasiJaga,
    this.jamAbsensi,
    this.pakaianPersonil,
    this.fotoPakaianPersonil,
    required this.laporanPengamanan,
    this.fotoPengamanan,
    this.tugasLanjutan,
    required this.tugasTertunda,
    required this.status,
    required this.kehadiran,
    required this.lembur,
    this.fotoLembur,
    this.jamSelesaiBekerja,
    this.umpanBalik,
    this.routeName,
    this.checkpoints,
    this.reviewerId,
    this.reviewerName,
    this.tanggalReview,
  });

  @override
  List<Object?> get props => [
        id,
        namaPersonil,
        userId,
        role,
        profileImageUrl,
        nrp,
        tanggal,
        shift,
        jamKerja,
        lokasiJaga,
        jamAbsensi,
        pakaianPersonil,
        fotoPakaianPersonil,
        laporanPengamanan,
        fotoPengamanan,
        tugasLanjutan,
        tugasTertunda,
        status,
        kehadiran,
        lembur,
        fotoLembur,
        jamSelesaiBekerja,
        umpanBalik,
        routeName,
        checkpoints,
        reviewerId,
        reviewerName,
        tanggalReview,
      ];

  LaporanKegiatanEntity copyWith({
    String? id,
    String? namaPersonil,
    String? userId,
    UserRole? role,
    String? profileImageUrl,
    String? nrp,
    DateTime? tanggal,
    String? shift,
    String? jamKerja,
    String? lokasiJaga,
    String? jamAbsensi,
    String? pakaianPersonil,
    String? fotoPakaianPersonil,
    String? laporanPengamanan,
    List<String>? fotoPengamanan,
    String? tugasLanjutan,
    bool? tugasTertunda,
    LaporanStatus? status,
    String? kehadiran,
    bool? lembur,
    String? fotoLembur,
    String? jamSelesaiBekerja,
    String? umpanBalik,
    String? routeName,
    List<PatrolCheckpoint>? checkpoints,
    String? reviewerId,
    String? reviewerName,
    DateTime? tanggalReview,
  }) {
    return LaporanKegiatanEntity(
      id: id ?? this.id,
      namaPersonil: namaPersonil ?? this.namaPersonil,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      nrp: nrp ?? this.nrp,
      tanggal: tanggal ?? this.tanggal,
      shift: shift ?? this.shift,
      jamKerja: jamKerja ?? this.jamKerja,
      lokasiJaga: lokasiJaga ?? this.lokasiJaga,
      jamAbsensi: jamAbsensi ?? this.jamAbsensi,
      pakaianPersonil: pakaianPersonil ?? this.pakaianPersonil,
      fotoPakaianPersonil: fotoPakaianPersonil ?? this.fotoPakaianPersonil,
      laporanPengamanan: laporanPengamanan ?? this.laporanPengamanan,
      fotoPengamanan: fotoPengamanan ?? this.fotoPengamanan,
      tugasLanjutan: tugasLanjutan ?? this.tugasLanjutan,
      tugasTertunda: tugasTertunda ?? this.tugasTertunda,
      status: status ?? this.status,
      kehadiran: kehadiran ?? this.kehadiran,
      lembur: lembur ?? this.lembur,
      fotoLembur: fotoLembur ?? this.fotoLembur,
      jamSelesaiBekerja: jamSelesaiBekerja ?? this.jamSelesaiBekerja,
      umpanBalik: umpanBalik ?? this.umpanBalik,
      routeName: routeName ?? this.routeName,
      checkpoints: checkpoints ?? this.checkpoints,
      reviewerId: reviewerId ?? this.reviewerId,
      reviewerName: reviewerName ?? this.reviewerName,
      tanggalReview: tanggalReview ?? this.tanggalReview,
    );
  }
}

/// Entity untuk checkpoint patrol dalam laporan
class PatrolCheckpoint extends Equatable {
  final String id;
  final String name;
  final String status; // "Selesai", "Belum Selesai", "Tambahan"
  final DateTime? timestamp;
  final String? buktiUrl;
  final bool isDiperiksa; // Sudah diperiksa atau belum

  const PatrolCheckpoint({
    required this.id,
    required this.name,
    required this.status,
    this.timestamp,
    this.buktiUrl,
    this.isDiperiksa = false,
  });

  @override
  List<Object?> get props =>
      [id, name, status, timestamp, buktiUrl, isDiperiksa];
}
