import '../../domain/entities/patrol_route.dart';
import '../../domain/entities/patrol_location.dart';
import 'patrol_location_model.dart';

class PatrolRouteModel extends PatrolRoute {
  const PatrolRouteModel({
    required super.id,
    required super.name,
    required super.description,
    required super.locations,
    super.additionalLocations,
    required super.date,
    super.status,
  });

  factory PatrolRouteModel.fromJson(Map<String, dynamic> json) {
    return PatrolRouteModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      locations: (json['locations'] as List<dynamic>?)
              ?.map((e) => PatrolLocationModel.fromJson(e))
              .toList() ??
          [],
      additionalLocations: (json['additional_locations'] as List<dynamic>?)
              ?.map((e) => PatrolLocationModel.fromJson(e))
              .toList() ??
          [],
      date: DateTime.parse(json['date']),
      status: PatrolRouteStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => PatrolRouteStatus.pending,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'locations': locations
          .map((location) => (location as PatrolLocationModel).toJson())
          .toList(),
      'additional_locations': additionalLocations
          .map((location) => (location as PatrolLocationModel).toJson())
          .toList(),
      'date': date.toIso8601String(),
      'status': status.name,
    };
  }

  @override
  PatrolRouteModel copyWith({
    String? id,
    String? name,
    String? description,
    List<PatrolLocation>? locations,
    List<PatrolLocation>? additionalLocations,
    DateTime? date,
    PatrolRouteStatus? status,
  }) {
    return PatrolRouteModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      locations: locations ?? this.locations,
      additionalLocations: additionalLocations ?? this.additionalLocations,
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }
}