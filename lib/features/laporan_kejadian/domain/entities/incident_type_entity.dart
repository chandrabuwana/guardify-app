import '../entities/incident_entity.dart';

class IncidentTypeEntity {
  final String id;
  final String name;
  final IncidentType type;

  const IncidentTypeEntity({
    required this.id,
    required this.name,
    required this.type,
  });
}

