part of 'laporan_kegiatan_bloc.dart';

/// Base state class
abstract class LaporanKegiatanState extends Equatable {
  const LaporanKegiatanState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class LaporanInitial extends LaporanKegiatanState {}

/// Loading state
class LaporanLoading extends LaporanKegiatanState {}

/// List loaded state
class LaporanListLoaded extends LaporanKegiatanState {
  final List<LaporanKegiatanEntity> laporanList;

  const LaporanListLoaded({required this.laporanList});

  @override
  List<Object?> get props => [laporanList];
}

/// Detail loaded state
class LaporanDetailLoaded extends LaporanKegiatanState {
  final LaporanKegiatanEntity laporan;

  const LaporanDetailLoaded({required this.laporan});

  @override
  List<Object?> get props => [laporan];
}

/// Updated state
class LaporanUpdated extends LaporanKegiatanState {
  final LaporanKegiatanEntity laporan;

  const LaporanUpdated({required this.laporan});

  @override
  List<Object?> get props => [laporan];
}

/// Error state
class LaporanError extends LaporanKegiatanState {
  final String message;

  const LaporanError({required this.message});

  @override
  List<Object?> get props => [message];
}
