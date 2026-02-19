import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_incident_list.dart';
import '../../domain/usecases/get_my_tasks.dart';
import '../../domain/usecases/get_incident_detail.dart';
import '../../domain/usecases/create_incident_report.dart';
import '../../domain/usecases/get_incident_locations.dart';
import '../../domain/usecases/get_incident_types.dart';
import '../../domain/usecases/update_incident_status.dart';
import '../../domain/usecases/edit_incident.dart';
import '../../domain/usecases/update_all_incident.dart';
import 'incident_event.dart';
import 'incident_state.dart';

@injectable
class IncidentBloc extends Bloc<IncidentEvent, IncidentState> {
  final GetIncidentList getIncidentList;
  final GetMyTasks getMyTasks;
  final GetIncidentDetail getIncidentDetail;
  final CreateIncidentReport createIncidentReport;
  final GetIncidentLocations getIncidentLocations;
  final GetIncidentTypes getIncidentTypes;
  final UpdateIncidentStatus updateIncidentStatus;
  final EditIncident editIncident;
  final UpdateAllIncident updateAllIncident;

  static const int pageSize = 50; // Increased from 10 to 50 to show more incidents

  IncidentBloc({
    required this.getIncidentList,
    required this.getMyTasks,
    required this.getIncidentDetail,
    required this.createIncidentReport,
    required this.getIncidentLocations,
    required this.getIncidentTypes,
    required this.updateIncidentStatus,
    required this.editIncident,
    required this.updateAllIncident,
  }) : super(const IncidentState()) {
    on<LoadIncidentListEvent>(_onLoadIncidentList);
    on<LoadMoreIncidentListEvent>(_onLoadMoreIncidentList);
    on<RefreshIncidentListEvent>(_onRefreshIncidentList);
    on<SearchIncidentListEvent>(_onSearchIncidentList);
    on<LoadMyTasksEvent>(_onLoadMyTasks);
    on<LoadMoreMyTasksEvent>(_onLoadMoreMyTasks);
    on<RefreshMyTasksEvent>(_onRefreshMyTasks);
    on<SearchMyTasksEvent>(_onSearchMyTasks);
    on<GetIncidentDetailEvent>(_onGetIncidentDetail);
    on<CreateIncidentReportEvent>(_onCreateIncidentReport);
    on<LoadIncidentLocationsEvent>(_onLoadIncidentLocations);
    on<LoadIncidentTypesEvent>(_onLoadIncidentTypes);
    on<UpdateIncidentStatusEvent>(_onUpdateIncidentStatus);
    on<EditIncidentEvent>(_onEditIncident);
    on<UpdateAllIncidentEvent>(_onUpdateAllIncident);
    on<ClearIncidentErrorEvent>(_onClearError);
  }

