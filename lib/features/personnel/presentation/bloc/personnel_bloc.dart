import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/personnel.dart';
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
    const pageSize = 50;
    final currentState = state;

    try {
      if (currentState is PersonnelListLoaded) {
        emit(currentState.copyWith(isLoadingForTab: event.status));
      } else {
        emit(PersonnelLoading());
      }

      final personnelList = await getPersonnelByStatusUseCase(
        event.status,
        page: 1,
        pageSize: pageSize,
      );

      final tabData = TabPersonnelData(
        personnelList: personnelList,
        currentPage: 1,
        hasReachedMax:
            personnelList.isEmpty || personnelList.length < pageSize,
      );

      final newTabData = Map<String, TabPersonnelData>.from(
        currentState is PersonnelListLoaded ? currentState.tabData : {},
      )..[event.status] = tabData;

      emit(PersonnelListLoaded(tabData: newTabData));
    } catch (e) {
      if (currentState is PersonnelListLoaded) {
        emit(currentState.copyWith(clearLoadingForTab: true));
      }
      emit(PersonnelError('Gagal memuat data personil: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMorePersonnel(
    LoadMorePersonnelEvent event,
    Emitter<PersonnelState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PersonnelListLoaded) return;

    final tab = currentState.getTabData(event.status);
    if (tab == null || tab.hasReachedMax || tab.isLoadingMore) return;

    const pageSize = 50;

    try {
      final updatedTab = tab.copyWith(isLoadingMore: true);
      final newTabData = Map<String, TabPersonnelData>.from(currentState.tabData)
        ..[event.status] = updatedTab;
      emit(currentState.copyWith(tabData: newTabData));

      final nextPage = tab.currentPage + 1;
      final newPersonnelList = await getPersonnelByStatusUseCase(
        event.status,
        page: nextPage,
        pageSize: pageSize,
      );

      final hasReachedMax =
          newPersonnelList.isEmpty || newPersonnelList.length < pageSize;
      final mergedTab = TabPersonnelData(
        personnelList: [...tab.personnelList, ...newPersonnelList],
        currentPage: nextPage,
        hasReachedMax: hasReachedMax,
        isLoadingMore: false,
      );
      final finalTabData =
          Map<String, TabPersonnelData>.from(currentState.tabData)
            ..[event.status] = mergedTab;

      emit(currentState.copyWith(tabData: finalTabData));
    } catch (_) {
      final revertedTab = tab.copyWith(isLoadingMore: false);
      final newTabData = Map<String, TabPersonnelData>.from(currentState.tabData)
        ..[event.status] = revertedTab;
      emit(currentState.copyWith(tabData: newTabData));
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
    final currentState = state;
    if (currentState is! PersonnelListLoaded) return;

    final tab = currentState.getTabData(event.status);
    if (tab == null) return;

    final q = event.query.toLowerCase();
    final filteredList = tab.personnelList
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.nrp.toLowerCase().contains(q))
        .toList();

    final newFilteredMap = Map<String, List<Personnel>>.from(currentState.searchFilteredMap);
    if (event.query.isEmpty) {
      newFilteredMap.remove(event.status);
    } else {
      newFilteredMap[event.status] = filteredList;
    }

    emit(currentState.copyWith(
      isSearching: event.query.isNotEmpty,
      searchQuery: event.query,
      searchFilteredMap: newFilteredMap,
    ));
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
