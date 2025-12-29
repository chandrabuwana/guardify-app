import '../../domain/entities/incident_type_entity.dart';
import '../../domain/entities/incident_entity.dart';

class IncidentTypeModel extends IncidentTypeEntity {
  const IncidentTypeModel({
    required super.id,
    required super.name,
    required super.type,
  });

  factory IncidentTypeModel.fromJson(Map<String, dynamic> json) {
    return IncidentTypeModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: _parseType(json['type']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': _typeToString(type),
    };
  }

  factory IncidentTypeModel.fromEntity(IncidentTypeEntity entity) {
    return IncidentTypeModel(
      id: entity.id,
      name: entity.name,
      type: entity.type,
    );
  }

  IncidentTypeEntity toEntity() {
    return IncidentTypeEntity(
      id: id,
      name: name,
      type: type,
    );
  }

  static IncidentType _parseType(String type) {
    switch (type.toLowerCase()) {
      case 'keamanan':
        return IncidentType.keamanan;
      case 'kebakaran':
        return IncidentType.kebakaran;
      case 'medis':
        return IncidentType.medis;
      case 'lainnya':
        return IncidentType.lainnya;
      default:
        return IncidentType.lainnya;
    }
  }

  static String _typeToString(IncidentType type) {
    switch (type) {
      case IncidentType.keamanan:
        return 'keamanan';
      case IncidentType.kebakaran:
        return 'kebakaran';
      case IncidentType.medis:
        return 'medis';
      case IncidentType.lainnya:
        return 'lainnya';
    }
  }
}

