import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/tugas_lanjutan_entity.dart';
import '../../domain/usecases/get_tugas_lanjutan_list.dart';
import '../../domain/usecases/get_tugas_lanjutan_detail.dart';
import '../../domain/usecases/selesaikan_tugas.dart';
import '../../domain/usecases/get_progress_summary.dart';

part 'tugas_lanjutan_event.dart';
part 'tugas_lanjutan_state.dart';

@injectable
class TugasLanjutanBloc
    extends Bloc<TugasLanjutanEvent, TugasLanjutanState> {
  final GetTugasLanjutanList getTugasLanjutanList;
  final GetTugasLanjutanDetail getTugasLanjutanDetail;
  final SelesaikanTugas selesaikanTugas;
  final GetProgressSummary getProgressSummary;

  TugasLanjutanBloc({
    required this.getTugasLanjutanList,
    required this.getTugasLanjutanDetail,
    required this.selesaikanTugas,
    required this.getProgressSummary,
  }) : super(TugasLanjutanInitial()) {
    on<GetTugasLanjutanListEvent>(_onGetTugasLanjutanList);
    on<GetTugasLanjutanDetailEvent>(_onGetTugasLanjutanDetail);
    on<SelesaikanTugasEvent>(_onSelesaikanTugas);
    on<GetProgressSummaryEvent>(_onGetProgressSummary);
  }

  Future<void> _onGetTugasLanjutanList(
    GetTugasLanjutanListEvent event,
    Emitter<TugasLanjutanState> emit,
  ) async {
    emit(TugasLanjutanLoading());

    final result = await getTugasLanjutanList(
      filterByToday: event.filterByToday,
      userId: event.userId,
    );

    result.fold(
      (failure) => emit(TugasLanjutanError(message: failure.message)),
      (tugasList) => emit(TugasLanjutanListLoaded(tugasList: tugasList)),
    );
  }

  Future<void> _onGetTugasLanjutanDetail(
    GetTugasLanjutanDetailEvent event,
    Emitter<TugasLanjutanState> emit,
  ) async {
    emit(TugasLanjutanLoading());

    final result = await getTugasLanjutanDetail(event.id);

    result.fold(
      (failure) => emit(TugasLanjutanError(message: failure.message)),
      (tugas) => emit(TugasLanjutanDetailLoaded(tugas: tugas)),
    );
  }

  Future<void> _onSelesaikanTugas(
    SelesaikanTugasEvent event,
    Emitter<TugasLanjutanState> emit,
  ) async {
    emit(TugasLanjutanLoading());

    final result = await selesaikanTugas(
      id: event.id,
      lokasi: event.lokasi,
      buktiUrl: event.buktiUrl,
      catatan: event.catatan,
      userId: event.userId,
      userName: event.userName,
    );

    result.fold(
      (failure) => emit(TugasLanjutanError(message: failure.message)),
      (tugas) => emit(TugasLanjutanUpdated(tugas: tugas)),
    );
  }

  Future<void> _onGetProgressSummary(
    GetProgressSummaryEvent event,
    Emitter<TugasLanjutanState> emit,
  ) async {
    final result = await getProgressSummary(userId: event.userId);

    result.fold(
      (failure) => emit(TugasLanjutanError(message: failure.message)),
      (summary) => emit(TugasLanjutanProgressLoaded(summary: summary)),
    );
  }
}

