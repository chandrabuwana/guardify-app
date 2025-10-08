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
  final List<TestMemberResultEntity> memberResults;
  final List<TestMemberResultEntity> filteredMemberResults;
  final TestSummaryEntity? summary;
  final UserRole userRole;
  final int currentTabIndex;
  final String? searchQuery;
  final String? selectedJabatan;

  const TestResultLoaded({
    required this.myResults,
    required this.memberResults,
    required this.filteredMemberResults,
    this.summary,
    required this.userRole,
    this.currentTabIndex = 0,
    this.searchQuery,
    this.selectedJabatan,
  });

  TestResultLoaded copyWith({
    List<TestResultEntity>? myResults,
    List<TestMemberResultEntity>? memberResults,
    List<TestMemberResultEntity>? filteredMemberResults,
    TestSummaryEntity? summary,
    UserRole? userRole,
    int? currentTabIndex,
    String? searchQuery,
    String? selectedJabatan,
  }) {
    return TestResultLoaded(
      myResults: myResults ?? this.myResults,
      memberResults: memberResults ?? this.memberResults,
      filteredMemberResults: filteredMemberResults ?? this.filteredMemberResults,
      summary: summary ?? this.summary,
      userRole: userRole ?? this.userRole,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedJabatan: selectedJabatan ?? this.selectedJabatan,
    );
  }

  @override
  List<Object?> get props => [
        myResults,
        memberResults,
        filteredMemberResults,
        summary,
        userRole,
        currentTabIndex,
        searchQuery,
        selectedJabatan,
      ];
}

/// Error state
class TestResultError extends TestResultState {
  final String message;

  const TestResultError(this.message);

  @override
  List<Object?> get props => [message];
}

