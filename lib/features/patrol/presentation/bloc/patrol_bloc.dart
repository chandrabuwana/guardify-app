import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/patrol_route.dart';
import '../../domain/entities/patrol_progress.dart';
import '../../domain/usecases/get_patrol_routes.dart';
import '../../domain/usecases/get_patrol_routes_paginated.dart';
import '../../domain/usecases/get_patrol_progress.dart';

part 'patrol_event.dart';
part 'patrol_state.dart';

@injectable
class PatrolBloc extends Bloc<PatrolEvent, PatrolState> {
  final GetPatrolRoutes getPatrolRoutes;
  final GetPatrolRoutesPaginated getPatrolRoutesPaginated;
  final GetPatrolProgress getPatrolProgress;

  PatrolBloc({
    required this.getPatrolRoutes,
    required this.getPatrolRoutesPaginated,
    required this.getPatrolProgress,
  }) : super(PatrolInitial()) {
    on<LoadPatrolRoutes>(_onLoadPatrolRoutes);
    on<LoadMorePatrolRoutes>(_onLoadMorePatrolRoutes);
    on<LoadPatrolProgress>(_onLoadPatrolProgress);
    on<RefreshPatrolData>(_onRefreshPatrolData);
    on<SelectPatrolRoute>(_onSelectPatrolRoute);
  }

  Future<void> _onLoadPatrolRoutes(
    LoadPatrolRoutes event,
    Emitter<PatrolState> emit,
  ) async {
    emit(PatrolLoading());

    print('[PatrolBloc] Loading patrol routes - page: 1');

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
      final selectedRoute =
          currentState.routes.firstWhere((route) => route.id == event.routeId);

      emit(currentState.copyWith(selectedRoute: selectedRoute));
      add(LoadPatrolProgress(event.routeId));
    }
  }
}
