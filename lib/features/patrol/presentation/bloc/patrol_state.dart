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

  const PatrolLoaded({
    required this.routes,
    this.progress,
    this.selectedRoute,
  });

  PatrolLoaded copyWith({
    List<PatrolRoute>? routes,
    PatrolProgress? progress,
    PatrolRoute? selectedRoute,
  }) {
    return PatrolLoaded(
      routes: routes ?? this.routes,
      progress: progress ?? this.progress,
      selectedRoute: selectedRoute ?? this.selectedRoute,
    );
  }
}

class PatrolError extends PatrolState {
  final String message;

  const PatrolError(this.message);
}