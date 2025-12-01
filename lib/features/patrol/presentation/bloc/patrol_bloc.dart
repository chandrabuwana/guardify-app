import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/patrol_route.dart';
import '../../domain/entities/patrol_progress.dart';
import '../../domain/entities/patrol_location.dart';
import '../../domain/usecases/get_patrol_routes.dart';
import '../../domain/usecases/get_patrol_routes_paginated.dart';
import '../../domain/usecases/get_patrol_progress.dart';
import '../../domain/usecases/add_patrol_location.dart';
import '../../domain/repositories/patrol_repository.dart';

part 'patrol_event.dart';
part 'patrol_state.dart';

@injectable
class PatrolBloc extends Bloc<PatrolEvent, PatrolState> {
  final GetPatrolRoutes getPatrolRoutes;
  final GetPatrolRoutesPaginated getPatrolRoutesPaginated;
  final GetPatrolProgress getPatrolProgress;
  final AddPatrolLocation addPatrolLocation;
  final PatrolRepository patrolRepository;

  PatrolBloc({
    required this.getPatrolRoutes,
    required this.getPatrolRoutesPaginated,
    required this.getPatrolProgress,
    required this.addPatrolLocation,
    required this.patrolRepository,
  }) : super(PatrolInitial()) {
    on<LoadPatrolRoutes>(_onLoadPatrolRoutes);
    on<LoadMorePatrolRoutes>(_onLoadMorePatrolRoutes);
    on<LoadPatrolProgress>(_onLoadPatrolProgress);
    on<RefreshPatrolData>(_onRefreshPatrolData);
    on<SelectPatrolRoute>(_onSelectPatrolRoute);
    on<AddPatrolLocationEvent>(_onAddPatrolLocation);
    on<ReloadAndSelectRoute>(_onReloadAndSelectRoute);
    on<LoadPatrolRoutesFromData>(_onLoadPatrolRoutesFromData);
    on<LoadAreasByRouteId>(_onLoadAreasByRouteId);
  }

  Future<void> _onLoadPatrolRoutes(
    LoadPatrolRoutes event,
    Emitter<PatrolState> emit,
  ) async {
    emit(PatrolLoading());

    print('[PatrolBloc] LoadPatrolRoutes - Initial load from home_patrol_page');

    final result = await getPatrolRoutesPaginated(
      page: 1,
      pageSize: 10,
    );

    result.fold(
      (failure) {
        print('[PatrolBloc] Error loading routes: ${failure.message}');
        emit(PatrolError(failure.message));
      },
      (paginatedResponse) {
        print('[PatrolBloc] Loaded ${paginatedResponse.data.length} routes');
        emit(PatrolLoaded(
          routes: paginatedResponse.data,
          currentPage: paginatedResponse.currentPage,
          hasMore: paginatedResponse.hasMore,
          totalCount: paginatedResponse.totalCount,
        ));
      },
    );
  }

  Future<void> _onLoadMorePatrolRoutes(
    LoadMorePatrolRoutes event,
    Emitter<PatrolState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PatrolLoaded ||
        !currentState.hasMore ||
        currentState.isLoadingMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.currentPage + 1;
    print('[PatrolBloc] Loading more routes - page: $nextPage');

    final result = await getPatrolRoutesPaginated(
      page: nextPage,
      pageSize: 10,
    );

    result.fold(
      (failure) {
        print('[PatrolBloc] Error loading more routes: ${failure.message}');
        emit(currentState.copyWith(isLoadingMore: false));
      },
      (paginatedResponse) {
        print(
            '[PatrolBloc] Loaded ${paginatedResponse.data.length} more routes');
        final updatedRoutes = List<PatrolRoute>.from(currentState.routes)
          ..addAll(paginatedResponse.data);

        emit(currentState.copyWith(
          routes: updatedRoutes,
          currentPage: paginatedResponse.currentPage,
          hasMore: paginatedResponse.hasMore,
          totalCount: paginatedResponse.totalCount,
          isLoadingMore: false,
        ));
      },
    );
  }

  Future<void> _onLoadPatrolProgress(
    LoadPatrolProgress event,
    Emitter<PatrolState> emit,
  ) async {
    final currentState = state;
    if (currentState is PatrolLoaded) {
      final result = await getPatrolProgress(event.routeId);
      result.fold(
        (failure) => emit(PatrolError(failure.message)),
        (progress) => emit(currentState.copyWith(progress: progress)),
      );
    }
  }

  Future<void> _onRefreshPatrolData(
    RefreshPatrolData event,
    Emitter<PatrolState> emit,
  ) async {
    add(LoadPatrolRoutes());
  }

  Future<void> _onSelectPatrolRoute(
    SelectPatrolRoute event,
    Emitter<PatrolState> emit,
  ) async {
    final currentState = state;
    if (currentState is PatrolLoaded) {
      // Use indexWhere for safe access
      final routeIndex =
          currentState.routes.indexWhere((route) => route.id == event.routeId);

      if (routeIndex == -1) {
        print('[PatrolBloc] Route not found: ${event.routeId}');
        return;
      }

      final selectedRoute = currentState.routes[routeIndex];
      emit(currentState.copyWith(selectedRoute: selectedRoute));
      // Don't load progress from API - UI calculates it from route.locations
    }
  }

