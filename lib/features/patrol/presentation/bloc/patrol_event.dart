part of 'patrol_bloc.dart';

abstract class PatrolEvent {
  const PatrolEvent();
}

class LoadPatrolRoutes extends PatrolEvent {}

class LoadPatrolProgress extends PatrolEvent {
  final String routeId;

  const LoadPatrolProgress(this.routeId);
}

class RefreshPatrolData extends PatrolEvent {}

class SelectPatrolRoute extends PatrolEvent {
  final String routeId;

  const SelectPatrolRoute(this.routeId);
}