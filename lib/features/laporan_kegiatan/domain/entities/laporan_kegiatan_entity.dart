import 'package:equatable/equatable.dart';
import '../../../../core/constants/enums.dart';

/// Status laporan kegiatan - sesuai dengan web: checkIn, waiting, verified, revision
enum LaporanStatus {
  checkIn('check_in', 'Check In'),
  waiting('waiting', 'Waiting'),
  verified('verified', 'Verified'),
  revision('revision', 'Revision');

  const LaporanStatus(this.value, this.displayName);

  final String value;
  final String displayName;

  static LaporanStatus fromValue(String? value) {
    if (value == null || value.isEmpty) {
      return LaporanStatus.waiting;
    }
    
    final valueLower = value.toLowerCase().trim();
    
    // Map new status format
    switch (valueLower) {
      case 'checkin':
      case 'check_in':
        return LaporanStatus.checkIn;
      case 'waiting':
      case 'menunggu':
      case 'menunggu_verifikasi':
        return LaporanStatus.waiting;
      case 'verified':
      case 'verifikasi':
      case 'terverifikasi':
        return LaporanStatus.verified;
      case 'revision':
      case 'revisi':
        return LaporanStatus.revision;
      default:
        return LaporanStatus.waiting;
    }
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
  final String? laporanPengamananCheckout;
  final List<String>? fotoPengamanan;
  final List<String>? fotoPengamananCheckout;
  final String? tugasLanjutan;
  final bool tugasTertunda;
  final String? carryOver;
  final LaporanStatus status;
  final String kehadiran; // "Masuk", "Tidak Masuk", "Cuti"
  final bool lembur;
  final String? fotoLembur;
  final String? jamSelesaiBekerja;
  final String? umpanBalik;
  final String? statusKerja; // "Early", "OnTime", "Late", "Checkout By Admin", etc.

  // Untuk Patrol Route/Timeline
  final String? routeName;
  final List<PatrolCheckpoint>? checkpoints;

  // Review info
  final String? reviewerId;
  final String? reviewerName;
  final DateTime? tanggalReview;

  // Update info
  final String? updateBy;
  final DateTime? updateDate;

  // Attendance info
  final String? idAttendance;
  final DateTime? checkIn;
  final DateTime? checkOut;

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
    this.laporanPengamananCheckout,
    this.fotoPengamanan,
    this.fotoPengamananCheckout,
    this.tugasLanjutan,
    required this.tugasTertunda,
    this.carryOver,
    required this.status,
    required this.kehadiran,
    required this.lembur,
    this.fotoLembur,
    this.jamSelesaiBekerja,
    this.umpanBalik,
    this.statusKerja,
    this.routeName,
    this.checkpoints,
    this.reviewerId,
    this.reviewerName,
    this.tanggalReview,
    this.updateBy,
    this.updateDate,
    this.idAttendance,
    this.checkIn,
    this.checkOut,
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
        laporanPengamananCheckout,
        fotoPengamanan,
        fotoPengamananCheckout,
        tugasLanjutan,
        tugasTertunda,
        carryOver,
        status,
        kehadiran,
        lembur,
        fotoLembur,
        jamSelesaiBekerja,
        umpanBalik,
        statusKerja,
        routeName,
        checkpoints,
        reviewerId,
        reviewerName,
        tanggalReview,
        updateBy,
        updateDate,
        idAttendance,
        checkIn,
        checkOut,
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
    String? laporanPengamananCheckout,
    List<String>? fotoPengamanan,
    List<String>? fotoPengamananCheckout,
    String? tugasLanjutan,
    bool? tugasTertunda,
    String? carryOver,
    LaporanStatus? status,
    String? kehadiran,
    bool? lembur,
    String? fotoLembur,
    String? jamSelesaiBekerja,
    String? umpanBalik,
    String? statusKerja,
    String? routeName,
    List<PatrolCheckpoint>? checkpoints,
    String? reviewerId,
    String? reviewerName,
    DateTime? tanggalReview,
    String? updateBy,
    DateTime? updateDate,
    String? idAttendance,
    DateTime? checkIn,
    DateTime? checkOut,
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
      laporanPengamananCheckout:
          laporanPengamananCheckout ?? this.laporanPengamananCheckout,
      fotoPengamanan: fotoPengamanan ?? this.fotoPengamanan,
      fotoPengamananCheckout:
          fotoPengamananCheckout ?? this.fotoPengamananCheckout,
      tugasLanjutan: tugasLanjutan ?? this.tugasLanjutan,
      tugasTertunda: tugasTertunda ?? this.tugasTertunda,
      carryOver: carryOver ?? this.carryOver,
      status: status ?? this.status,
      kehadiran: kehadiran ?? this.kehadiran,
      lembur: lembur ?? this.lembur,
      fotoLembur: fotoLembur ?? this.fotoLembur,
      jamSelesaiBekerja: jamSelesaiBekerja ?? this.jamSelesaiBekerja,
      umpanBalik: umpanBalik ?? this.umpanBalik,
      statusKerja: statusKerja ?? this.statusKerja,
      routeName: routeName ?? this.routeName,
      checkpoints: checkpoints ?? this.checkpoints,
      reviewerId: reviewerId ?? this.reviewerId,
      reviewerName: reviewerName ?? this.reviewerName,
      tanggalReview: tanggalReview ?? this.tanggalReview,
      updateBy: updateBy ?? this.updateBy,
      updateDate: updateDate ?? this.updateDate,
      idAttendance: idAttendance ?? this.idAttendance,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
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
