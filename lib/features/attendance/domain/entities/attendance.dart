import 'package:equatable/equatable.dart';

enum AttendanceType { clockIn, clockOut }

enum ShiftType { morning, night }

enum AttendanceStatus { pending, approved, rejected }

class Attendance extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final AttendanceType type;
  final ShiftType shiftType;
  final DateTime timestamp;
  final String guardLocation;
  final String currentLocation;
  final double? latitude;
  final double? longitude;
  final String personalClothing;
  final String securityReport;
  final String? photoPath;
  final String patrolRoute;
  final AttendanceStatus status;
  final String? rejectionReason;
  final List<String> approvalChain;
  final String? approvedBy;
  final DateTime? approvedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Attendance({
    required this.id,
    required this.userId,
    required this.userName,
    required this.type,
    required this.shiftType,
    required this.timestamp,
    required this.guardLocation,
    required this.currentLocation,
    this.latitude,
    this.longitude,
    required this.personalClothing,
    required this.securityReport,
    this.photoPath,
    required this.patrolRoute,
    this.status = AttendanceStatus.pending,
    this.rejectionReason,
    this.approvalChain = const [],
    this.approvedBy,
    this.approvedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  Attendance copyWith({
    String? id,
    String? userId,
    String? userName,
    AttendanceType? type,
    ShiftType? shiftType,
    DateTime? timestamp,
    String? guardLocation,
    String? currentLocation,
    double? latitude,
    double? longitude,
    String? personalClothing,
    String? securityReport,
    String? photoPath,
    String? patrolRoute,
    AttendanceStatus? status,
    String? rejectionReason,
    List<String>? approvalChain,
    String? approvedBy,
    DateTime? approvedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Attendance(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      type: type ?? this.type,
      shiftType: shiftType ?? this.shiftType,
      timestamp: timestamp ?? this.timestamp,
      guardLocation: guardLocation ?? this.guardLocation,
      currentLocation: currentLocation ?? this.currentLocation,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      personalClothing: personalClothing ?? this.personalClothing,
      securityReport: securityReport ?? this.securityReport,
      photoPath: photoPath ?? this.photoPath,
      patrolRoute: patrolRoute ?? this.patrolRoute,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      approvalChain: approvalChain ?? this.approvalChain,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedAt: approvedAt ?? this.approvedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isLate {
    final attendanceTime = timestamp;

    if (shiftType == ShiftType.morning) {
      // Morning shift: late if after 07:10
      final cutoffTime = DateTime(
        attendanceTime.year,
        attendanceTime.month,
        attendanceTime.day,
        7,
        10,
      );
      return attendanceTime.isAfter(cutoffTime);
    } else {
      // Night shift: late if after 19:10
      final cutoffTime = DateTime(
        attendanceTime.year,
        attendanceTime.month,
        attendanceTime.day,
        19,
        10,
      );
      return attendanceTime.isAfter(cutoffTime);
    }
  }

  bool get isLocationValid {
    return guardLocation.toLowerCase() == currentLocation.toLowerCase();
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        type,
        shiftType,
        timestamp,
        guardLocation,
        currentLocation,
        latitude,
        longitude,
        personalClothing,
        securityReport,
        photoPath,
        patrolRoute,
        status,
        rejectionReason,
        approvalChain,
        approvedBy,
        approvedAt,
        createdAt,
        updatedAt,
      ];
}