  Future<void> _onAddPatrolLocation(
    AddPatrolLocationEvent event,
    Emitter<PatrolState> emit,
  ) async {
    final location = PatrolLocation(
      id: '', // Will be set by backend
      name: event.locationName,
      description: '',
      latitude: event.latitude,
      longitude: event.longitude,
      address: '',
      isAdditional: true,
    );

    final result = await addPatrolLocation(
      AddPatrolLocationParams(
        routeId: event.routeId,
        location: location,
      ),
    );

    result.fold(
      (failure) {
        print('[PatrolBloc] Error adding location: ${failure.message}');
        emit(PatrolError(failure.message));
      },
      (addedLocation) {
        print(
            '[PatrolBloc] Location added successfully: ${addedLocation.name}');
        // Emit success state
        emit(PatrolLocationAdded(event.routeId));
        // Reload patrol routes and then select the route
        add(ReloadAndSelectRoute(event.routeId));
      },
    );
  }

  Future<void> _onReloadAndSelectRoute(
    ReloadAndSelectRoute event,
    Emitter<PatrolState> emit,
  ) async {
    print(
        '[PatrolBloc] ReloadAndSelectRoute - Load areas from /Areas/list for route: ${event.routeId}');

    // Use LoadAreasByRouteId instead
    add(LoadAreasByRouteId(event.routeId));
  }

  Future<void> _onLoadAreasByRouteId(
    LoadAreasByRouteId event,
    Emitter<PatrolState> emit,
  ) async {
    print('[PatrolBloc] LoadAreasByRouteId - Loading areas for IdAreas: ${event.routeId}');

    // Emit loading state
    emit(PatrolLoading());

    // Load areas from /Areas/list using routeId (which is actually IdAreas)
    final areasResult = await patrolRepository.getAreasByIdAreas(event.routeId);

    areasResult.fold(
      (failure) {
        print('[PatrolBloc] Error loading areas: ${failure.message}');
        emit(PatrolError(failure.message));
      },
      (locations) {
        print('[PatrolBloc] Successfully loaded ${locations.length} areas');
        
        // Use existing route if provided, otherwise create new one
        final baseRoute = event.existingRoute;
        final updatedRoute = baseRoute != null
            ? baseRoute.copyWith(locations: locations)
            : PatrolRoute(
                id: event.routeId,
                name: 'Patroli',
                description: '${locations.length} Lokasi',
                locations: locations,
                additionalLocations: const [],
                date: DateTime.now(),
              );

        // Check if we have existing state
        final currentState = state;
        if (currentState is PatrolLoaded) {
          // Update existing routes list
          final updatedRoutes = currentState.routes.map((route) {
            if (route.id == event.routeId) {
              return updatedRoute;
            }
            return route;
          }).toList();

          // If route not in list, add it
          if (!updatedRoutes.any((r) => r.id == event.routeId)) {
            updatedRoutes.add(updatedRoute);
          }

          emit(PatrolLoaded(
            routes: updatedRoutes,
            selectedRoute: updatedRoute,
            currentPage: currentState.currentPage,
            hasMore: currentState.hasMore,
            totalCount: updatedRoutes.length,
            isLoadingMore: currentState.isLoadingMore,
          ));
        } else {
          // No existing state, create new loaded state
          emit(PatrolLoaded(
            routes: [updatedRoute],
            selectedRoute: updatedRoute,
            currentPage: 1,
            hasMore: false,
            totalCount: 1,
          ));
        }
      },
    );
  }

  void _onLoadPatrolRoutesFromData(
    LoadPatrolRoutesFromData event,
    Emitter<PatrolState> emit,
  ) {
    // Skip if already loaded with same data
    final currentState = state;
    if (currentState is PatrolLoaded &&
        currentState.selectedRoute?.id == event.selectedRouteId) {
      print(
          '[PatrolBloc] LoadPatrolRoutesFromData - Already loaded, skipping duplicate');
      return;
    }

    print(
        '[PatrolBloc] LoadPatrolRoutesFromData - Using existing data from parent (no API call)');

    // Find and select the route if selectedRouteId provided
    PatrolRoute? selectedRoute;
    if (event.selectedRouteId != null) {
      final routeIndex =
          event.routes.indexWhere((route) => route.id == event.selectedRouteId);
      if (routeIndex != -1) {
        selectedRoute = event.routes[routeIndex];
      }
    }

    emit(PatrolLoaded(
      routes: event.routes,
      selectedRoute: selectedRoute,
      currentPage: 1,
      hasMore: false,
      totalCount: event.routes.length,
    ));

    // Don't load progress from API - it will be calculated from route.locations
    // This prevents unnecessary API calls and "Bad state: No element" errors
  }
}
