import 'package:equatable/equatable.dart';
import '../../domain/entities/incident_entity.dart';
import '../../domain/entities/incident_location_entity.dart';
import '../../domain/entities/incident_type_entity.dart';

class IncidentState extends Equatable {
  final bool isLoading;
  final bool isLoadingMore;
  final List<IncidentEntity> incidentList;
  final List<IncidentEntity> myTasks;
  final IncidentEntity? incidentDetail;
  final List<IncidentLocationEntity> locations;
  final List<IncidentTypeEntity> types;
  final String? errorMessage;
  final String? searchQuery;
  final int currentPage;
  final bool hasReachedMax;
  final bool hasReachedMaxMyTasks;
  final int currentPageMyTasks;

  const IncidentState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.incidentList = const [],
    this.myTasks = const [],
    this.incidentDetail,
    this.locations = const [],
    this.types = const [],
    this.errorMessage,
    this.searchQuery,
    this.currentPage = 0,
    this.hasReachedMax = false,
    this.hasReachedMaxMyTasks = false,
    this.currentPageMyTasks = 0,
  });

  IncidentState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<IncidentEntity>? incidentList,
    bool clearIncidentList = false,
    List<IncidentEntity>? myTasks,
    bool clearMyTasks = false,
    IncidentEntity? incidentDetail,
    List<IncidentLocationEntity>? locations,
    List<IncidentTypeEntity>? types,
    String? errorMessage,
    bool clearError = false,
    String? searchQuery,
    int? currentPage,
    bool? hasReachedMax,
    bool? hasReachedMaxMyTasks,
    int? currentPageMyTasks,
  }) {
    return IncidentState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      incidentList: clearIncidentList 
          ? const [] 
          : (incidentList ?? this.incidentList),
      myTasks: clearMyTasks 
          ? const [] 
          : (myTasks ?? this.myTasks),
      incidentDetail: incidentDetail ?? this.incidentDetail,
      locations: locations ?? this.locations,
      types: types ?? this.types,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      hasReachedMaxMyTasks: hasReachedMaxMyTasks ?? this.hasReachedMaxMyTasks,
      currentPageMyTasks: currentPageMyTasks ?? this.currentPageMyTasks,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isLoadingMore,
        incidentList,
        myTasks,
        incidentDetail,
        locations,
        types,
        errorMessage,
        searchQuery,
        currentPage,
        hasReachedMax,
        hasReachedMaxMyTasks,
        currentPageMyTasks,
      ];
}

