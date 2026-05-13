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
import '../../domain/usecases/get_assessment_list_usecase.dart';
import '../../domain/usecases/get_assessment_detail_usecase.dart';
import '../../domain/entities/assessment_entity.dart';

part 'test_result_event.dart';
part 'test_result_state.dart';

@injectable
class TestResultBloc extends Bloc<TestResultEvent, TestResultState> {
  final GetMyTestResultsUseCase getMyResultsUseCase;
  final GetMemberTestResultsUseCase getMemberResultsUseCase;
  final GetTestSummaryUseCase getSummaryUseCase;
  final GetMemberTestsByPicUseCase getMemberTestsByPicUseCase;
  final GetAssessmentListUseCase getAssessmentListUseCase;
  final GetAssessmentDetailUseCase getAssessmentDetailUseCase;

  TestResultBloc({
    required this.getMyResultsUseCase,
    required this.getMemberResultsUseCase,
    required this.getSummaryUseCase,
    required this.getMemberTestsByPicUseCase,
    required this.getAssessmentListUseCase,
    required this.getAssessmentDetailUseCase,
  }) : super(const TestResultInitial()) {
    on<FetchTestResultEvent>(_onFetchTestResult);
    on<SearchTestEvent>(_onSearchTest);
    on<FilterTestByJabatanEvent>(_onFilterByJabatan);
    on<RefreshTestResultEvent>(_onRefreshTestResult);
    on<SwitchTestTabEvent>(_onSwitchTab);
    on<SearchMyTestEvent>(_onSearchMyTest);
    on<FilterMyTestEvent>(_onFilterMyTest);
    on<FetchMemberTestsEvent>(_onFetchMemberTests);
    on<FetchAssessmentListEvent>(_onFetchAssessmentList);
    on<FetchAssessmentDetailEvent>(_onFetchAssessmentDetail);
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

      // Get summary untuk semua role
      final summaryResult = await getSummaryUseCase(userId: event.userId);
      
      TestSummaryEntity? summary;
      summaryResult.fold(
        (failure) => summary = null,
        (data) => summary = data,
      );

      // Untuk role yang bisa lihat member results
      // Pengawas uses assessment list instead of member results
      if (_canViewMemberResults(event.role) && event.role != UserRole.pengawas) {
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
          userId: event.userId,
        ));
      } else if (event.role == UserRole.pengawas) {
        // Untuk Pengawas, fetch assessment list directly (Assesment/list)
        print('🔵 Pengawas: Fetching assessment list directly...');
        final assessmentListResult = await getAssessmentListUseCase(event.userId);

        List<AssessmentEntity> assessmentList = [];
        assessmentListResult.fold(
          (failure) {
            print('❌ Pengawas: Failed to fetch assessment list: ${failure.message}');
            assessmentList = [];
          },
          (data) {
            print('✅ Pengawas: Fetched ${data.length} assessments');
            assessmentList = data;
          },
        );

        emit(TestResultLoaded(
          myResults: const [],
          filteredMyResults: const [],
          memberResults: const [],
          filteredMemberResults: const [],
          assessmentList: assessmentList,
          filteredAssessmentList: assessmentList,
          summary: summary,
          userRole: event.role,
          userId: event.userId,
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
          userId: event.userId,
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
      print('🔄 Current assessmentList count: ${currentState.assessmentList.length}');
      print('🔄 Is loading assessment list: ${currentState.isLoadingAssessmentList}');

      emit(currentState.copyWith(currentTabIndex: event.tabIndex));

      // Fetch assessment list when switching to "Ujian Anggota" tab (index 1)
      // and data hasn't been loaded yet or userId is available
      if (event.tabIndex == 1) {
        print('🔄 Switched to Ujian Anggota tab');

        if (event.userId == null || event.userId!.isEmpty) {
          print('❌ ERROR: UserId is null/empty, cannot fetch assessment list');
        } else if (currentState.assessmentList.isNotEmpty) {
          print('ℹ️ Assessment list already loaded (${currentState.assessmentList.length} items)');
        } else if (currentState.isLoadingAssessmentList) {
          print('ℹ️ Assessment list is already being loaded');
        } else {
          print('🔵 Fetching assessment list with PIC ID: ${event.userId}');
          add(FetchAssessmentListEvent(event.userId!));
        }
      }
    } else {
      print('❌ ERROR: State is not TestResultLoaded, cannot switch tab');
    }
    print('🔄 ========================================');
    print('');
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
            print('✅ First item details:');
            if (memberTests.isNotEmpty) {
              final first = memberTests.first;
              print('   - ID: ${first.id}');
              print('   - Name: ${first.namaTest}');
              print('   - Grade: ${first.nilaiTest}');
              print('   - Status: ${first.status.displayName}');
              print('   - User ID: ${first.userId}');
            }
            
            emit(currentState.copyWith(
              memberTests: memberTests,
              filteredMemberTests: memberTests,
              isLoadingMemberResults: false,
              memberTestsError: null,
            ));
            
            // print('✅ State updated - memberTests count: ${memberTests.length}');
            // print('✅ State updated - filteredMemberTests count: ${memberTests.length}');
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

  Future<void> _onFetchAssessmentList(
    FetchAssessmentListEvent event,
    Emitter<TestResultState> emit,
  ) async {
    if (state is TestResultLoaded) {
      final currentState = state as TestResultLoaded;
      
      emit(currentState.copyWith(isLoadingAssessmentList: true));
      
      try {
        print('');
        print('🔵 ========================================');
        print('🔵 FETCH ASSESSMENT LIST (Ujian Anggota Tab)');
        print('🔵 ========================================');
        print('🔵 PIC ID: "${event.picId}"');
        print('🔵 ========================================');

        final assessmentListResult = await getAssessmentListUseCase(event.picId);

        assessmentListResult.fold(
          (failure) {
            print('❌ Failed to fetch assessment list: ${failure.message}');
            emit(currentState.copyWith(
              isLoadingAssessmentList: false,
              assessmentListError: failure.message,
            ));
          },
          (assessmentList) {
            print('✅ Successfully fetched ${assessmentList.length} assessments');
            
            emit(currentState.copyWith(
              assessmentList: assessmentList,
              filteredAssessmentList: assessmentList,
              isLoadingAssessmentList: false,
              assessmentListError: null,
            ));
          },
        );
      } catch (e) {
        print('❌ Exception: $e');
        emit(currentState.copyWith(
          isLoadingAssessmentList: false,
          assessmentListError: 'Terjadi kesalahan: ${e.toString()}',
        ));
      }
    }
  }

  Future<void> _onFetchAssessmentDetail(
    FetchAssessmentDetailEvent event,
    Emitter<TestResultState> emit,
  ) async {
    final currentState = state;
    if (currentState is! TestResultLoaded) {
      emit(const TestResultLoading());
    } else {
      emit(currentState.copyWith(isLoadingAssessmentDetail: true));
    }

    try {
      final result = await getAssessmentDetailUseCase(event.assessmentId, event.idSpv);

      result.fold(
        (failure) {
          print('❌ Failed to fetch assessment detail: $failure');
          if (currentState is TestResultLoaded) {
            emit(currentState.copyWith(
              isLoadingAssessmentDetail: false,
              assessmentDetailError: failure.message,
            ));
          } else {
            emit(TestResultError(failure.message));
          }
        },
        (assessmentDetailList) {
          print('✅ Successfully fetched ${assessmentDetailList.length} assessment details');
          if (currentState is TestResultLoaded) {
            emit(currentState.copyWith(
              assessmentDetailList: assessmentDetailList,
              isLoadingAssessmentDetail: false,
              assessmentDetailError: null,
            ));
          } else {
            emit(TestResultLoaded(
              myResults: [],
              filteredMyResults: [],
              memberResults: [],
              filteredMemberResults: [],
              userRole: UserRole.pjo,
              assessmentDetailList: assessmentDetailList,
              isLoadingAssessmentDetail: false,
            ));
          }
        },
      );
    } catch (e) {
      print('❌ Exception in _onFetchAssessmentDetail: $e');
      if (currentState is TestResultLoaded) {
        emit(currentState.copyWith(
          isLoadingAssessmentDetail: false,
          assessmentDetailError: 'Terjadi kesalahan: ${e.toString()}',
        ));
      } else {
        emit(TestResultError('Terjadi kesalahan: ${e.toString()}'));
      }
    }
  }

  /// Helper untuk check apakah role bisa lihat member results
  bool _canViewMemberResults(UserRole role) {
    return role == UserRole.pjo ||
        role == UserRole.deputy ||
        role == UserRole.pengawas ||
        role == UserRole.danton;
  }
}

