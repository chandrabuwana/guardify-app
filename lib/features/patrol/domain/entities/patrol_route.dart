import 'package:equatable/equatable.dart';
import 'patrol_location.dart';

class PatrolRoute extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<PatrolLocation> locations;
  final List<PatrolLocation> additionalLocations;
  final DateTime date;
  final PatrolRouteStatus status;

  const PatrolRoute({
    required this.id,
    required this.name,
    required this.description,
    required this.locations,
    this.additionalLocations = const [],
    required this.date,
    this.status = PatrolRouteStatus.pending,
  });

  PatrolRoute copyWith({
    String? id,
    String? name,
    String? description,
    List<PatrolLocation>? locations,
    List<PatrolLocation>? additionalLocations,
    DateTime? date,
    PatrolRouteStatus? status,
  }) {
    return PatrolRoute(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      locations: locations ?? this.locations,
      additionalLocations: additionalLocations ?? this.additionalLocations,
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        locations,
        additionalLocations,
        date,
        status,
      ];
}

enum PatrolRouteStatus {
  pending,
  inProgress,
  completed,
}