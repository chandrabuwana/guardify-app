import '../../domain/entities/incident_location_entity.dart';

class IncidentLocationModel extends IncidentLocationEntity {
  const IncidentLocationModel({
    required super.id,
    required super.name,
  });

  factory IncidentLocationModel.fromJson(Map<String, dynamic> json) {
    return IncidentLocationModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory IncidentLocationModel.fromEntity(IncidentLocationEntity entity) {
    return IncidentLocationModel(
      id: entity.id,
      name: entity.name,
    );
  }

  IncidentLocationEntity toEntity() {
    return IncidentLocationEntity(
      id: id,
      name: name,
    );
  }
}

