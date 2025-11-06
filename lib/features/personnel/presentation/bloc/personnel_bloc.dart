import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_personnel_by_status_use_case.dart';
import '../../domain/usecases/get_personnel_detail_use_case.dart';
import '../../domain/usecases/approve_personnel_use_case.dart';
import '../../domain/usecases/revise_personnel_use_case.dart';
import 'personnel_event.dart';
import 'personnel_state.dart';

@injectable
class PersonnelBloc extends Bloc<PersonnelEvent, PersonnelState> {
  final GetPersonnelByStatusUseCase getPersonnelByStatusUseCase;
  final GetPersonnelDetailUseCase getPersonnelDetailUseCase;
  final ApprovePersonnelUseCase approvePersonnelUseCase;
  final RevisePersonnelUseCase revisePersonnelUseCase;

  PersonnelBloc({
    required this.getPersonnelByStatusUseCase,
    required this.getPersonnelDetailUseCase,
    required this.approvePersonnelUseCase,
    required this.revisePersonnelUseCase,
  }) : super(PersonnelInitial()) {
    on<LoadPersonnelByStatusEvent>(_onLoadPersonnelByStatus);
    on<LoadMorePersonnelEvent>(_onLoadMorePersonnel);
    on<LoadPersonnelDetailEvent>(_onLoadPersonnelDetail);
    on<SearchPersonnelEvent>(_onSearchPersonnel);
    on<ApprovePersonnelEvent>(_onApprovePersonnel);
    on<RevisePersonnelEvent>(_onRevisePersonnel);
    on<ClearPersonnelDetailEvent>(_onClearPersonnelDetail);
  }

  Future<void> _onLoadPersonnelByStatus(
    LoadPersonnelByStatusEvent event,
    Emitter<PersonnelState> emit,
  ) async {
    emit(PersonnelLoading());

    try {
      final personnelList = await getPersonnelByStatusUseCase(
        event.status,
        page: 1, // Always start from page 1
        pageSize: event.pageSize,
      );

      emit(PersonnelListLoaded(
        personnelList: personnelList,
        currentStatus: event.status,
        currentPage: 1,
        hasReachedMax: personnelList.length < event.pageSize, // If less than pageSize, reached max
      ));
    } catch (e) {
      emit(PersonnelError('Gagal memuat data personil: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMorePersonnel(
    LoadMorePersonnelEvent event,
    Emitter<PersonnelState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PersonnelListLoaded) return;
    if (currentState.hasReachedMax) return; // Don't load if reached max
    if (currentState.isLoadingMore) return; // Prevent duplicate loads

    try {
      // Emit loading more state
      emit(currentState.copyWith(isLoadingMore: true));

      final nextPage = currentState.currentPage + 1;
      final newPersonnelList = await getPersonnelByStatusUseCase(
        currentState.currentStatus,
        page: nextPage,
        pageSize: 20,
      );

      // If no more data, mark as reached max
      final hasReachedMax = newPersonnelList.isEmpty || newPersonnelList.length < 20;

      emit(currentState.copyWith(
        personnelList: [...currentState.personnelList, ...newPersonnelList],
        currentPage: nextPage,
        hasReachedMax: hasReachedMax,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(PersonnelError('Gagal memuat data personil: ${e.toString()}'));
    }
  }

  Future<void> _onLoadPersonnelDetail(
    LoadPersonnelDetailEvent event,
    Emitter<PersonnelState> emit,
  ) async {
    emit(PersonnelLoading());

    try {
      final personnel = await getPersonnelDetailUseCase(event.personnelId);

      if (personnel != null) {
        emit(PersonnelDetailLoaded(personnel));
      } else {
        emit(const PersonnelError('Data personil tidak ditemukan'));
      }
    } catch (e) {
      emit(PersonnelError('Gagal memuat detail personil: ${e.toString()}'));
    }
  }

  Future<void> _onSearchPersonnel(
    SearchPersonnelEvent event,
    Emitter<PersonnelState> emit,
  ) async {
    // Keep current state while searching
    final currentState = state;
    if (currentState is PersonnelListLoaded) {
      emit(PersonnelLoading());

      try {
        // For now, just filter from current list (in production, call API)
        final filteredList = currentState.personnelList
            .where((p) =>
                p.name.toLowerCase().contains(event.query.toLowerCase()) ||
                p.nrp.toLowerCase().contains(event.query.toLowerCase()))
            .toList();

        emit(PersonnelListLoaded(
          personnelList: filteredList,
          currentStatus: event.status,
          isSearching: event.query.isNotEmpty,
          searchQuery: event.query,
        ));
      } catch (e) {
        emit(PersonnelError('Gagal mencari personil: ${e.toString()}'));
      }
    }
  }

  Future<void> _onApprovePersonnel(
    ApprovePersonnelEvent event,
    Emitter<PersonnelState> emit,
  ) async {
    emit(PersonnelLoading());

    try {
      final success = await approvePersonnelUseCase(event.personnelId, event.feedback);

      if (success) {
        emit(const PersonnelActionSuccess('Personil berhasil disetujui'));
      } else {
        emit(const PersonnelError('Gagal menyetujui personil'));
      }
    } catch (e) {
      emit(PersonnelError('Gagal menyetujui personil: ${e.toString()}'));
    }
  }

  Future<void> _onRevisePersonnel(
    RevisePersonnelEvent event,
    Emitter<PersonnelState> emit,
  ) async {
    emit(PersonnelLoading());

    try {
      final success = await revisePersonnelUseCase(event.personnelId, event.feedback);

      if (success) {
        emit(const PersonnelActionSuccess('Permintaan revisi berhasil dikirim'));
      } else {
        emit(const PersonnelError('Gagal mengirim permintaan revisi'));
      }
    } catch (e) {
      emit(PersonnelError('Gagal mengirim permintaan revisi: ${e.toString()}'));
    }
  }

  void _onClearPersonnelDetail(
    ClearPersonnelDetailEvent event,
    Emitter<PersonnelState> emit,
  ) {
    emit(PersonnelInitial());
  }
}
