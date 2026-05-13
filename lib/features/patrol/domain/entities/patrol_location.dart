import 'package:equatable/equatable.dart';

class PatrolLocation extends Equatable {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final String address;
  final PatrolLocationStatus status;
  final DateTime? completedAt;
  final String? proofImagePath;
  final String? notes;
  final bool isAdditional;
  final double? radius;

  const PatrolLocation({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.status = PatrolLocationStatus.pending,
    this.completedAt,
    this.proofImagePath,
    this.notes,
    this.isAdditional = false,
    this.radius,
  });

  PatrolLocation copyWith({
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
    double? radius,
  }) {
    return PatrolLocation(
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
      radius: radius ?? this.radius,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        latitude,
        longitude,
        address,
        status,
        completedAt,
        proofImagePath,
        notes,
        isAdditional,
        radius,
      ];
}

enum PatrolLocationStatus {
  pending,
  completed,
  failed,
}