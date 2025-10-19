part of 'patrol_bloc.dart';

abstract class PatrolState {
  const PatrolState();
}

class PatrolInitial extends PatrolState {}

class PatrolLoading extends PatrolState {}

class PatrolLoaded extends PatrolState {
  final List<PatrolRoute> routes;
  final PatrolProgress? progress;
  final PatrolRoute? selectedRoute;
  final int currentPage;
  final bool hasMore;
  final int totalCount;
  final bool isLoadingMore;

  const PatrolLoaded({
    required this.routes,
    this.progress,
    this.selectedRoute,
    this.currentPage = 1,
    this.hasMore = false,
    this.totalCount = 0,
    this.isLoadingMore = false,
  });

  PatrolLoaded copyWith({
    List<PatrolRoute>? routes,
    PatrolProgress? progress,
    PatrolRoute? selectedRoute,
    int? currentPage,
    bool? hasMore,
    int? totalCount,
    bool? isLoadingMore,
  }) {
    return PatrolLoaded(
      routes: routes ?? this.routes,
      progress: progress ?? this.progress,
      selectedRoute: selectedRoute ?? this.selectedRoute,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      totalCount: totalCount ?? this.totalCount,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class PatrolError extends PatrolState {
  final String message;

  const PatrolError(this.message);
}
