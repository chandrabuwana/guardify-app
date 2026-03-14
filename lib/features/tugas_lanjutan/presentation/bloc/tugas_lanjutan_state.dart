part of 'tugas_lanjutan_bloc.dart';

/// Base state class
abstract class TugasLanjutanState extends Equatable {
  const TugasLanjutanState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class TugasLanjutanInitial extends TugasLanjutanState {}

/// Loading state
class TugasLanjutanLoading extends TugasLanjutanState {}

/// List loaded state
class TugasLanjutanListLoaded extends TugasLanjutanState {
  final List<TugasLanjutanEntity> tugasList;
  final List<TugasLanjutanEntity> filteredList;
  final String searchQuery;
  final TugasLanjutanStatus? selectedStatus;

  const TugasLanjutanListLoaded({
    required this.tugasList,
    List<TugasLanjutanEntity>? filteredList,
    this.searchQuery = '',
    this.selectedStatus,
  }) : filteredList = filteredList ?? tugasList;

  TugasLanjutanListLoaded copyWith({
    List<TugasLanjutanEntity>? tugasList,
    List<TugasLanjutanEntity>? filteredList,
    String? searchQuery,
    TugasLanjutanStatus? selectedStatus,
    bool clearSelectedStatus = false,
  }) {
    return TugasLanjutanListLoaded(
      tugasList: tugasList ?? this.tugasList,
      filteredList: filteredList ?? this.filteredList,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedStatus: clearSelectedStatus ? null : (selectedStatus ?? this.selectedStatus),
    );
  }

  @override
  List<Object?> get props => [tugasList, filteredList, searchQuery, selectedStatus];
}

/// Detail loaded state
class TugasLanjutanDetailLoaded extends TugasLanjutanState {
  final TugasLanjutanEntity tugas;

  const TugasLanjutanDetailLoaded({required this.tugas});

  @override
  List<Object?> get props => [tugas];
}

/// Updated state
class TugasLanjutanUpdated extends TugasLanjutanState {
  final TugasLanjutanEntity tugas;

  const TugasLanjutanUpdated({required this.tugas});

  @override
  List<Object?> get props => [tugas];
}

/// Progress summary loaded state
class TugasLanjutanProgressLoaded extends TugasLanjutanState {
  final Map<String, dynamic> summary;
  final List<TugasLanjutanEntity>? tugasList; // Keep list data if available

  const TugasLanjutanProgressLoaded({
    required this.summary,
    this.tugasList,
  });

  @override
  List<Object?> get props => [summary, tugasList];
}

/// Combined state: List and Progress loaded
class TugasLanjutanListAndProgressLoaded extends TugasLanjutanState {
  final List<TugasLanjutanEntity> tugasList;
  final List<TugasLanjutanEntity> filteredList;
  final Map<String, dynamic> summary;
  final String searchQuery;
  final TugasLanjutanStatus? selectedStatus;

  const TugasLanjutanListAndProgressLoaded({
    required this.tugasList,
    List<TugasLanjutanEntity>? filteredList,
    required this.summary,
    this.searchQuery = '',
    this.selectedStatus,
  }) : filteredList = filteredList ?? tugasList;

  TugasLanjutanListAndProgressLoaded copyWith({
    List<TugasLanjutanEntity>? tugasList,
    List<TugasLanjutanEntity>? filteredList,
    Map<String, dynamic>? summary,
    String? searchQuery,
    TugasLanjutanStatus? selectedStatus,
    bool clearSelectedStatus = false,
  }) {
    return TugasLanjutanListAndProgressLoaded(
      tugasList: tugasList ?? this.tugasList,
      filteredList: filteredList ?? this.filteredList,
      summary: summary ?? this.summary,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedStatus: clearSelectedStatus ? null : (selectedStatus ?? this.selectedStatus),
    );
  }

  @override
  List<Object?> get props => [tugasList, filteredList, summary, searchQuery, selectedStatus];
}

/// Error state
class TugasLanjutanError extends TugasLanjutanState {
  final String message;

  const TugasLanjutanError({required this.message});

  @override
  List<Object?> get props => [message];
}

