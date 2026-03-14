import '../../domain/entities/personnel.dart';

abstract class PersonnelState {
  const PersonnelState();
}

/// Data per tab (cache per status)
class TabPersonnelData {
  final List<Personnel> personnelList;
  final int currentPage;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const TabPersonnelData({
    required this.personnelList,
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  TabPersonnelData copyWith({
    List<Personnel>? personnelList,
    int? currentPage,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) =>
      TabPersonnelData(
        personnelList: personnelList ?? this.personnelList,
        currentPage: currentPage ?? this.currentPage,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );
}

/// Initial state
class PersonnelInitial extends PersonnelState {}

/// Loading state (initial page load)
class PersonnelLoading extends PersonnelState {}

/// Loaded personnel list - cache per tab, API hanya di scroll / first load tab
class PersonnelListLoaded extends PersonnelState {
  /// Cache per status: 'Active', 'Pending', 'Non Active'
  final Map<String, TabPersonnelData> tabData;
  /// Tab yang sedang loading initial (null = tidak ada)
  final String? isLoadingForTab;
  final bool isSearching;
  final String searchQuery;
  /// Hasil filter search per tab (jangan timpa cache)
  final Map<String, List<Personnel>> searchFilteredMap;

  const PersonnelListLoaded({
    required this.tabData,
    this.isLoadingForTab,
    this.isSearching = false,
    this.searchQuery = '',
    this.searchFilteredMap = const {},
  });

  TabPersonnelData? getTabData(String status) => tabData[status];

  /// List yang ditampilkan: hasil search atau cache
  List<Personnel> getDisplayList(String status) {
    if (isSearching && searchQuery.isNotEmpty && searchFilteredMap.containsKey(status)) {
      return searchFilteredMap[status]!;
    }
    return tabData[status]?.personnelList ?? [];
  }

  PersonnelListLoaded copyWith({
    Map<String, TabPersonnelData>? tabData,
    String? isLoadingForTab,
    bool clearLoadingForTab = false,
    bool? isSearching,
    String? searchQuery,
    Map<String, List<Personnel>>? searchFilteredMap,
  }) =>
      PersonnelListLoaded(
        tabData: tabData ?? this.tabData,
        isLoadingForTab: clearLoadingForTab ? null : (isLoadingForTab ?? this.isLoadingForTab),
        isSearching: isSearching ?? this.isSearching,
        searchQuery: searchQuery ?? this.searchQuery,
        searchFilteredMap: searchFilteredMap ?? this.searchFilteredMap,
      );
}

/// Personnel detail loaded
class PersonnelDetailLoaded extends PersonnelState {
  final Personnel personnel;

  const PersonnelDetailLoaded(this.personnel);
}

/// Approval/Revision success
class PersonnelActionSuccess extends PersonnelState {
  final String message;

  const PersonnelActionSuccess(this.message);
}

/// Error state
class PersonnelError extends PersonnelState {
  final String message;

  const PersonnelError(this.message);
}
