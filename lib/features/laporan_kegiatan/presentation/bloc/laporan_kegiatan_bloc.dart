import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/enums.dart';
import '../../domain/entities/laporan_kegiatan_entity.dart';
import '../../domain/usecases/get_laporan_list.dart';
import '../../domain/usecases/get_laporan_detail.dart';
import '../../domain/usecases/update_status_laporan.dart';
import '../../domain/usecases/verif_laporan.dart';

part 'laporan_kegiatan_event.dart';
part 'laporan_kegiatan_state.dart';

@injectable
class LaporanKegiatanBloc
    extends Bloc<LaporanKegiatanEvent, LaporanKegiatanState> {
  final GetLaporanList getLaporanList;
  final GetLaporanDetail getLaporanDetail;
  final UpdateStatusLaporan updateStatusLaporan;
  final VerifLaporan verifLaporan;

  LaporanKegiatanBloc({
    required this.getLaporanList,
    required this.getLaporanDetail,
    required this.updateStatusLaporan,
    required this.verifLaporan,
  }) : super(LaporanInitial()) {
    on<GetLaporanListEvent>(_onGetLaporanList);
    on<GetLaporanDetailEvent>(_onGetLaporanDetail);
    on<UpdateStatusEvent>(_onUpdateStatus);
    on<AcceptLaporanEvent>(_onAcceptLaporan);
    on<RequestRevisiEvent>(_onRequestRevisi);
    on<MarkAsTidakMasukEvent>(_onMarkAsTidakMasuk);
    on<VerifLaporanEvent>(_onVerifLaporan);
  }

  Future<void> _onGetLaporanList(
    GetLaporanListEvent event,
    Emitter<LaporanKegiatanState> emit,
  ) async {
    // If loading more, keep current state and set isLoadingMore
    if (event.isLoadMore) {
      final currentState = state;
      if (currentState is LaporanListLoaded) {
        emit(currentState.copyWith(isLoadingMore: true));
      } else {
        emit(const LaporanLoading(isLoadMore: true));
      }
    } else {
      emit(const LaporanLoading(isLoadMore: false));
    }

    final result = await getLaporanList(
      status: event.status,
      role: event.role,
      userId: event.userId,
      search: event.search,
      start: event.start,
      length: event.length,
    );

    result.fold(
      (failure) {
        // If loading more failed, restore previous state
        if (event.isLoadMore) {
          final currentState = state;
          if (currentState is LaporanListLoaded) {
            emit(currentState.copyWith(isLoadingMore: false));
          } else {
            emit(LaporanError(message: failure.message));
          }
        } else {
          emit(LaporanError(message: failure.message));
        }
      },
      (laporanList) {
        if (event.isLoadMore) {
          // Append new data to existing list
          final currentState = state;
          if (currentState is LaporanListLoaded) {
            final updatedList = [
              ...currentState.laporanList,
              ...laporanList,
            ];
            final hasMore = laporanList.length >= event.length;
            emit(currentState.copyWith(
              laporanList: updatedList,
              hasMore: hasMore,
              isLoadingMore: false,
              currentPage: event.start,
            ));
          } else {
            emit(LaporanListLoaded(
              laporanList: laporanList,
              hasMore: laporanList.length >= event.length,
              currentPage: event.start,
            ));
          }
        } else {
          // Replace with new data
          final hasMore = laporanList.length >= event.length;
          emit(LaporanListLoaded(
            laporanList: laporanList,
            hasMore: hasMore,
            currentPage: event.start,
          ));
        }
      },
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
      status: LaporanStatus.verified,
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

    // Gunakan API verifikasi Attendance/verif dengan IsVerif: false dan Feedback
    final result = await verifLaporan(
      idAttendance: event.idAttendance,
      isVerif: false,
      feedback: event.note,
    );

    result.fold(
      (failure) => emit(LaporanError(message: failure.message)),
      (success) {
        if (success) {
          // Reload detail setelah revisi berhasil
          add(GetLaporanDetailEvent(event.idAttendance));
        } else {
          emit(LaporanError(message: 'Request revisi gagal'));
        }
      },
    );
  }

  Future<void> _onMarkAsTidakMasuk(
    MarkAsTidakMasukEvent event,
    Emitter<LaporanKegiatanState> emit,
  ) async {
    emit(LaporanLoading());

    // Mark as tidak masuk - this would typically update the kehadiran status
    // For now, we'll just reload the detail
    final result = await getLaporanDetail(event.id);

    result.fold(
      (failure) => emit(LaporanError(message: failure.message)),
      (laporan) {
        // Update kehadiran to "Tidak Masuk"
        final updatedLaporan = laporan.copyWith(
          kehadiran: 'Tidak Masuk',
        );
        emit(LaporanDetailLoaded(laporan: updatedLaporan));
      },
    );
  }

  Future<void> _onVerifLaporan(
    VerifLaporanEvent event,
    Emitter<LaporanKegiatanState> emit,
  ) async {
    emit(LaporanLoading());

    final result = await verifLaporan(
      idAttendance: event.idAttendance,
      isVerif: event.isVerif,
      feedback: event.feedback,
    );

    result.fold(
      (failure) => emit(LaporanError(message: failure.message)),
      (success) {
        if (success) {
          // Reload detail setelah verifikasi berhasil
          add(GetLaporanDetailEvent(event.idAttendance));
        } else {
          emit(LaporanError(message: 'Verifikasi gagal'));
        }
      },
    );
  }
}
