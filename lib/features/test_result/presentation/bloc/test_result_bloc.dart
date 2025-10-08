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

part 'test_result_event.dart';
part 'test_result_state.dart';

@injectable
class TestResultBloc extends Bloc<TestResultEvent, TestResultState> {
  final GetMyTestResultsUseCase getMyResultsUseCase;
  final GetMemberTestResultsUseCase getMemberResultsUseCase;
  final GetTestSummaryUseCase getSummaryUseCase;

  TestResultBloc({
    required this.getMyResultsUseCase,
    required this.getMemberResultsUseCase,
    required this.getSummaryUseCase,
  }) : super(const TestResultInitial()) {
    on<FetchTestResultEvent>(_onFetchTestResult);
    on<SearchTestEvent>(_onSearchTest);
    on<FilterTestByJabatanEvent>(_onFilterByJabatan);
    on<RefreshTestResultEvent>(_onRefreshTestResult);
    on<SwitchTestTabEvent>(_onSwitchTab);
  }

  Future<void> _onFetchTestResult(
    FetchTestResultEvent event,
    Emitter<TestResultState> emit,
  ) async {
    emit(const TestResultLoading());

    try {
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

  /// Helper untuk check apakah role bisa lihat member results
  bool _canViewMemberResults(UserRole role) {
    return role == UserRole.pjo ||
        role == UserRole.deputy ||
        role == UserRole.pengawas ||
        role == UserRole.danton;
  }
}

