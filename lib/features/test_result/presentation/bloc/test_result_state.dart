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
  final String? userId;
  final int currentTabIndex;
  final String? searchQuery;
  final String? selectedJabatan;
  final String? selectedMyTestFilter;
  
  // Fields for Danton feature (member tests by PIC)
  final List<TestResultEntity> memberTests;
  final List<TestResultEntity> filteredMemberTests;
  final bool isLoadingMemberResults;
  final String? memberTestsError;

  // Fields for Ujian Anggota tab (assessment list)
  final List<AssessmentEntity> assessmentList;
  final List<AssessmentEntity> filteredAssessmentList;
  final bool isLoadingAssessmentList;
  final String? assessmentListError;

  // Fields for Assessment Detail Page
  final List<TestResultEntity> assessmentDetailList;
  final bool isLoadingAssessmentDetail;
  final String? assessmentDetailError;

  const TestResultLoaded({
    required this.myResults,
    required this.filteredMyResults,
    required this.memberResults,
    required this.filteredMemberResults,
    this.summary,
    required this.userRole,
    this.userId,
    this.currentTabIndex = 0,
    this.searchQuery,
    this.selectedJabatan,
    this.selectedMyTestFilter,
    this.memberTests = const [],
    this.filteredMemberTests = const [],
    this.isLoadingMemberResults = false,
    this.memberTestsError,
    this.assessmentList = const [],
    this.filteredAssessmentList = const [],
    this.isLoadingAssessmentList = false,
    this.assessmentListError,
    this.assessmentDetailList = const [],
    this.isLoadingAssessmentDetail = false,
    this.assessmentDetailError,
  });

  TestResultLoaded copyWith({
    List<TestResultEntity>? myResults,
    List<TestResultEntity>? filteredMyResults,
    List<TestMemberResultEntity>? memberResults,
    List<TestMemberResultEntity>? filteredMemberResults,
    TestSummaryEntity? summary,
    UserRole? userRole,
    String? userId,
    int? currentTabIndex,
    String? searchQuery,
    String? selectedJabatan,
    String? selectedMyTestFilter,
    List<TestResultEntity>? memberTests,
    List<TestResultEntity>? filteredMemberTests,
    bool? isLoadingMemberResults,
    String? memberTestsError,
    List<AssessmentEntity>? assessmentList,
    List<AssessmentEntity>? filteredAssessmentList,
    bool? isLoadingAssessmentList,
    String? assessmentListError,
    List<TestResultEntity>? assessmentDetailList,
    bool? isLoadingAssessmentDetail,
    String? assessmentDetailError,
  }) {
    return TestResultLoaded(
      myResults: myResults ?? this.myResults,
      filteredMyResults: filteredMyResults ?? this.filteredMyResults,
      memberResults: memberResults ?? this.memberResults,
      filteredMemberResults: filteredMemberResults ?? this.filteredMemberResults,
      summary: summary ?? this.summary,
      userRole: userRole ?? this.userRole,
      userId: userId ?? this.userId,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedJabatan: selectedJabatan ?? this.selectedJabatan,
      selectedMyTestFilter: selectedMyTestFilter ?? this.selectedMyTestFilter,
      memberTests: memberTests ?? this.memberTests,
      filteredMemberTests: filteredMemberTests ?? this.filteredMemberTests,
      isLoadingMemberResults: isLoadingMemberResults ?? this.isLoadingMemberResults,
      memberTestsError: memberTestsError,
      assessmentList: assessmentList ?? this.assessmentList,
      filteredAssessmentList: filteredAssessmentList ?? this.filteredAssessmentList,
      isLoadingAssessmentList: isLoadingAssessmentList ?? this.isLoadingAssessmentList,
      assessmentListError: assessmentListError,
      assessmentDetailList: assessmentDetailList ?? this.assessmentDetailList,
      isLoadingAssessmentDetail: isLoadingAssessmentDetail ?? this.isLoadingAssessmentDetail,
      assessmentDetailError: assessmentDetailError,
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
        userId,
        currentTabIndex,
        searchQuery,
        selectedJabatan,
        selectedMyTestFilter,
        memberTests,
        filteredMemberTests,
        isLoadingMemberResults,
        memberTestsError,
        assessmentList,
        filteredAssessmentList,
        isLoadingAssessmentList,
        assessmentListError,
        assessmentDetailList,
        isLoadingAssessmentDetail,
        assessmentDetailError,
      ];
}

/// Error state
class TestResultError extends TestResultState {
  final String message;

  const TestResultError(this.message);

  @override
  List<Object?> get props => [message];
}

