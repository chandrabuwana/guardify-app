part of 'bmi_bloc.dart';

class BMIState {
  final bool isLoading;
  final bool isSearching;
  final bool isCalculating;
  final bool isLoadingMore;
  final String? error;
  final UserProfile? currentUserProfile;
  final List<UserProfile> searchResults;
  final List<UserProfile> pinnedUsers;
  final List<BMIRecord> bmiHistory;
  final BMIRecord? latestBMIRecord;
  final Map<String, dynamic>? statistics;
  final int currentPage;
  final bool hasMoreData;

  const BMIState({
    this.isLoading = false,
    this.isSearching = false,
    this.isCalculating = false,
    this.isLoadingMore = false,
    this.error,
    this.currentUserProfile,
    this.searchResults = const [],
    this.pinnedUsers = const [],
    this.bmiHistory = const [],
    this.latestBMIRecord,
    this.statistics,
    this.currentPage = 1,
    this.hasMoreData = true,
  });

  BMIState copyWith({
    bool? isLoading,
    bool? isSearching,
    bool? isCalculating,
    bool? isLoadingMore,
    String? error,
    UserProfile? currentUserProfile,
    List<UserProfile>? searchResults,
    List<UserProfile>? pinnedUsers,
    List<BMIRecord>? bmiHistory,
    BMIRecord? latestBMIRecord,
    Map<String, dynamic>? statistics,
    int? currentPage,
    bool? hasMoreData,
  }) {
    return BMIState(
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      isCalculating: isCalculating ?? this.isCalculating,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      currentUserProfile: currentUserProfile ?? this.currentUserProfile,
      searchResults: searchResults ?? this.searchResults,
      pinnedUsers: pinnedUsers ?? this.pinnedUsers,
      bmiHistory: bmiHistory ?? this.bmiHistory,
      latestBMIRecord: latestBMIRecord ?? this.latestBMIRecord,
      statistics: statistics ?? this.statistics,
      currentPage: currentPage ?? this.currentPage,
      hasMoreData: hasMoreData ?? this.hasMoreData,
    );
  }

  // Factory constructors for common states
  factory BMIState.initial() => const BMIState();

  factory BMIState.loading() => const BMIState(isLoading: true);

  factory BMIState.searching() => const BMIState(isSearching: true);

  factory BMIState.calculating() => const BMIState(isCalculating: true);

  factory BMIState.error(String message) => BMIState(error: message);

  // Helper getters
  bool get hasError => error != null;
  bool get hasUserProfile => currentUserProfile != null;
  bool get hasSearchResults => searchResults.isNotEmpty;
  bool get hasPinnedUsers => pinnedUsers.isNotEmpty;
  bool get hasBMIHistory => bmiHistory.isNotEmpty;
  bool get hasLatestBMI => latestBMIRecord != null;

  // Get combined list with pinned users at top
  List<UserProfile> get combinedUserList {
    final List<UserProfile> combined = [];

    // Add pinned users first
    combined.addAll(pinnedUsers);

    // Add search results that are not pinned
    final nonPinnedResults = searchResults.where((user) {
      return !pinnedUsers.any((pinned) => pinned.id == user.id);
    }).toList();

    combined.addAll(nonPinnedResults);

    return combined;
  }

  @override
  String toString() {
    return 'BMIState(isLoading: $isLoading, isSearching: $isSearching, isCalculating: $isCalculating, error: $error, hasUserProfile: $hasUserProfile, searchResults: ${searchResults.length}, pinnedUsers: ${pinnedUsers.length}, bmiHistory: ${bmiHistory.length})';
  }
}
