import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/attendance_rekap_entity.dart';
import '../../domain/usecases/get_attendance_rekap_usecase.dart';
import 'attendance_rekap_event.dart';
import 'attendance_rekap_state.dart';

@injectable
class AttendanceRekapBloc
    extends Bloc<AttendanceRekapEvent, AttendanceRekapState> {
  final GetAttendanceRekapUseCase getAttendanceRekapUseCase;
  String? _pendingSearchQuery;
  String? _pendingStatusFilter;

  AttendanceRekapBloc({required this.getAttendanceRekapUseCase})
      : super(const AttendanceRekapInitial()) {
    on<LoadAttendanceRekapEvent>(_onLoadAttendanceRekap);
    on<SearchAttendanceRekapEvent>(_onSearchAttendanceRekap);
    on<FilterAttendanceRekapEvent>(_onFilterAttendanceRekap);
    on<ClearSearchAttendanceRekapEvent>(_onClearSearch);
    on<RefreshAttendanceRekapEvent>(_onRefreshAttendanceRekap);
  }

  Future<void> _onLoadAttendanceRekap(
    LoadAttendanceRekapEvent event,
    Emitter<AttendanceRekapState> emit,
  ) async {
    emit(const AttendanceRekapLoading());

    final result = await getAttendanceRekapUseCase(event.request);

    result.fold(
      (failure) => emit(AttendanceRekapFailure(failure.message)),
      (response) {
        var filteredItems = response.succeeded && response.list.isNotEmpty
            ? response.list
            : const <AttendanceRekapEntity>[];

        // Apply pending search query if any
        if (_pendingSearchQuery != null && _pendingSearchQuery!.isNotEmpty) {
          filteredItems = _performSearch(filteredItems, _pendingSearchQuery!);
        }

        // Apply pending status filter if any
        if (_pendingStatusFilter != null && _pendingStatusFilter!.isNotEmpty) {
          filteredItems = _performFilter(filteredItems, _pendingStatusFilter!);
        }

        emit(AttendanceRekapLoaded(
          allItems: response.succeeded && response.list.isNotEmpty
              ? response.list
              : const <AttendanceRekapEntity>[],
          filteredItems: filteredItems,
          searchQuery: _pendingSearchQuery,
          statusFilter: _pendingStatusFilter,
          count: response.count,
          filtered: response.filtered,
        ));
      },
    );
  }

  Future<void> _onRefreshAttendanceRekap(
    RefreshAttendanceRekapEvent event,
    Emitter<AttendanceRekapState> emit,
  ) async {
    final result = await getAttendanceRekapUseCase(event.request);

    result.fold(
      (failure) => emit(AttendanceRekapFailure(failure.message)),
      (response) {
        if (response.succeeded) {
          final currentState = state;
          if (currentState is AttendanceRekapLoaded) {
            // Apply existing filters
            var filteredItems = response.list;
            if (currentState.searchQuery != null &&
                currentState.searchQuery!.isNotEmpty) {
              filteredItems = _performSearch(
                  filteredItems, currentState.searchQuery!);
            }
            if (currentState.statusFilter != null &&
                currentState.statusFilter!.isNotEmpty) {
              filteredItems =
                  _performFilter(filteredItems, currentState.statusFilter!);
            }

            emit(AttendanceRekapLoaded(
              allItems: response.list,
              filteredItems: filteredItems,
              searchQuery: currentState.searchQuery,
              statusFilter: currentState.statusFilter,
              count: response.count,
              filtered: response.filtered,
            ));
          } else {
            emit(AttendanceRekapLoaded(
              allItems: response.list,
              filteredItems: response.list,
              count: response.count,
              filtered: response.filtered,
            ));
          }
        } else {
          emit(AttendanceRekapLoaded(
            allItems: const [],
            filteredItems: const [],
            count: response.count,
            filtered: response.filtered,
          ));
        }
      },
    );
  }

  void _onSearchAttendanceRekap(
    SearchAttendanceRekapEvent event,
    Emitter<AttendanceRekapState> emit,
  ) {
    final currentState = state;
    
    // Store search query for later use if data is not loaded yet
    if (event.query.trim().isEmpty) {
      _pendingSearchQuery = null;
    } else {
      _pendingSearchQuery = event.query;
    }

    // If data is not loaded yet, just store the query
    if (currentState is! AttendanceRekapLoaded) {
      return;
    }

    if (event.query.trim().isEmpty) {
      // Clear search, show all items (with status filter if any)
      var filteredItems = currentState.allItems;
      if (currentState.statusFilter != null &&
          currentState.statusFilter!.isNotEmpty) {
        filteredItems =
            _performFilter(filteredItems, currentState.statusFilter!);
      }

      emit(currentState.copyWith(
        filteredItems: filteredItems,
        searchQuery: null,
      ));
      return;
    }

    // Perform search on all items
    var filteredItems = _performSearch(currentState.allItems, event.query);

    // Apply status filter if any
    if (currentState.statusFilter != null &&
        currentState.statusFilter!.isNotEmpty) {
      filteredItems = _performFilter(filteredItems, currentState.statusFilter!);
    }

    emit(currentState.copyWith(
      filteredItems: filteredItems,
      searchQuery: event.query,
    ));
  }

  void _onFilterAttendanceRekap(
    FilterAttendanceRekapEvent event,
    Emitter<AttendanceRekapState> emit,
  ) {
    final currentState = state;
    
    // Store status filter for later use if data is not loaded yet
    if (event.status.trim().isEmpty) {
      _pendingStatusFilter = null;
    } else {
      _pendingStatusFilter = event.status;
    }

    // If data is not loaded yet, just store the filter
    if (currentState is! AttendanceRekapLoaded) {
      return;
    }

    if (event.status.trim().isEmpty) {
      // Clear filter, show all items (with search if any)
      var filteredItems = currentState.allItems;
      if (currentState.searchQuery != null &&
          currentState.searchQuery!.isNotEmpty) {
        filteredItems =
            _performSearch(filteredItems, currentState.searchQuery!);
      }

      emit(currentState.copyWith(
        filteredItems: filteredItems,
        statusFilter: null,
      ));
      return;
    }

    // Start with current filtered items if in search mode
    List<AttendanceRekapEntity> baseItems = currentState.searchQuery != null &&
            currentState.searchQuery!.isNotEmpty
        ? _performSearch(currentState.allItems, currentState.searchQuery!)
        : currentState.allItems;

    // Apply status filter
    final filteredItems = _performFilter(baseItems, event.status);

    emit(currentState.copyWith(
      filteredItems: filteredItems,
      statusFilter: event.status,
    ));
  }

  void _onClearSearch(
    ClearSearchAttendanceRekapEvent event,
    Emitter<AttendanceRekapState> emit,
  ) {
    final currentState = state;
    if (currentState is! AttendanceRekapLoaded) return;

    var filteredItems = currentState.allItems;
    if (currentState.statusFilter != null &&
        currentState.statusFilter!.isNotEmpty) {
      filteredItems =
          _performFilter(filteredItems, currentState.statusFilter!);
    }

    emit(currentState.copyWith(
      filteredItems: filteredItems,
      searchQuery: null,
    ));
  }

  List<AttendanceRekapEntity> _performSearch(
      List<AttendanceRekapEntity> items, String query) {
    final lowerQuery = query.toLowerCase();
    return items.where((item) {
      return item.shiftName.toLowerCase().contains(lowerQuery) ||
          item.statusAttendance.toLowerCase().contains(lowerQuery) ||
          item.patrol.toLowerCase().contains(lowerQuery) ||
          item.statusCarryOver.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  List<AttendanceRekapEntity> _performFilter(
      List<AttendanceRekapEntity> items, String status) {
    return items.where((item) {
      return item.statusAttendance.toLowerCase() == status.toLowerCase() ||
          item.statusBadgeText.toLowerCase() == status.toLowerCase();
    }).toList();
  }
}

