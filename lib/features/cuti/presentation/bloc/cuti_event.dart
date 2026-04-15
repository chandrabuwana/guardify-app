import 'package:equatable/equatable.dart';
import '../../domain/entities/cuti_entity.dart';

abstract class CutiEvent extends Equatable {
  const CutiEvent();

  @override
  List<Object?> get props => [];
}

// Get Kuota Cuti Event
class GetCutiKuotaEvent extends CutiEvent {
  final String userId;

  const GetCutiKuotaEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

// Get Daftar Cuti Saya Event
class GetDaftarCutiSayaEvent extends CutiEvent {
  final String userId;

  const GetDaftarCutiSayaEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

// Get Daftar Cuti Anggota Event
class GetDaftarCutiAnggotaEvent extends CutiEvent {
  final String? status;
  final String? tipeCuti;
  final DateTime? tanggalMulai;
  final DateTime? tanggalSelesai;

  const GetDaftarCutiAnggotaEvent({
    this.status,
    this.tipeCuti,
    this.tanggalMulai,
    this.tanggalSelesai,
  });

  @override
  List<Object?> get props => [status, tipeCuti, tanggalMulai, tanggalSelesai];
}

// Buat Ajuan Cuti Event
class BuatAjuanCutiEvent extends CutiEvent {
  final String userId;
  final String nama;
  final CutiType tipeCuti;
  final int leaveRequestTypeId; // ID dari API
  final DateTime tanggalMulai;
  final DateTime tanggalSelesai;
  final String alasan;
  final int jumlahHari;

  const BuatAjuanCutiEvent({
    required this.userId,
    required this.nama,
    required this.tipeCuti,
    required this.leaveRequestTypeId,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.alasan,
    required this.jumlahHari,
  });

  @override
  List<Object> get props => [
        userId,
        nama,
        tipeCuti,
        leaveRequestTypeId,
        tanggalMulai,
        tanggalSelesai,
        alasan,
        jumlahHari,
      ];
}

// Update Status Cuti Event
class UpdateStatusCutiEvent extends CutiEvent {
  final String cutiId;
  final CutiStatus status;
  final String reviewerId;
  final String reviewerName;
  final String? umpanBalik;

  const UpdateStatusCutiEvent({
    required this.cutiId,
    required this.status,
    required this.reviewerId,
    required this.reviewerName,
    this.umpanBalik,
  });

  @override
  List<Object?> get props =>
      [cutiId, status, reviewerId, reviewerName, umpanBalik];
}

// Filter Cuti Event
class FilterCutiEvent extends CutiEvent {
  final String? status;
  final String? tipeCuti;
  final DateTime? tanggalMulai;
  final DateTime? tanggalSelesai;
  final String? userId;

  const FilterCutiEvent({
    this.status,
    this.tipeCuti,
    this.tanggalMulai,
    this.tanggalSelesai,
    this.userId,
  });

  @override
  List<Object?> get props =>
      [status, tipeCuti, tanggalMulai, tanggalSelesai, userId];
}

// Get Detail Cuti Event
class GetDetailCutiEvent extends CutiEvent {
  final String cutiId;

  const GetDetailCutiEvent(this.cutiId);

  @override
  List<Object> get props => [cutiId];
}

// Get Rekap Cuti Event
class GetRekapCutiEvent extends CutiEvent {
  final DateTime? tanggalMulai;
  final DateTime? tanggalSelesai;
  final String? status;
  final String? tipeCuti;

  const GetRekapCutiEvent({
    this.tanggalMulai,
    this.tanggalSelesai,
    this.status,
    this.tipeCuti,
  });

  @override
  List<Object?> get props => [tanggalMulai, tanggalSelesai, status, tipeCuti];
}

// Reset State Event
class ResetCutiStateEvent extends CutiEvent {
  const ResetCutiStateEvent();
}

// Clear Error Event
class ClearCutiErrorEvent extends CutiEvent {
  const ClearCutiErrorEvent();
}

// Get Leave Request Type List Event
class GetLeaveRequestTypeListEvent extends CutiEvent {
  const GetLeaveRequestTypeListEvent();
}

// Edit Cuti Event
class EditCutiEvent extends CutiEvent {
  final String cutiId;
  final DateTime startDate;
  final DateTime endDate;
  final int idLeaveRequestType;
  final String notes;
  final String userId;
  final String createBy;
  final DateTime createDate;
  final String approveBy;
  final DateTime? approveDate;
  final String notesApproval;
  final String status;

  const EditCutiEvent({
    required this.cutiId,
    required this.startDate,
    required this.endDate,
    required this.idLeaveRequestType,
    required this.notes,
    required this.userId,
    required this.createBy,
    required this.createDate,
    this.approveBy = '-',
    this.approveDate,
    this.notesApproval = '',
    this.status = 'WAITING_APPROVAL',
  });

  @override
  List<Object?> get props => [
        cutiId,
        startDate,
        endDate,
        idLeaveRequestType,
        notes,
        userId,
        createBy,
        createDate,
        approveBy,
        approveDate,
        notesApproval,
        status,
      ];
}

// Delete Cuti Event
class DeleteCutiEvent extends CutiEvent {
  final String cutiId;

  const DeleteCutiEvent(this.cutiId);

  @override
  List<Object> get props => [cutiId];
}