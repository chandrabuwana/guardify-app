part of 'patrol_bloc.dart';

abstract class PatrolEvent {
  const PatrolEvent();
}

class LoadPatrolRoutes extends PatrolEvent {}

class LoadMorePatrolRoutes extends PatrolEvent {}

class LoadPatrolProgress extends PatrolEvent {
  final String routeId;

  const LoadPatrolProgress(this.routeId);
}

class RefreshPatrolData extends PatrolEvent {}

class SelectPatrolRoute extends PatrolEvent {
  final String routeId;

  const SelectPatrolRoute(this.routeId);
}

class AddPatrolLocationEvent extends PatrolEvent {
  final String routeId;
  final String locationName;
  final double latitude;
  final double longitude;
  final int radius;

  const AddPatrolLocationEvent({
    required this.routeId,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.radius,
  });
}

class ReloadAndSelectRoute extends PatrolEvent {
  final String routeId;

  const ReloadAndSelectRoute(this.routeId);
}

class LoadPatrolRoutesFromData extends PatrolEvent {
  final List<PatrolRoute> routes;
  final String? selectedRouteId;

  const LoadPatrolRoutesFromData(this.routes, [this.selectedRouteId]);
}
