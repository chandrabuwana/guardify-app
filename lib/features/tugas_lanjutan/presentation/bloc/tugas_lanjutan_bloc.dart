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
    on<SearchTugasLanjutanEvent>(_onSearchTugasLanjutan);
    on<FilterTugasLanjutanEvent>(_onFilterTugasLanjutan);
  }

  Future<void> _onGetTugasLanjutanList(
    GetTugasLanjutanListEvent event,
    Emitter<TugasLanjutanState> emit,
  ) async {
    emit(TugasLanjutanLoading());

    final result = await getTugasLanjutanList(
      filterByToday: event.filterByToday,
      userId: event.userId,
      filterByJabatan: event.filterByJabatan,
      jabatan: event.jabatan,
      status: event.status,
    );

    await result.fold(
      (failure) async {
        emit(TugasLanjutanError(message: failure.message));
      },
      (tugasList) async {
        // Debug: Print list length
        print('📋 TugasLanjutanBloc: Loaded ${tugasList.length} tasks');
        
        // Check if we have progress data in current state
        final currentState = state;
        if (currentState is TugasLanjutanProgressLoaded) {
          // If progress is already loaded, combine both
          emit(TugasLanjutanListAndProgressLoaded(
            tugasList: tugasList,
            summary: currentState.summary,
          ));
        } else {
          // Emit list first
          emit(TugasLanjutanListLoaded(
            tugasList: tugasList,
            filteredList: tugasList,
          ));
          
          // If this is for "Hari Ini" tab (filterByToday = true), also load progress summary
          if (event.filterByToday && event.userId != null) {
            // Load progress summary after list is loaded
            final progressResult = await getProgressSummary(userId: event.userId!);
            progressResult.fold(
              (failure) {
                // If progress fails, keep the list loaded
                print('📋 TugasLanjutanBloc: Failed to load progress: ${failure.message}');
              },
              (summary) {
                // Combine list and progress
                emit(TugasLanjutanListAndProgressLoaded(
                  tugasList: tugasList,
                  filteredList: tugasList,
                  summary: summary,
                ));
              },
            );
          }
        }
      },
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
      (summary) {
        // Check if we have list data in current state
        final currentState = state;
        if (currentState is TugasLanjutanListLoaded) {
          // If list is already loaded, combine both
          emit(TugasLanjutanListAndProgressLoaded(
            tugasList: currentState.tugasList,
            summary: summary,
          ));
        } else if (currentState is TugasLanjutanListAndProgressLoaded) {
          // If both are already loaded, update progress
          emit(TugasLanjutanListAndProgressLoaded(
            tugasList: currentState.tugasList,
            summary: summary,
          ));
        } else {
          emit(TugasLanjutanProgressLoaded(summary: summary));
        }
      },
    );
  }

  void _onSearchTugasLanjutan(
    SearchTugasLanjutanEvent event,
    Emitter<TugasLanjutanState> emit,
  ) {
    final currentState = state;
    final query = event.query.trim().toLowerCase();

    if (currentState is TugasLanjutanListLoaded) {
      final filtered = _applyFilters(
        all: currentState.tugasList,
        query: query,
        status: currentState.selectedStatus,
      );
      emit(currentState.copyWith(filteredList: filtered, searchQuery: query));
    } else if (currentState is TugasLanjutanListAndProgressLoaded) {
      final filtered = _applyFilters(
        all: currentState.tugasList,
        query: query,
        status: currentState.selectedStatus,
      );
      emit(currentState.copyWith(filteredList: filtered, searchQuery: query));
    }
  }

  void _onFilterTugasLanjutan(
    FilterTugasLanjutanEvent event,
    Emitter<TugasLanjutanState> emit,
  ) {
    final currentState = state;

    if (currentState is TugasLanjutanListLoaded) {
      final filtered = _applyFilters(
        all: currentState.tugasList,
        query: currentState.searchQuery,
        status: event.status,
      );
      if (event.status == null) {
        emit(currentState.copyWith(filteredList: filtered, clearSelectedStatus: true));
      } else {
        emit(currentState.copyWith(filteredList: filtered, selectedStatus: event.status));
      }
    } else if (currentState is TugasLanjutanListAndProgressLoaded) {
      final filtered = _applyFilters(
        all: currentState.tugasList,
        query: currentState.searchQuery,
        status: event.status,
      );
      if (event.status == null) {
        emit(currentState.copyWith(filteredList: filtered, clearSelectedStatus: true));
      } else {
        emit(currentState.copyWith(filteredList: filtered, selectedStatus: event.status));
      }
    }
  }

  List<TugasLanjutanEntity> _applyFilters({
    required List<TugasLanjutanEntity> all,
    required String query,
    required TugasLanjutanStatus? status,
  }) {
    return all.where((tugas) {
      final matchesText = query.isEmpty ||
          tugas.title.toLowerCase().contains(query) ||
          tugas.lokasi.toLowerCase().contains(query) ||
          tugas.pelapor.toLowerCase().contains(query) ||
          tugas.deskripsi.toLowerCase().contains(query);
      final matchesStatus = status == null || tugas.status == status;
      return matchesText && matchesStatus;
    }).toList();
  }
}

