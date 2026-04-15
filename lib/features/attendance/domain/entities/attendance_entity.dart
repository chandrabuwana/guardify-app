import 'package:equatable/equatable.dart';

enum AttendanceStatus {
  notCheckedIn,
  checkedIn,
  checkedOut,
}

enum TaskStatus {
  notStarted,
  inProgress,
  completed,
  cancelled,
}

class AttendanceEntity extends Equatable {
  final String? id;
  final String userId;
  final String shift;
  final AttendanceStatus status;
  final String? lokasi;
  final String? lokasiPenugasan;
  final String? lokasiTerkini;
  final String? ratePatrol;
  final String? pakaianPersonil;
  final String? laporanPengamanan;
  final List<String>? fotoPengamanan;
  final List<String>? tugasLanjutan;
  final DateTime? waktuMulai;
  final DateTime? waktuSelesai;
  final String? statusTugas; // selesai/tidak selesai
  final List<String>? buktiLaporan;
  final String? namaPersonil;

  const AttendanceEntity({
    this.id,
    required this.userId,
    required this.shift,
    required this.status,
    this.lokasi,
    this.lokasiPenugasan,
    this.lokasiTerkini,
    this.ratePatrol,
    this.pakaianPersonil,
    this.laporanPengamanan,
    this.fotoPengamanan,
    this.tugasLanjutan,
    this.waktuMulai,
    this.waktuSelesai,
    this.statusTugas,
    this.buktiLaporan,
    this.namaPersonil,
  });

  AttendanceEntity copyWith({
    String? id,
    String? userId,
    String? shift,
    AttendanceStatus? status,
    String? lokasi,
    String? lokasiPenugasan,
    String? lokasiTerkini,
    String? ratePatrol,
    String? pakaianPersonil,
    String? laporanPengamanan,
    List<String>? fotoPengamanan,
    List<String>? tugasLanjutan,
    DateTime? waktuMulai,
    DateTime? waktuSelesai,
    String? statusTugas,
    List<String>? buktiLaporan,
    String? namaPersonil,
  }) {
    return AttendanceEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      shift: shift ?? this.shift,
      status: status ?? this.status,
      lokasi: lokasi ?? this.lokasi,
      lokasiPenugasan: lokasiPenugasan ?? this.lokasiPenugasan,
      lokasiTerkini: lokasiTerkini ?? this.lokasiTerkini,
      ratePatrol: ratePatrol ?? this.ratePatrol,
      pakaianPersonil: pakaianPersonil ?? this.pakaianPersonil,
      laporanPengamanan: laporanPengamanan ?? this.laporanPengamanan,
      fotoPengamanan: fotoPengamanan ?? this.fotoPengamanan,
      tugasLanjutan: tugasLanjutan ?? this.tugasLanjutan,
      waktuMulai: waktuMulai ?? this.waktuMulai,
      waktuSelesai: waktuSelesai ?? this.waktuSelesai,
      statusTugas: statusTugas ?? this.statusTugas,
      buktiLaporan: buktiLaporan ?? this.buktiLaporan,
      namaPersonil: namaPersonil ?? this.namaPersonil,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        shift,
        status,
        lokasi,
        lokasiPenugasan,
        lokasiTerkini,
        ratePatrol,
        pakaianPersonil,
        laporanPengamanan,
        fotoPengamanan,
        tugasLanjutan,
        waktuMulai,
        waktuSelesai,
        statusTugas,
        buktiLaporan,
        namaPersonil,
      ];

  @override
  String toString() {
    return 'AttendanceEntity(id: $id, userId: $userId, shift: $shift, status: $status, lokasi: $lokasi, lokasiPenugasan: $lokasiPenugasan, lokasiTerkini: $lokasiTerkini, ratePatrol: $ratePatrol, pakaianPersonil: $pakaianPersonil, laporanPengamanan: $laporanPengamanan, fotoPengamanan: $fotoPengamanan, tugasLanjutan: $tugasLanjutan, waktuMulai: $waktuMulai, waktuSelesai: $waktuSelesai, statusTugas: $statusTugas, buktiLaporan: $buktiLaporan, namaPersonil: $namaPersonil)';
  }
}
