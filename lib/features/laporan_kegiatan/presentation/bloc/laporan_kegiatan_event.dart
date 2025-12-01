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

  const GetLaporanListEvent({
    this.status,
    this.role,
    this.userId,
  });

  @override
  List<Object?> get props => [status, role, userId];
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
  final String id;
  final String note;

  const RequestRevisiEvent({
    required this.id,
    required this.note,
  });

  @override
  List<Object?> get props => [id, note];
}

/// Mark as Tidak Masuk
class MarkAsTidakMasukEvent extends LaporanKegiatanEvent {
  final String id;

  const MarkAsTidakMasukEvent(this.id);

  @override
  List<Object?> get props => [id];
}