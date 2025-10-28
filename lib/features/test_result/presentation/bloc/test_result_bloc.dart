import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/enums.dart';
import '../../domain/entities/test_result_entity.dart';
import '../../domain/entities/test_summary_entity.dart';
import '../../domain/entities/test_member_result_entity.dart';
import '../../domain/usecases/get_my_test_results_usecase.dart';
import '../../domain/usecases/get_member_test_results_usecase.dart';
import '../../domain/usecases/get_test_summary_usecase.dart';
import '../../domain/usecases/get_member_tests_by_pic_usecase.dart';

part 'test_result_event.dart';
part 'test_result_state.dart';

@injectable
class TestResultBloc extends Bloc<TestResultEvent, TestResultState> {
  final GetMyTestResultsUseCase getMyResultsUseCase;
  final GetMemberTestResultsUseCase getMemberResultsUseCase;
  final GetTestSummaryUseCase getSummaryUseCase;
  final GetMemberTestsByPicUseCase getMemberTestsByPicUseCase;

  TestResultBloc({
    required this.getMyResultsUseCase,
    required this.getMemberResultsUseCase,
    required this.getSummaryUseCase,
    required this.getMemberTestsByPicUseCase,
  }) : super(const TestResultInitial()) {
    on<FetchTestResultEvent>(_onFetchTestResult);
    on<SearchTestEvent>(_onSearchTest);
    on<FilterTestByJabatanEvent>(_onFilterByJabatan);
    on<RefreshTestResultEvent>(_onRefreshTestResult);
    on<SwitchTestTabEvent>(_onSwitchTab);
    on<SearchMyTestEvent>(_onSearchMyTest);
    on<FilterMyTestEvent>(_onFilterMyTest);
    on<FetchMemberTestsEvent>(_onFetchMemberTests);
  }

  Future<void> _onFetchTestResult(
    FetchTestResultEvent event,
    Emitter<TestResultState> emit,
  ) async {
    emit(const TestResultLoading());

    try {
      // Validasi userId tidak boleh kosong
      if (event.userId.isEmpty) {
        print('❌ TestResultBloc: userId is empty, cannot fetch results');
        emit(const TestResultError('User ID tidak ditemukan. Silakan login kembali.'));
        return;
      }

      print('');
      print('🔵 ========================================');
      print('🔵 TEST RESULT BLOC: FETCH EVENT');
      print('🔵 ========================================');
      print('🔵 Event userId: "${event.userId}"');
      print('🔵 Event userId length: ${event.userId.length}');
      print('🔵 User role: ${event.role.displayName}');
      print('🔵 ========================================');
      print('');

      // Get summary untuk semua role
      final summaryResult = await getSummaryUseCase(userId: event.userId);
      
      TestSummaryEntity? summary;
      summaryResult.fold(
        (failure) => summary = null,
        (data) => summary = data,
      );

      // Untuk role yang bisa lihat member results
      if (_canViewMemberResults(event.role)) {
        final memberResultsResult = await getMemberResultsUseCase();
        final myResultsResult = await getMyResultsUseCase(event.userId);

        List<TestMemberResultEntity> memberResults = [];
        List<TestResultEntity> myResults = [];

        memberResultsResult.fold(
          (failure) => memberResults = [],
          (data) => memberResults = data,
        );

        myResultsResult.fold(
          (failure) => myResults = [],
          (data) => myResults = data,
        );

        emit(TestResultLoaded(
          myResults: myResults,
          filteredMyResults: myResults,
          memberResults: memberResults,
          filteredMemberResults: memberResults,
          summary: summary,
          userRole: event.role,
        ));
      } else {
        // Untuk Anggota, hanya show my results
        final myResultsResult = await getMyResultsUseCase(event.userId);

        List<TestResultEntity> myResults = [];

        myResultsResult.fold(
          (failure) => emit(TestResultError(failure.message)),
          (data) => myResults = data,
        );

        emit(TestResultLoaded(
          myResults: myResults,
          filteredMyResults: myResults,
          memberResults: const [],
          filteredMemberResults: const [],
          summary: summary,
          userRole: event.role,
        ));
      }
    } catch (e) {
      emit(TestResultError('Failed to load exam results: $e'));
    }
  }

  void _onSearchTest(
    SearchTestEvent event,
    Emitter<TestResultState> emit,
  ) {
    if (state is TestResultLoaded) {
      final currentState = state as TestResultLoaded;
      final query = event.query.toLowerCase();

      if (query.isEmpty) {
        emit(currentState.copyWith(
          filteredMemberResults: currentState.memberResults,
          searchQuery: null,
        ));
        return;
      }

      final filtered = currentState.memberResults.where((result) {
        return result.nama.toLowerCase().contains(query) ||
            result.jabatan.toLowerCase().contains(query);
      }).toList();

      emit(currentState.copyWith(
        filteredMemberResults: filtered,
        searchQuery: query,
      ));
    }
  }

  void _onFilterByJabatan(
    FilterTestByJabatanEvent event,
    Emitter<TestResultState> emit,
  ) {
    if (state is TestResultLoaded) {
      final currentState = state as TestResultLoaded;

      if (event.jabatan == null || event.jabatan!.isEmpty) {
        emit(currentState.copyWith(
          filteredMemberResults: currentState.memberResults,
          selectedJabatan: null,
        ));
        return;
      }

      final filtered = currentState.memberResults
          .where((result) => result.jabatan == event.jabatan)
          .toList();

      emit(currentState.copyWith(
        filteredMemberResults: filtered,
        selectedJabatan: event.jabatan,
      ));
    }
  }

