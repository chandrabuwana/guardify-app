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
  final String lokasiPenugasanAkhir;
  final String statusTugas; // selesai/tidak selesai
  final String pakaianPersonil;
  final String laporanPengamanan;
  final List<String> fotoPengamanan;
  final List<String> buktiLaporan;

  const CheckOutRequest({
    required this.userId,
    required this.attendanceId,
    required this.lokasiPenugasanAkhir,
    required this.statusTugas,
    required this.pakaianPersonil,
    required this.laporanPengamanan,
    required this.fotoPengamanan,
    required this.buktiLaporan,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'attendanceId': attendanceId,
      'lokasiPenugasanAkhir': lokasiPenugasanAkhir,
      'statusTugas': statusTugas,
      'pakaianPersonil': pakaianPersonil,
      'laporanPengamanan': laporanPengamanan,
      'fotoPengamanan': fotoPengamanan,
      'buktiLaporan': buktiLaporan,
    };
  }

  @override
  List<Object?> get props => [
        userId,
        attendanceId,
        lokasiPenugasanAkhir,
        statusTugas,
        pakaianPersonil,
        laporanPengamanan,
        fotoPengamanan,
        buktiLaporan,
      ];
}