  Future<void> _onLoadIncidentList(
    LoadIncidentListEvent event,
    Emitter<IncidentState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      clearError: true,
      hasReachedMax: false,
      currentPage: 0,
      clearIncidentList: true,
    ));

    try {
      // Use pageSize for consistency
      final incidents = await getIncidentList(
        start: event.start,
        length: event.length, // Now defaults to 50 from LoadIncidentListEvent
        searchQuery: event.searchQuery,
        status: event.status,
      );

      emit(IncidentState(
        isLoading: false,
        isLoadingMore: false,
        incidentList: incidents,
        myTasks: state.myTasks,
        incidentDetail: state.incidentDetail,
        locations: state.locations,
        types: state.types,
        errorMessage: null,
        searchQuery: event.searchQuery,
        currentPage: 0,
        hasReachedMax: incidents.length < pageSize,
        hasReachedMaxMyTasks: state.hasReachedMaxMyTasks,
        currentPageMyTasks: state.currentPageMyTasks,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal memuat daftar insiden: ${e.toString()}',
      ));
    }
  }

  Future<void> _onLoadMoreIncidentList(
    LoadMoreIncidentListEvent event,
    Emitter<IncidentState> emit,
  ) async {
    if (state.hasReachedMax || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true, clearError: true));

    try {
      final nextPage = state.currentPage + 1;
      final incidents = await getIncidentList(
        start: nextPage * pageSize,
        length: pageSize,
        searchQuery: state.searchQuery,
      );

      // Create new state with ALL new lists to ensure Equatable detects the change
      emit(IncidentState(
        isLoading: state.isLoading,
        isLoadingMore: false,
        incidentList: List.from([...state.incidentList, ...incidents]), // New list
        myTasks: List.from(state.myTasks), // New list reference
        incidentDetail: state.incidentDetail,
        locations: List.from(state.locations), // New list reference
        types: List.from(state.types), // New list reference
        errorMessage: null,
        searchQuery: state.searchQuery,
        currentPage: nextPage,
        hasReachedMax: incidents.length < pageSize,
        hasReachedMaxMyTasks: state.hasReachedMaxMyTasks,
        currentPageMyTasks: state.currentPageMyTasks,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        errorMessage: 'Gagal memuat lebih banyak insiden: ${e.toString()}',
      ));
    }
  }

  Future<void> _onRefreshIncidentList(
    RefreshIncidentListEvent event,
    Emitter<IncidentState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      clearError: true,
      hasReachedMax: false,
      currentPage: 0,
      clearIncidentList: true,
    ));

    try {
      final incidents = await getIncidentList(
        start: 0,
        length: pageSize,
        searchQuery: state.searchQuery,
      );

      // Create new state with ALL new lists to ensure Equatable detects the change
      emit(IncidentState(
        isLoading: false,
        isLoadingMore: false,
        incidentList: List.from(incidents), // New list
        myTasks: List.from(state.myTasks), // New list reference
        incidentDetail: state.incidentDetail,
        locations: List.from(state.locations), // New list reference
        types: List.from(state.types), // New list reference
        errorMessage: null,
        searchQuery: state.searchQuery,
        currentPage: 0,
        hasReachedMax: incidents.length < pageSize,
        hasReachedMaxMyTasks: state.hasReachedMaxMyTasks,
        currentPageMyTasks: state.currentPageMyTasks,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal memuat ulang daftar insiden: ${e.toString()}',
      ));
    }
  }

  Future<void> _onSearchIncidentList(
    SearchIncidentListEvent event,
    Emitter<IncidentState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      clearError: true,
      searchQuery: event.query,
      hasReachedMax: false,
      currentPage: 0,
      clearIncidentList: true,
    ));

    try {
      final incidents = await getIncidentList(
        start: 0,
        length: pageSize,
        searchQuery: event.query.isEmpty ? null : event.query,
      );

      // Create new state with ALL new lists to ensure Equatable detects the change
      emit(IncidentState(
        isLoading: false,
        isLoadingMore: false,
        incidentList: List.from(incidents), // New list
        myTasks: List.from(state.myTasks), // New list reference
        incidentDetail: state.incidentDetail,
        locations: List.from(state.locations), // New list reference
        types: List.from(state.types), // New list reference
        errorMessage: null,
        searchQuery: event.query,
        currentPage: 0,
        hasReachedMax: incidents.length < pageSize,
        hasReachedMaxMyTasks: state.hasReachedMaxMyTasks,
        currentPageMyTasks: state.currentPageMyTasks,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal mencari insiden: ${e.toString()}',
      ));
    }
  }

  Future<void> _onLoadMyTasks(
    LoadMyTasksEvent event,
    Emitter<IncidentState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      clearError: true,
      hasReachedMaxMyTasks: false,
      currentPageMyTasks: 0,
      clearMyTasks: true,
    ));

    try {
      final tasks = await getMyTasks(
        start: event.start,
        length: event.length,
        searchQuery: event.searchQuery,
        status: event.status,
      );

      emit(state.copyWith(
        isLoading: false,
        myTasks: tasks,
        hasReachedMaxMyTasks: tasks.length < pageSize,
        currentPageMyTasks: 0,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal memuat tugas saya: ${e.toString()}',
      ));
    }
  }

  Future<void> _onLoadMoreMyTasks(
    LoadMoreMyTasksEvent event,
    Emitter<IncidentState> emit,
  ) async {
    if (state.hasReachedMaxMyTasks || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true, clearError: true));

    try {
      final nextPage = state.currentPageMyTasks + 1;
      final tasks = await getMyTasks(
        start: nextPage * pageSize,
        length: pageSize,
        searchQuery: state.searchQuery,
      );

      emit(state.copyWith(
        isLoadingMore: false,
        myTasks: [...state.myTasks, ...tasks],
        hasReachedMaxMyTasks: tasks.length < pageSize,
        currentPageMyTasks: nextPage,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        errorMessage: 'Gagal memuat lebih banyak tugas: ${e.toString()}',
      ));
    }
  }

  Future<void> _onRefreshMyTasks(
    RefreshMyTasksEvent event,
    Emitter<IncidentState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      clearError: true,
      hasReachedMaxMyTasks: false,
      currentPageMyTasks: 0,
      clearMyTasks: true,
    ));

    try {
      final tasks = await getMyTasks(
        start: 0,
        length: pageSize,
        searchQuery: state.searchQuery,
      );

      emit(state.copyWith(
        isLoading: false,
        myTasks: tasks,
        hasReachedMaxMyTasks: tasks.length < pageSize,
        currentPageMyTasks: 0,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal memuat ulang tugas saya: ${e.toString()}',
      ));
    }
  }

  Future<void> _onSearchMyTasks(
    SearchMyTasksEvent event,
    Emitter<IncidentState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      clearError: true,
      searchQuery: event.query,
      hasReachedMaxMyTasks: false,
      currentPageMyTasks: 0,
      clearMyTasks: true,
    ));

    try {
      final tasks = await getMyTasks(
        start: 0,
        length: pageSize,
        searchQuery: event.query.isEmpty ? null : event.query,
      );

      emit(state.copyWith(
        isLoading: false,
        myTasks: tasks,
        hasReachedMaxMyTasks: tasks.length < pageSize,
        currentPageMyTasks: 0,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal mencari tugas: ${e.toString()}',
      ));
    }
  }

  Future<void> _onGetIncidentDetail(
    GetIncidentDetailEvent event,
    Emitter<IncidentState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final incident = await getIncidentDetail(event.incidentId);
      emit(state.copyWith(
        isLoading: false,
        incidentDetail: incident,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal memuat detail insiden: ${e.toString()}',
      ));
    }
  }

  Future<void> _onCreateIncidentReport(
    CreateIncidentReportEvent event,
    Emitter<IncidentState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final incident = await createIncidentReport(
        reporterId: event.reporterId,
        tanggalInsiden: event.tanggalInsiden,
        jamInsiden: event.jamInsiden,
        lokasiInsidenId: event.lokasiInsidenId,
        lokasiInsidenName: event.lokasiInsidenName,
        detailLokasiInsiden: event.detailLokasiInsiden,
        tipeInsidenId: event.tipeInsidenId,
        deskripsiInsiden: event.deskripsiInsiden,
        fotoInsiden: event.fotoInsiden,
        fileUrls: event.fileUrls,
      );

      emit(state.copyWith(
        isLoading: false,
        incidentDetail: incident,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal membuat laporan insiden: ${e.toString()}',
      ));
    }
  }

  Future<void> _onLoadIncidentLocations(
    LoadIncidentLocationsEvent event,
    Emitter<IncidentState> emit,
  ) async {
    try {
      final locations = await getIncidentLocations();
      emit(state.copyWith(locations: locations));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Gagal memuat lokasi: ${e.toString()}',
      ));
    }
  }

  Future<void> _onLoadIncidentTypes(
    LoadIncidentTypesEvent event,
    Emitter<IncidentState> emit,
  ) async {
    try {
      final types = await getIncidentTypes();
      emit(state.copyWith(types: types));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Gagal memuat tipe insiden: ${e.toString()}',
      ));
    }
  }

  Future<void> _onUpdateIncidentStatus(
    UpdateIncidentStatusEvent event,
    Emitter<IncidentState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final success = await updateIncidentStatus(
        incidentId: event.incidentId,
        status: event.status,
        notes: event.notes,
        file: event.file,
      );

      if (success) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: null,
        ));
        // Refresh lists after update
        add(const RefreshIncidentListEvent());
        add(const RefreshMyTasksEvent());
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Gagal memperbarui status insiden',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal memperbarui status insiden: ${e.toString()}',
      ));
    }
  }

  Future<void> _onEditIncident(
    EditIncidentEvent event,
    Emitter<IncidentState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final success = await editIncident(
        incidentId: event.incidentId,
        areasDescription: event.areasDescription,
        areasId: event.areasId,
        idIncidentType: event.idIncidentType,
        incidentDate: event.incidentDate,
        incidentTime: event.incidentTime,
        incidentDescription: event.incidentDescription,
        reportId: event.reportId,
        notesAction: event.notesAction,
        picId: event.picId,
        pjId: event.pjId,
        solvedAction: event.solvedAction,
        solvedDate: event.solvedDate,
        status: event.status,
      );

      if (success) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: null,
        ));
        // Refresh lists after edit
        add(const RefreshIncidentListEvent());
        add(const RefreshMyTasksEvent());
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Gagal mengedit insiden',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal mengedit insiden: ${e.toString()}',
      )      );
    }
  }

  Future<void> _onUpdateAllIncident(
    UpdateAllIncidentEvent event,
    Emitter<IncidentState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final success = await updateAllIncident(
        incidentId: event.incidentId,
        areasDescription: event.areasDescription,
        areasId: event.areasId,
        idIncidentType: event.idIncidentType,
        incidentDate: event.incidentDate,
        incidentTime: event.incidentTime,
        incidentDescription: event.incidentDescription,
        reportId: event.reportId,
        notesAction: event.notesAction,
        picId: event.picId,
        team: event.team,
        handlingTask: event.handlingTask,
        actionTakenNote: event.actionTakenNote,
        solvedAction: event.solvedAction,
        solvedDate: event.solvedDate,
        evidence: event.evidence,
        status: event.status,
        incidentImage: event.incidentImage,
      );

      if (success) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: null,
        ));
        // Refresh lists after update
        add(const RefreshIncidentListEvent());
        add(const RefreshMyTasksEvent());
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Gagal memperbarui insiden',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal memperbarui insiden: ${e.toString()}',
      ));
    }
  }

  void _onClearError(
    ClearIncidentErrorEvent event,
    Emitter<IncidentState> emit,
  ) {
    emit(state.copyWith(clearError: true));
  }
}
