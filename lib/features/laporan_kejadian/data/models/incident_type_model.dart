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

  /// Create IncidentTypeModel from API model
  factory IncidentTypeModel.fromApiModel(dynamic apiModel) {
    // Handle both IncidentTypeApiModel and Map<String, dynamic>
    String name;
    int id;
    
    if (apiModel is Map<String, dynamic>) {
      name = apiModel['Name']?.toString() ?? '';
      id = apiModel['Id'] is int ? apiModel['Id'] : int.tryParse(apiModel['Id']?.toString() ?? '0') ?? 0;
    } else {
      // Assume it's an IncidentTypeApiModel
      name = apiModel.name;
      id = apiModel.id;
    }
    
    return IncidentTypeModel(
      id: id.toString(),
      name: name,
      type: _parseTypeFromName(name),
    );
  }

  /// Parse IncidentType from name string
  static IncidentType _parseTypeFromName(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('keamanan')) {
      return IncidentType.keamanan;
    } else if (lowerName.contains('kebakaran')) {
      return IncidentType.kebakaran;
    } else if (lowerName.contains('kesehatan') || 
               lowerName.contains('kecelakaan') || 
               lowerName.contains('medis')) {
      return IncidentType.medis;
    } else if (lowerName.contains('bencana')) {
      return IncidentType.lainnya;
    } else {
      return IncidentType.lainnya;
    }
  }
}