  Future<void> _onRefreshTestResult(
    RefreshTestResultEvent event,
    Emitter<TestResultState> emit,
  ) async {
    // Call fetch with same parameters
    add(FetchTestResultEvent(
      userId: event.userId,
      role: event.role,
    ));
  }

  void _onSwitchTab(
    SwitchTestTabEvent event,
    Emitter<TestResultState> emit,
  ) {
    if (state is TestResultLoaded) {
      final currentState = state as TestResultLoaded;
      emit(currentState.copyWith(currentTabIndex: event.tabIndex));
    }
  }

  void _onSearchMyTest(
    SearchMyTestEvent event,
    Emitter<TestResultState> emit,
  ) {
    if (state is TestResultLoaded) {
      final currentState = state as TestResultLoaded;
      final query = event.query.toLowerCase();

      if (query.isEmpty) {
        // Reset to all results, apply current filter if exists
        var filtered = currentState.myResults;
        if (currentState.selectedMyTestFilter != null) {
          filtered = _filterMyResultsByStatus(filtered, currentState.selectedMyTestFilter!);
        }
        
        emit(currentState.copyWith(
          filteredMyResults: filtered,
          searchQuery: null,
        ));
        return;
      }

      // Search in results, then apply filter if exists
      var filtered = currentState.myResults.where((result) {
        return result.namaTest.toLowerCase().contains(query) ||
            result.id.toLowerCase().contains(query);
      }).toList();

      if (currentState.selectedMyTestFilter != null) {
        filtered = _filterMyResultsByStatus(filtered, currentState.selectedMyTestFilter!);
      }

      emit(currentState.copyWith(
        filteredMyResults: filtered,
        searchQuery: query,
      ));
    }
  }

  void _onFilterMyTest(
    FilterMyTestEvent event,
    Emitter<TestResultState> emit,
  ) {
    if (state is TestResultLoaded) {
      final currentState = state as TestResultLoaded;

      if (event.status == null || event.status!.isEmpty) {
        // Reset filter, apply search if exists
        var filtered = currentState.myResults;
        if (currentState.searchQuery != null && currentState.searchQuery!.isNotEmpty) {
          final query = currentState.searchQuery!.toLowerCase();
          filtered = filtered.where((result) {
            return result.namaTest.toLowerCase().contains(query) ||
                result.id.toLowerCase().contains(query);
          }).toList();
        }
        
        emit(currentState.copyWith(
          filteredMyResults: filtered,
          selectedMyTestFilter: null,
        ));
        return;
      }

      // Apply status filter
      var filtered = _filterMyResultsByStatus(currentState.myResults, event.status!);

      // Apply search if exists
      if (currentState.searchQuery != null && currentState.searchQuery!.isNotEmpty) {
        final query = currentState.searchQuery!.toLowerCase();
        filtered = filtered.where((result) {
          return result.namaTest.toLowerCase().contains(query) ||
              result.id.toLowerCase().contains(query);
        }).toList();
      }

      emit(currentState.copyWith(
        filteredMyResults: filtered,
        selectedMyTestFilter: event.status,
      ));
    }
  }

  Future<void> _onFetchMemberTests(
    FetchMemberTestsEvent event,
    Emitter<TestResultState> emit,
  ) async {
    if (state is TestResultLoaded) {
      final currentState = state as TestResultLoaded;
      
      // Emit loading state for member results only
      emit(currentState.copyWith(isLoadingMemberResults: true));
      
      try {
        print('');
        print('🔵 ========================================');
        print('🔵 FETCH MEMBER TESTS BY PIC');
        print('🔵 ========================================');
        print('🔵 PIC ID: "${event.picId}"');
        print('🔵 ========================================');
        print('');

        final memberTestsResult = await getMemberTestsByPicUseCase(event.picId);

        memberTestsResult.fold(
          (failure) {
            print('❌ Failed to fetch member tests: ${failure.message}');
            emit(currentState.copyWith(
              isLoadingMemberResults: false,
              memberTestsError: failure.message,
            ));
          },
          (memberTests) {
            print('✅ Successfully fetched ${memberTests.length} member tests');
            emit(currentState.copyWith(
              memberTests: memberTests,
              filteredMemberTests: memberTests,
              isLoadingMemberResults: false,
              memberTestsError: null,
            ));
          },
        );
      } catch (e) {
        print('❌ Exception: $e');
        emit(currentState.copyWith(
          isLoadingMemberResults: false,
          memberTestsError: 'Terjadi kesalahan: ${e.toString()}',
        ));
      }
    }
  }

  List<TestResultEntity> _filterMyResultsByStatus(
    List<TestResultEntity> results,
    String status,
  ) {
    return results.where((result) => result.status.value == status).toList();
  }

  /// Helper untuk check apakah role bisa lihat member results
  bool _canViewMemberResults(UserRole role) {
    return role == UserRole.pjo ||
        role == UserRole.deputy ||
        role == UserRole.pengawas ||
        role == UserRole.danton;
  }
}

