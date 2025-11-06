import '../../domain/entities/personnel.dart';

abstract class PersonnelState {
  const PersonnelState();
}

/// Initial state
class PersonnelInitial extends PersonnelState {}

/// Loading state
class PersonnelLoading extends PersonnelState {}

/// Loaded personnel list
class PersonnelListLoaded extends PersonnelState {
  final List<Personnel> personnelList;
  final String currentStatus;
  final bool isSearching;
  final String searchQuery;
  final bool hasReachedMax;
  final int currentPage;
  final bool isLoadingMore;

  const PersonnelListLoaded({
    required this.personnelList,
    required this.currentStatus,
    this.isSearching = false,
    this.searchQuery = '',
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.isLoadingMore = false,
  });

  PersonnelListLoaded copyWith({
    List<Personnel>? personnelList,
    String? currentStatus,
    bool? isSearching,
    String? searchQuery,
    bool? hasReachedMax,
    int? currentPage,
    bool? isLoadingMore,
  }) {
    return PersonnelListLoaded(
      personnelList: personnelList ?? this.personnelList,
      currentStatus: currentStatus ?? this.currentStatus,
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
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
