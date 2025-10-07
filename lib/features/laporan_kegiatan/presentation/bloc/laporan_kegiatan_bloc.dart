import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/enums.dart';
import '../../domain/entities/laporan_kegiatan_entity.dart';
import '../../domain/usecases/get_laporan_list.dart';
import '../../domain/usecases/get_laporan_detail.dart';
import '../../domain/usecases/update_status_laporan.dart';

part 'laporan_kegiatan_event.dart';
part 'laporan_kegiatan_state.dart';

@injectable
class LaporanKegiatanBloc
    extends Bloc<LaporanKegiatanEvent, LaporanKegiatanState> {
  final GetLaporanList getLaporanList;
  final GetLaporanDetail getLaporanDetail;
  final UpdateStatusLaporan updateStatusLaporan;

  LaporanKegiatanBloc({
    required this.getLaporanList,
    required this.getLaporanDetail,
    required this.updateStatusLaporan,
  }) : super(LaporanInitial()) {
    on<GetLaporanListEvent>(_onGetLaporanList);
    on<GetLaporanDetailEvent>(_onGetLaporanDetail);
    on<UpdateStatusEvent>(_onUpdateStatus);
    on<AcceptLaporanEvent>(_onAcceptLaporan);
    on<RequestRevisiEvent>(_onRequestRevisi);
  }

  Future<void> _onGetLaporanList(
    GetLaporanListEvent event,
    Emitter<LaporanKegiatanState> emit,
  ) async {
    emit(LaporanLoading());

    final result = await getLaporanList(
      status: event.status,
      role: event.role,
      userId: event.userId,
    );

    result.fold(
      (failure) => emit(LaporanError(message: failure.message)),
      (laporanList) => emit(LaporanListLoaded(laporanList: laporanList)),
    );
  }

  Future<void> _onGetLaporanDetail(
    GetLaporanDetailEvent event,
    Emitter<LaporanKegiatanState> emit,
  ) async {
    emit(LaporanLoading());

    final result = await getLaporanDetail(event.id);

    result.fold(
      (failure) => emit(LaporanError(message: failure.message)),
      (laporan) => emit(LaporanDetailLoaded(laporan: laporan)),
    );
  }

  Future<void> _onUpdateStatus(
    UpdateStatusEvent event,
    Emitter<LaporanKegiatanState> emit,
  ) async {
    emit(LaporanLoading());

    final result = await updateStatusLaporan(
      id: event.id,
      status: event.status,
      reviewerId: event.reviewerId,
      reviewerName: event.reviewerName,
      umpanBalik: event.umpanBalik,
    );

    result.fold(
      (failure) => emit(LaporanError(message: failure.message)),
      (laporan) => emit(LaporanUpdated(laporan: laporan)),
    );
  }

  Future<void> _onAcceptLaporan(
    AcceptLaporanEvent event,
    Emitter<LaporanKegiatanState> emit,
  ) async {
    emit(LaporanLoading());

    final result = await updateStatusLaporan(
      id: event.id,
      status: LaporanStatus.terverifikasi,
      reviewerId: 'current_user_id', // Should be from context
      reviewerName: 'Current User',
    );

    result.fold(
      (failure) => emit(LaporanError(message: failure.message)),
      (laporan) => emit(LaporanUpdated(laporan: laporan)),
    );
  }

  Future<void> _onRequestRevisi(
    RequestRevisiEvent event,
    Emitter<LaporanKegiatanState> emit,
  ) async {
    emit(LaporanLoading());

    final result = await updateStatusLaporan(
      id: event.id,
      status: LaporanStatus.revisi,
      reviewerId: 'current_user_id', // Should be from context
      reviewerName: 'Current User',
      umpanBalik: event.note,
    );

    result.fold(
      (failure) => emit(LaporanError(message: failure.message)),
      (laporan) => emit(LaporanUpdated(laporan: laporan)),
    );
  }
}
