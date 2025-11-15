import 'package:equatable/equatable.dart';

class CheckInRequest extends Equatable {
  final String userId;
  final String shift;
  final String lokasiPenugasan;
  final String lokasiTerkini;
  final double? latitude;
  final double? longitude;
  final String ratePatrol;
  final String pakaianPersonil;
  final String laporanPengamanan;
  final List<String> fotoPengamanan;
  final List<String> tugasLanjutan;
  final String? fotoWajah; // Base64 encoded image
  final String? shiftDetailId;

  const CheckInRequest({
    required this.userId,
    required this.shift,
    required this.lokasiPenugasan,
    required this.lokasiTerkini,
    this.latitude,
    this.longitude,
    required this.ratePatrol,
    required this.pakaianPersonil,
    required this.laporanPengamanan,
    required this.fotoPengamanan,
    required this.tugasLanjutan,
    this.fotoWajah,
    this.shiftDetailId,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'shift': shift,
      'lokasiPenugasan': lokasiPenugasan,
      'lokasiTerkini': lokasiTerkini,
      'latitude': latitude,
      'longitude': longitude,
      'ratePatrol': ratePatrol,
      'pakaianPersonil': pakaianPersonil,
      'laporanPengamanan': laporanPengamanan,
      'fotoPengamanan': fotoPengamanan,
      'tugasLanjutan': tugasLanjutan,
      'fotoWajah': fotoWajah,
      'shiftDetailId': shiftDetailId,
    };
  }

  @override
  List<Object?> get props => [
        userId,
        shift,
        lokasiPenugasan,
        lokasiTerkini,
        latitude,
        longitude,
        ratePatrol,
        pakaianPersonil,
        laporanPengamanan,
        fotoPengamanan,
        tugasLanjutan,
        fotoWajah,
        shiftDetailId,
      ];
}

class CheckOutRequest extends Equatable {
  final String userId;
  final String attendanceId;
  final String? shiftDetailId; // IdShiftDetail
  final String lokasiPenugasanAkhir; // LocationName
  final String statusTugas; // selesai/tidak selesai
  final String pakaianPersonil;
  final String laporanPengamanan; // Laporan
  final List<String> fotoPengamanan; // PhotoPengamanan
  final List<String> buktiLaporan; // PhotoLembur
  final String? fotoWajah; // PhotoAbsen - Base64 encoded image path
  final String? coTask; // CoTask - tugas tertunda/completion task
  final bool isOvertime; // IsOvertime
  final double? latitude;
  final double? longitude;

  const CheckOutRequest({
    required this.userId,
    required this.attendanceId,
    this.shiftDetailId,
    required this.lokasiPenugasanAkhir,
    required this.statusTugas,
    required this.pakaianPersonil,
    required this.laporanPengamanan,
    required this.fotoPengamanan,
    required this.buktiLaporan,
    this.fotoWajah,
    this.coTask,
    this.isOvertime = false,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'attendanceId': attendanceId,
      'shiftDetailId': shiftDetailId,
      'lokasiPenugasanAkhir': lokasiPenugasanAkhir,
      'statusTugas': statusTugas,
      'pakaianPersonil': pakaianPersonil,
      'laporanPengamanan': laporanPengamanan,
      'fotoPengamanan': fotoPengamanan,
      'buktiLaporan': buktiLaporan,
      'fotoWajah': fotoWajah,
      'coTask': coTask,
      'isOvertime': isOvertime,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  List<Object?> get props => [
        userId,
        attendanceId,
        shiftDetailId,
        lokasiPenugasanAkhir,
        statusTugas,
        pakaianPersonil,
        laporanPengamanan,
        fotoPengamanan,
        buktiLaporan,
        fotoWajah,
        coTask,
        isOvertime,
        latitude,
        longitude,
      ];
}
