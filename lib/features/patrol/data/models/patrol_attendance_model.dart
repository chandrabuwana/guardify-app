import '../../domain/entities/patrol_attendance.dart';

class PatrolAttendanceModel extends PatrolAttendance {
  const PatrolAttendanceModel({
    required super.id,
    required super.patrolLocationId,
    required super.userId,
    required super.timestamp,
    required super.currentLatitude,
    required super.currentLongitude,
    required super.currentAddress,
    required super.proofImagePath,
    super.notes,
    required super.isLocationVerified,
    super.status,
  });

  factory PatrolAttendanceModel.fromJson(Map<String, dynamic> json) {
    return PatrolAttendanceModel(
      id: json['id'] ?? '',
      patrolLocationId: json['patrol_location_id'] ?? '',
      userId: json['user_id'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      currentLatitude: (json['current_latitude'] ?? 0.0).toDouble(),
      currentLongitude: (json['current_longitude'] ?? 0.0).toDouble(),
      currentAddress: json['current_address'] ?? '',
      proofImagePath: json['proof_image_path'] ?? '',
      notes: json['notes'],
      isLocationVerified: json['is_location_verified'] ?? false,
      status: AttendanceStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => AttendanceStatus.pending,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patrol_location_id': patrolLocationId,
      'user_id': userId,
      'timestamp': timestamp.toIso8601String(),
      'current_latitude': currentLatitude,
      'current_longitude': currentLongitude,
      'current_address': currentAddress,
      'proof_image_path': proofImagePath,
      'notes': notes,
      'is_location_verified': isLocationVerified,
      'status': status.name,
    };
  }

  @override
  PatrolAttendanceModel copyWith({
    String? id,
    String? patrolLocationId,
    String? userId,
    DateTime? timestamp,
    double? currentLatitude,
    double? currentLongitude,
    String? currentAddress,
    String? proofImagePath,
    String? notes,
    bool? isLocationVerified,
    AttendanceStatus? status,
  }) {
    return PatrolAttendanceModel(
      id: id ?? this.id,
      patrolLocationId: patrolLocationId ?? this.patrolLocationId,
      userId: userId ?? this.userId,
      timestamp: timestamp ?? this.timestamp,
      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,
      currentAddress: currentAddress ?? this.currentAddress,
      proofImagePath: proofImagePath ?? this.proofImagePath,
      notes: notes ?? this.notes,
      isLocationVerified: isLocationVerified ?? this.isLocationVerified,
      status: status ?? this.status,
    );
  }
}