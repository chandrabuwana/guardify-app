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
class LaporanLoading extends LaporanKegiatanState {
  final bool isLoadMore;

  const LaporanLoading({this.isLoadMore = false});

  @override
  List<Object?> get props => [isLoadMore];
}

/// List loaded state
class LaporanListLoaded extends LaporanKegiatanState {
  final List<LaporanKegiatanEntity> laporanList;
  final bool hasMore;
  final bool isLoadingMore;
  final int currentPage;

  const LaporanListLoaded({
    required this.laporanList,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.currentPage = 1,
  });

  LaporanListLoaded copyWith({
    List<LaporanKegiatanEntity>? laporanList,
    bool? hasMore,
    bool? isLoadingMore,
    int? currentPage,
  }) {
    return LaporanListLoaded(
      laporanList: laporanList ?? this.laporanList,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [laporanList, hasMore, isLoadingMore, currentPage];
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
