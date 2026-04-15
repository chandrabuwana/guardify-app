import '../../domain/entities/patrol_location.dart';

class PatrolLocationModel extends PatrolLocation {
  const PatrolLocationModel({
    required super.id,
    required super.name,
    required super.description,
    required super.latitude,
    required super.longitude,
    required super.address,
    super.status,
    super.completedAt,
    super.proofImagePath,
    super.notes,
    super.isAdditional,
  });

  factory PatrolLocationModel.fromJson(Map<String, dynamic> json) {
    return PatrolLocationModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      address: json['address'] ?? '',
      status: PatrolLocationStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => PatrolLocationStatus.pending,
      ),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      proofImagePath: json['proof_image_path'],
      notes: json['notes'],
      isAdditional: json['is_additional'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'status': status.name,
      'completed_at': completedAt?.toIso8601String(),
      'proof_image_path': proofImagePath,
      'notes': notes,
      'is_additional': isAdditional,
    };
  }

  @override
  PatrolLocationModel copyWith({
    String? id,
    String? name,
    String? description,
    double? latitude,
    double? longitude,
    String? address,
    PatrolLocationStatus? status,
    DateTime? completedAt,
    String? proofImagePath,
    String? notes,
    bool? isAdditional,
  }) {
    return PatrolLocationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
      proofImagePath: proofImagePath ?? this.proofImagePath,
      notes: notes ?? this.notes,
      isAdditional: isAdditional ?? this.isAdditional,
    );
  }
}