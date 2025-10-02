import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/patrol_route.dart';
import '../../domain/entities/patrol_progress.dart';
import '../../domain/usecases/get_patrol_routes.dart';
import '../../domain/usecases/get_patrol_progress.dart';

part 'patrol_event.dart';
part 'patrol_state.dart';

@injectable
class PatrolBloc extends Bloc<PatrolEvent, PatrolState> {
  final GetPatrolRoutes getPatrolRoutes;
  final GetPatrolProgress getPatrolProgress;

  PatrolBloc({
    required this.getPatrolRoutes,
    required this.getPatrolProgress,
  }) : super(PatrolInitial()) {
    on<LoadPatrolRoutes>(_onLoadPatrolRoutes);
    on<LoadPatrolProgress>(_onLoadPatrolProgress);
    on<RefreshPatrolData>(_onRefreshPatrolData);
    on<SelectPatrolRoute>(_onSelectPatrolRoute);
  }

  Future<void> _onLoadPatrolRoutes(
    LoadPatrolRoutes event,
    Emitter<PatrolState> emit,
  ) async {
    emit(PatrolLoading());
    
    final result = await getPatrolRoutes();
    result.fold(
      (failure) => emit(PatrolError(failure.message)),
      (routes) => emit(PatrolLoaded(routes: routes)),
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
      final selectedRoute = currentState.routes
          .firstWhere((route) => route.id == event.routeId);
      
      emit(currentState.copyWith(selectedRoute: selectedRoute));
      add(LoadPatrolProgress(event.routeId));
    }
  }
}