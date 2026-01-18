import 'package:equatable/equatable.dart';
import '../../domain/entities/cuti_entity.dart';
import '../../domain/entities/cuti_kuota_entity.dart';
import '../../domain/entities/leave_request_type_entity.dart';

abstract class CutiState extends Equatable {
  const CutiState();

  @override
  List<Object?> get props => [];
}

// Initial State
class CutiInitial extends CutiState {}

// Loading State
class CutiLoading extends CutiState {}

// Error State
class CutiError extends CutiState {
  final String message;

  const CutiError(this.message);

  @override
  List<Object> get props => [message];
}

// Kuota Cuti Loaded State
class CutiKuotaLoaded extends CutiState {
  final CutiKuotaEntity kuota;

  const CutiKuotaLoaded(this.kuota);

  @override
  List<Object> get props => [kuota];
}

// Daftar Cuti Saya Loaded State
class DaftarCutiSayaLoaded extends CutiState {
  final List<CutiEntity> daftarCuti;

  const DaftarCutiSayaLoaded(this.daftarCuti);

  @override
  List<Object> get props => [daftarCuti];
}

// Daftar Cuti Anggota Loaded State
class DaftarCutiAnggotaLoaded extends CutiState {
  final List<CutiEntity> daftarCuti;

  const DaftarCutiAnggotaLoaded(this.daftarCuti);

  @override
  List<Object> get props => [daftarCuti];
}

// Ajuan Cuti Created Success State
class AjuanCutiCreated extends CutiState {
  final CutiEntity cuti;

  const AjuanCutiCreated(this.cuti);

  @override
  List<Object> get props => [cuti];
}

// Status Cuti Updated Success State
class StatusCutiUpdated extends CutiState {
  final CutiEntity cuti;

  const StatusCutiUpdated(this.cuti);

  @override
  List<Object> get props => [cuti];
}

// Cuti Filtered Success State
class CutiFiltered extends CutiState {
  final List<CutiEntity> daftarCuti;

  const CutiFiltered(this.daftarCuti);

  @override
  List<Object> get props => [daftarCuti];
}

// Detail Cuti Loaded State
class DetailCutiLoaded extends CutiState {
  final CutiEntity cuti;

  const DetailCutiLoaded(this.cuti);

  @override
  List<Object> get props => [cuti];
}

// Rekap Cuti Loaded State
class RekapCutiLoaded extends CutiState {
  final List<CutiEntity> rekapCuti;

  const RekapCutiLoaded(this.rekapCuti);

  @override
  List<Object> get props => [rekapCuti];
}

// Combined State for multiple data
class CutiMultipleDataLoaded extends CutiState {
  final CutiKuotaEntity? kuota;
  final List<CutiEntity>? daftarCutiSaya;
  final List<CutiEntity>? daftarCutiAnggota;
  final List<CutiEntity>? rekapCuti;

  const CutiMultipleDataLoaded({
    this.kuota,
    this.daftarCutiSaya,
    this.daftarCutiAnggota,
    this.rekapCuti,
  });

  @override
  List<Object?> get props =>
      [kuota, daftarCutiSaya, daftarCutiAnggota, rekapCuti];

  CutiMultipleDataLoaded copyWith({
    CutiKuotaEntity? kuota,
    List<CutiEntity>? daftarCutiSaya,
    List<CutiEntity>? daftarCutiAnggota,
    List<CutiEntity>? rekapCuti,
  }) {
    return CutiMultipleDataLoaded(
      kuota: kuota ?? this.kuota,
      daftarCutiSaya: daftarCutiSaya ?? this.daftarCutiSaya,
      daftarCutiAnggota: daftarCutiAnggota ?? this.daftarCutiAnggota,
      rekapCuti: rekapCuti ?? this.rekapCuti,
    );
  }
}

// Leave Request Type List Loaded State
class LeaveRequestTypeListLoaded extends CutiState {
  final List<LeaveRequestTypeEntity> leaveRequestTypes;

  const LeaveRequestTypeListLoaded(this.leaveRequestTypes);

  @override
  List<Object> get props => [leaveRequestTypes];
}

// Cuti Edited Success State
class CutiEdited extends CutiState {
  final CutiEntity cuti;

  const CutiEdited(this.cuti);

  @override
  List<Object> get props => [cuti];
}

// Cuti Deleted Success State
class CutiDeleted extends CutiState {}