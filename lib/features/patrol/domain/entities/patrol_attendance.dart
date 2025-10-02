import 'package:equatable/equatable.dart';

class PatrolAttendance extends Equatable {
  final String id;
  final String patrolLocationId;
  final String userId;
  final DateTime timestamp;
  final double currentLatitude;
  final double currentLongitude;
  final String currentAddress;
  final String proofImagePath;
  final String? notes;
  final bool isLocationVerified;
  final AttendanceStatus status;

  const PatrolAttendance({
    required this.id,
    required this.patrolLocationId,
    required this.userId,
    required this.timestamp,
    required this.currentLatitude,
    required this.currentLongitude,
    required this.currentAddress,
    required this.proofImagePath,
    this.notes,
    required this.isLocationVerified,
    this.status = AttendanceStatus.pending,
  });

  PatrolAttendance copyWith({
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
    return PatrolAttendance(
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

  @override
  List<Object?> get props => [
        id,
        patrolLocationId,
        userId,
        timestamp,
        currentLatitude,
        currentLongitude,
        currentAddress,
        proofImagePath,
        notes,
        isLocationVerified,
        status,
      ];
}

enum AttendanceStatus {
  pending,
  submitted,
  approved,
  rejected,
}