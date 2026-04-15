import 'package:equatable/equatable.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/usecases/get_attendance_status_usecase.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {
  const AttendanceInitial();
}

class AttendanceLoading extends AttendanceState {
  const AttendanceLoading();
}

// Status States
class AttendanceStatusLoaded extends AttendanceState {
  final UserAttendanceStatus status;
  final Attendance? currentAttendance;

  const AttendanceStatusLoaded({
    required this.status,
    this.currentAttendance,
  });

  @override
  List<Object?> get props => [status, currentAttendance];
}

// Check In States
class CheckInFormState extends AttendanceState {
  final String lokasiPenugasan;
  final String lokasiTerkini;
  final String ratePatrol;
  final String pakaianPersonil;
  final String laporanPengamanan;
  final List<String> fotoPengamanan;
  final List<String> tugasLanjutan;
  final String? fotoWajah;
  final Map<String, String> errors;
  final bool isValid;

  const CheckInFormState({
    this.lokasiPenugasan = '',
    this.lokasiTerkini = '',
    this.ratePatrol = '',
    this.pakaianPersonil = '',
    this.laporanPengamanan = '',
    this.fotoPengamanan = const [],
    this.tugasLanjutan = const [],
    this.fotoWajah,
    this.errors = const {},
    this.isValid = false,
  });

  CheckInFormState copyWith({
    String? lokasiPenugasan,
    String? lokasiTerkini,
    String? ratePatrol,
    String? pakaianPersonil,
    String? laporanPengamanan,
    List<String>? fotoPengamanan,
    List<String>? tugasLanjutan,
    String? fotoWajah,
    Map<String, String>? errors,
    bool? isValid,
  }) {
    return CheckInFormState(
      lokasiPenugasan: lokasiPenugasan ?? this.lokasiPenugasan,
      lokasiTerkini: lokasiTerkini ?? this.lokasiTerkini,
      ratePatrol: ratePatrol ?? this.ratePatrol,
      pakaianPersonil: pakaianPersonil ?? this.pakaianPersonil,
      laporanPengamanan: laporanPengamanan ?? this.laporanPengamanan,
      fotoPengamanan: fotoPengamanan ?? this.fotoPengamanan,
      tugasLanjutan: tugasLanjutan ?? this.tugasLanjutan,
      fotoWajah: fotoWajah ?? this.fotoWajah,
      errors: errors ?? this.errors,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [
        lokasiPenugasan,
        lokasiTerkini,
        ratePatrol,
        pakaianPersonil,
        laporanPengamanan,
        fotoPengamanan,
        tugasLanjutan,
        fotoWajah,
        errors,
        isValid,
      ];
}

// Check Out States
class CheckOutFormState extends AttendanceState {
  final String lokasiPenugasanAkhir;
  final String statusTugas;
  final String pakaianPersonil;
  final String laporanPengamanan;
  final List<String> fotoPengamanan;
  final List<String> buktiLaporan;
  final Map<String, String> errors;
  final bool isValid;

  const CheckOutFormState({
    this.lokasiPenugasanAkhir = '',
    this.statusTugas = '',
    this.pakaianPersonil = '',
    this.laporanPengamanan = '',
    this.fotoPengamanan = const [],
    this.buktiLaporan = const [],
    this.errors = const {},
    this.isValid = false,
  });

  CheckOutFormState copyWith({
    String? lokasiPenugasanAkhir,
    String? statusTugas,
    String? pakaianPersonil,
    String? laporanPengamanan,
    List<String>? fotoPengamanan,
    List<String>? buktiLaporan,
    Map<String, String>? errors,
    bool? isValid,
  }) {
    return CheckOutFormState(
      lokasiPenugasanAkhir: lokasiPenugasanAkhir ?? this.lokasiPenugasanAkhir,
      statusTugas: statusTugas ?? this.statusTugas,
      pakaianPersonil: pakaianPersonil ?? this.pakaianPersonil,
      laporanPengamanan: laporanPengamanan ?? this.laporanPengamanan,
      fotoPengamanan: fotoPengamanan ?? this.fotoPengamanan,
      buktiLaporan: buktiLaporan ?? this.buktiLaporan,
      errors: errors ?? this.errors,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [
        lokasiPenugasanAkhir,
        statusTugas,
        pakaianPersonil,
        laporanPengamanan,
        fotoPengamanan,
        buktiLaporan,
        errors,
        isValid,
      ];
}

// Success States
class AttendanceCheckedIn extends AttendanceState {
  final Attendance attendance;
  final String message;

  const AttendanceCheckedIn({
    required this.attendance,
    this.message = 'Check In Berhasil, Selamat Bekerja',
  });

  @override
  List<Object> get props => [attendance, message];
}

class AttendanceCheckedOut extends AttendanceState {
  final Attendance attendance;
  final String message;

  const AttendanceCheckedOut({
    required this.attendance,
    this.message = 'Check Out Berhasil, Selamat Beristirahat',
  });

  @override
  List<Object> get props => [attendance, message];
}

// Error States
class AttendanceFailure extends AttendanceState {
  final String message;

  const AttendanceFailure(this.message);

  @override
  List<Object> get props => [message];
}
