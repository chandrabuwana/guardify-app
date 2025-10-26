part of 'test_result_bloc.dart';

/// Base state class for Test Result
abstract class TestResultState extends Equatable {
  const TestResultState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class TestResultInitial extends TestResultState {
  const TestResultInitial();
}

/// Loading state
class TestResultLoading extends TestResultState {
  const TestResultLoading();
}

/// Loaded state dengan semua data
class TestResultLoaded extends TestResultState {
  final List<TestResultEntity> myResults;
  final List<TestResultEntity> filteredMyResults;
  final List<TestMemberResultEntity> memberResults;
  final List<TestMemberResultEntity> filteredMemberResults;
  final TestSummaryEntity? summary;
  final UserRole userRole;
  final int currentTabIndex;
  final String? searchQuery;
  final String? selectedJabatan;
  final String? selectedMyTestFilter;

  const TestResultLoaded({
    required this.myResults,
    required this.filteredMyResults,
    required this.memberResults,
    required this.filteredMemberResults,
    this.summary,
    required this.userRole,
    this.currentTabIndex = 0,
    this.searchQuery,
    this.selectedJabatan,
    this.selectedMyTestFilter,
  });

  TestResultLoaded copyWith({
    List<TestResultEntity>? myResults,
    List<TestResultEntity>? filteredMyResults,
    List<TestMemberResultEntity>? memberResults,
    List<TestMemberResultEntity>? filteredMemberResults,
    TestSummaryEntity? summary,
    UserRole? userRole,
    int? currentTabIndex,
    String? searchQuery,
    String? selectedJabatan,
    String? selectedMyTestFilter,
  }) {
    return TestResultLoaded(
      myResults: myResults ?? this.myResults,
      filteredMyResults: filteredMyResults ?? this.filteredMyResults,
      memberResults: memberResults ?? this.memberResults,
      filteredMemberResults: filteredMemberResults ?? this.filteredMemberResults,
      summary: summary ?? this.summary,
      userRole: userRole ?? this.userRole,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedJabatan: selectedJabatan ?? this.selectedJabatan,
      selectedMyTestFilter: selectedMyTestFilter ?? this.selectedMyTestFilter,
    );
  }

  @override
  List<Object?> get props => [
        myResults,
        filteredMyResults,
        memberResults,
        filteredMemberResults,
        summary,
        userRole,
        currentTabIndex,
        searchQuery,
        selectedJabatan,
        selectedMyTestFilter,
      ];
}

/// Error state
class TestResultError extends TestResultState {
  final String message;

  const TestResultError(this.message);

  @override
  List<Object?> get props => [message];
}

