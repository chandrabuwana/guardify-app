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
import '../../../schedule/domain/repositories/schedule_repository.dart';
import '../../data/mappers/route_task_mapper.dart';

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
        
        // Get current state to preserve listRoute
        final currentState = state;
        
        if (currentState is PatrolLoaded) {
          // Find existing route and add the new location to it
          final existingRoute = currentState.routes
              .where((route) => route.id == event.routeId)
              .firstOrNull;
          
          if (existingRoute != null) {
            // Add new location to existing route (as additional location)
            final updatedAdditionalLocations = List<PatrolLocation>.from(existingRoute.additionalLocations)
              ..add(addedLocation);
            
            final updatedRoute = existingRoute.copyWith(
              additionalLocations: updatedAdditionalLocations,
            );
            
            // Update routes list
            final updatedRoutes = currentState.routes.map((route) {
              if (route.id == event.routeId) {
                return updatedRoute;
              }
              return route;
            }).toList();
            
            // Emit updated state with new location, preserving listRoute
            emit(PatrolLoaded(
              routes: updatedRoutes,
              selectedRoute: updatedRoute,
              currentPage: currentState.currentPage,
              hasMore: currentState.hasMore,
              totalCount: updatedRoutes.length,
              isLoadingMore: currentState.isLoadingMore,
              listRoute: currentState.listRoute, // Preserve listRoute - NO API CALL
            ));
            
            print('[PatrolBloc] Route updated with new location, no API call needed');
            return;
          }
        }
        
        // Fallback: If we can't update directly (shouldn't happen in normal flow)
        // Get listRoute before emitting new state
        List<RouteTask>? listRoute;
        PatrolRoute? existingRoute;
        
        if (currentState is PatrolLoaded) {
          listRoute = currentState.listRoute;
          existingRoute = currentState.routes
              .where((route) => route.id == event.routeId)
              .firstOrNull;
        }
        
        // Emit success state
        emit(PatrolLocationAdded(event.routeId));
        // Reload patrol routes with listRoute preserved (but this should use listRoute, not API)
        if (listRoute != null) {
          // Use LoadAreasByRouteId directly with listRoute to avoid API call
          add(LoadAreasByRouteId(event.routeId, existingRoute, listRoute));
        } else {
          // Only reload if listRoute is not available (shouldn't happen)
          add(ReloadAndSelectRoute(event.routeId));
        }
      },
    );
  }

  Future<void> _onReloadAndSelectRoute(
    ReloadAndSelectRoute event,
    Emitter<PatrolState> emit,
  ) async {
    print(
        '[PatrolBloc] ReloadAndSelectRoute - Reloading areas for route: ${event.routeId}');

    // Get listRoute from current state if available
    // Need to check previous state because current state might be PatrolLocationAdded
    List<RouteTask>? listRoute;
    PatrolRoute? existingRoute;
    
    // Try to get from current state
    final currentState = state;
    if (currentState is PatrolLoaded) {
      listRoute = currentState.listRoute;
      // Find existing route
      existingRoute = currentState.routes
          .where((route) => route.id == event.routeId)
          .firstOrNull;
    } else {
      // If current state is not PatrolLoaded, try to get from history
      // This can happen if state changed to PatrolLocationAdded
      // We need to preserve listRoute, so we'll get it from the last PatrolLoaded state
      // For now, we'll check if we can get it from a stored reference
      // Actually, better approach: don't reload if we just added a location
      // The location should already be added to the route in _onAddPatrolLocation
      print('[PatrolBloc] Current state is not PatrolLoaded, skipping reload to avoid API call');
      return;
    }

    // Use LoadAreasByRouteId with listRoute from state
    add(LoadAreasByRouteId(event.routeId, existingRoute, listRoute));
  }

  Future<void> _onLoadAreasByRouteId(
    LoadAreasByRouteId event,
    Emitter<PatrolState> emit,
  ) async {
    print('[PatrolBloc] LoadAreasByRouteId - Loading areas for IdAreas: ${event.routeId}');

    // Emit loading state
    emit(PatrolLoading());

    List<PatrolLocation> locations;

    // If ListRoute data is provided, use it instead of calling API
    if (event.listRoute != null && event.listRoute!.isNotEmpty) {
      print('[PatrolBloc] Using ListRoute data from get_current_task (${event.listRoute!.length} routes)');
      
      // Convert RouteTask list to PatrolLocation list
      locations = RouteTaskMapper.toPatrolLocations(event.listRoute!);
      
      print('[PatrolBloc] Successfully converted ${locations.length} locations from ListRoute');
    } else {
      // Fallback to API call if ListRoute data is not provided
      print('[PatrolBloc] ListRoute data not provided, calling API...');
      
      final areasResult = await patrolRepository.getAreasByIdAreas(event.routeId);
      
      return areasResult.fold(
        (failure) {
          print('[PatrolBloc] Error loading areas: ${failure.message}');
          emit(PatrolError(failure.message));
        },
        (apiLocations) {
          locations = apiLocations;
          _emitPatrolLoadedState(emit, event, locations);
        },
      );
    }

    // Emit loaded state with locations
    _emitPatrolLoadedState(emit, event, locations);
  }

  void _emitPatrolLoadedState(
    Emitter<PatrolState> emit,
    LoadAreasByRouteId event,
    List<PatrolLocation> locations,
  ) {
    print('[PatrolBloc] Successfully loaded ${locations.length} locations');
    print('[PatrolBloc] Location details:');
    for (var loc in locations) {
      print('  - ${loc.name} (Status: ${loc.status}, ID: ${loc.id})');
    }
    
    // Use existing route if provided, otherwise create new one
    final baseRoute = event.existingRoute;
    List<PatrolLocation> finalLocations;
    
    if (baseRoute != null) {
      print('[PatrolBloc] Base route has ${baseRoute.locations.length} locations before update');
      print('[PatrolBloc] New locations from get_current_task: ${locations.length}');
      
      // Merge existing locations with new locations from get_current_task
      // Strategy: Update existing locations if found in new data, add new ones that don't exist
      final existingLocationIds = baseRoute.locations.map((loc) => loc.id).toSet();
      final existingLocationNames = baseRoute.locations.map((loc) => loc.name).toSet();
      
      // Separate new locations into: ones that update existing, and truly new ones
      final locationsToUpdate = <PatrolLocation>[];
      final trulyNewLocations = <PatrolLocation>[];
      
      for (final newLoc in locations) {
        // Check if this location exists in existing locations (by ID or name)
        final existsById = existingLocationIds.contains(newLoc.id);
        final existsByName = existingLocationNames.contains(newLoc.name);
        
        if (existsById || existsByName) {
          // This location exists, use it to update existing one
          locationsToUpdate.add(newLoc);
        } else {
          // This is a truly new location
          trulyNewLocations.add(newLoc);
        }
      }
      
      print('[PatrolBloc] Locations to update existing: ${locationsToUpdate.length}');
      print('[PatrolBloc] Truly new locations to add: ${trulyNewLocations.length}');
      
      // Update existing locations: replace with new data if found, otherwise keep existing
      final updatedExistingLocations = baseRoute.locations.map((existingLoc) {
        // Find matching location in update list (by ID first, then by name)
        final matchingUpdate = locationsToUpdate.firstWhere(
          (updateLoc) => updateLoc.id == existingLoc.id || 
                        (updateLoc.id != existingLoc.id && updateLoc.name == existingLoc.name),
          orElse: () => existingLoc, // Keep existing if no update found
        );
        
        // If we found a matching update, use it; otherwise keep existing
        return matchingUpdate;
      }).toList();
      
      // Combine: updated existing locations + truly new locations
      finalLocations = [...updatedExistingLocations, ...trulyNewLocations];
      
      print('[PatrolBloc] Final merged locations: ${finalLocations.length} (${updatedExistingLocations.length} existing + ${trulyNewLocations.length} new)');
    } else {
      // No existing route, use locations from get_current_task as is
      finalLocations = locations;
      print('[PatrolBloc] No existing route, using ${finalLocations.length} locations from get_current_task');
    }
    
    final updatedRoute = baseRoute != null
        ? baseRoute.copyWith(locations: finalLocations)
        : PatrolRoute(
            id: event.routeId,
            name: 'Patroli',
            description: '${finalLocations.length} Lokasi',
            locations: finalLocations,
            additionalLocations: const [],
            date: DateTime.now(),
          );
    
    print('[PatrolBloc] Updated route has ${updatedRoute.locations.length} locations after merge');

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

      // Preserve listRoute from current state or use from event
      final preservedListRoute = event.listRoute ?? currentState.listRoute;

      emit(PatrolLoaded(
        routes: updatedRoutes,
        selectedRoute: updatedRoute,
        currentPage: currentState.currentPage,
        hasMore: currentState.hasMore,
        totalCount: updatedRoutes.length,
        isLoadingMore: currentState.isLoadingMore,
        listRoute: preservedListRoute, // Preserve listRoute
      ));
    } else {
      // No existing state, create new loaded state
      emit(PatrolLoaded(
        routes: [updatedRoute],
        selectedRoute: updatedRoute,
        currentPage: 1,
        hasMore: false,
        totalCount: 1,
        listRoute: event.listRoute, // Store listRoute from event
      ));
    }
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
