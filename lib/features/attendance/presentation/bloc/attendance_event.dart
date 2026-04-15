import 'package:equatable/equatable.dart';
import '../../domain/entities/attendance_request.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object?> get props => [];
}

// Status Events
class GetAttendanceStatusEvent extends AttendanceEvent {
  final String userId;

  const GetAttendanceStatusEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

// Check In Events
class CheckInStartedEvent extends AttendanceEvent {
  const CheckInStartedEvent();
}

class CheckInSubmittedEvent extends AttendanceEvent {
  final CheckInRequest request;

  const CheckInSubmittedEvent(this.request);

  @override
  List<Object> get props => [request];
}

// Check Out Events
class CheckOutStartedEvent extends AttendanceEvent {
  const CheckOutStartedEvent();
}

class CheckOutSubmittedEvent extends AttendanceEvent {
  final CheckOutRequest request;

  const CheckOutSubmittedEvent(this.request);

  @override
  List<Object> get props => [request];
}

// Form Events
class UpdateCheckInFormEvent extends AttendanceEvent {
  final String? lokasiPenugasan;
  final String? lokasiTerkini;
  final String? ratePatrol;
  final String? pakaianPersonil;
  final String? laporanPengamanan;
  final List<String>? fotoPengamanan;
  final List<String>? tugasLanjutan;
  final String? fotoWajah;

  const UpdateCheckInFormEvent({
    this.lokasiPenugasan,
    this.lokasiTerkini,
    this.ratePatrol,
    this.pakaianPersonil,
    this.laporanPengamanan,
    this.fotoPengamanan,
    this.tugasLanjutan,
    this.fotoWajah,
  });

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
      ];
}

class UpdateCheckOutFormEvent extends AttendanceEvent {
  final String? lokasiPenugasanAkhir;
  final String? statusTugas;
  final String? pakaianPersonil;
  final String? laporanPengamanan;
  final List<String>? fotoPengamanan;
  final List<String>? buktiLaporan;

  const UpdateCheckOutFormEvent({
    this.lokasiPenugasanAkhir,
    this.statusTugas,
    this.pakaianPersonil,
    this.laporanPengamanan,
    this.fotoPengamanan,
    this.buktiLaporan,
  });

  @override
  List<Object?> get props => [
        lokasiPenugasanAkhir,
        statusTugas,
        pakaianPersonil,
        laporanPengamanan,
        fotoPengamanan,
        buktiLaporan,
      ];
}

// Reset Events
class ResetAttendanceEvent extends AttendanceEvent {
  const ResetAttendanceEvent();
}

class ClearErrorEvent extends AttendanceEvent {
  const ClearErrorEvent();
}
