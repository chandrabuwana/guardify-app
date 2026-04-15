part of 'laporan_kegiatan_bloc.dart';

/// Base event class
abstract class LaporanKegiatanEvent extends Equatable {
  const LaporanKegiatanEvent();

  @override
  List<Object?> get props => [];
}

/// Get list of laporan kegiatan
class GetLaporanListEvent extends LaporanKegiatanEvent {
  final LaporanStatus? status;
  final UserRole? role;
  final String? userId;
  final String? search;
  final int start;
  final int length;
  final String? startDate;
  final String? endDate;
  final bool isLoadMore;

  const GetLaporanListEvent({
    this.status,
    this.role,
    this.userId,
    this.search,
    this.start = 1,
    this.length = 10,
    this.startDate,
    this.endDate,
    this.isLoadMore = false,
  });

  @override
  List<Object?> get props => [
        status,
        role,
        userId,
        search,
        start,
        length,
        startDate,
        endDate,
        isLoadMore,
      ];
}

/// Get detail laporan kegiatan
class GetLaporanDetailEvent extends LaporanKegiatanEvent {
  final String id;

  const GetLaporanDetailEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Update status laporan
class UpdateStatusEvent extends LaporanKegiatanEvent {
  final String id;
  final LaporanStatus status;
  final String reviewerId;
  final String reviewerName;
  final String? umpanBalik;

  const UpdateStatusEvent({
    required this.id,
    required this.status,
    required this.reviewerId,
    required this.reviewerName,
    this.umpanBalik,
  });

  @override
  List<Object?> get props => [id, status, reviewerId, reviewerName, umpanBalik];
}

/// Accept laporan (shortcut)
class AcceptLaporanEvent extends LaporanKegiatanEvent {
  final String id;

  const AcceptLaporanEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Request revisi
class RequestRevisiEvent extends LaporanKegiatanEvent {
  final String idAttendance;
  final String note;

  const RequestRevisiEvent({
    required this.idAttendance,
    required this.note,
  });

  @override
  List<Object?> get props => [idAttendance, note];
}

/// Mark as Tidak Masuk
class MarkAsTidakMasukEvent extends LaporanKegiatanEvent {
  final String id;

  const MarkAsTidakMasukEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Verifikasi laporan menggunakan API Attendance/verif
class VerifLaporanEvent extends LaporanKegiatanEvent {
  final String idAttendance;
  final bool isVerif;
  final String? feedback;

  const VerifLaporanEvent({
    required this.idAttendance,
    required this.isVerif,
    this.feedback,
  });

  @override
  List<Object?> get props => [idAttendance, isVerif, feedback];
}