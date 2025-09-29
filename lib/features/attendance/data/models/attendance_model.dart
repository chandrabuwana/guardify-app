import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/attendance.dart';

part 'attendance_model.g.dart';

@JsonSerializable()
class AttendanceModel extends Attendance {
  const AttendanceModel({
    required super.id,
    required super.userId,
    required super.userName,
    required super.type,
    required super.shiftType,
    required super.timestamp,
    required super.guardLocation,
    required super.currentLocation,
    super.latitude,
    super.longitude,
    required super.personalClothing,
    required super.securityReport,
    super.photoPath,
    required super.patrolRoute,
    super.status = AttendanceStatus.pending,
    super.rejectionReason,
    super.approvalChain = const [],
    super.approvedBy,
    super.approvedAt,
    required super.createdAt,
    required super.updatedAt,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      type: AttendanceType.values.byName(json['type'] as String),
      shiftType: ShiftType.values.byName(json['shiftType'] as String),
      timestamp: DateTime.parse(json['timestamp'] as String),
      guardLocation: json['guardLocation'] as String,
      currentLocation: json['currentLocation'] as String,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      personalClothing: json['personalClothing'] as String,
      securityReport: json['securityReport'] as String,
      photoPath: json['photoPath'] as String?,
      patrolRoute: json['patrolRoute'] as String,
      status: AttendanceStatus.values.byName(json['status'] as String),
      rejectionReason: json['rejectionReason'] as String?,
      approvalChain:
          (json['approvalChain'] as List<dynamic>?)?.cast<String>() ?? [],
      approvedBy: json['approvedBy'] as String?,
      approvedAt: json['approvedAt'] != null
          ? DateTime.parse(json['approvedAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'type': type.name,
      'shiftType': shiftType.name,
      'timestamp': timestamp.toIso8601String(),
      'guardLocation': guardLocation,
      'currentLocation': currentLocation,
      'latitude': latitude,
      'longitude': longitude,
      'personalClothing': personalClothing,
      'securityReport': securityReport,
      'photoPath': photoPath,
      'patrolRoute': patrolRoute,
      'status': status.name,
      'rejectionReason': rejectionReason,
      'approvalChain': approvalChain,
      'approvedBy': approvedBy,
      'approvedAt': approvedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory AttendanceModel.fromEntity(Attendance attendance) {
    return AttendanceModel(
      id: attendance.id,
      userId: attendance.userId,
      userName: attendance.userName,
      type: attendance.type,
      shiftType: attendance.shiftType,
      timestamp: attendance.timestamp,
      guardLocation: attendance.guardLocation,
      currentLocation: attendance.currentLocation,
      latitude: attendance.latitude,
      longitude: attendance.longitude,
      personalClothing: attendance.personalClothing,
      securityReport: attendance.securityReport,
      photoPath: attendance.photoPath,
      patrolRoute: attendance.patrolRoute,
      status: attendance.status,
      rejectionReason: attendance.rejectionReason,
      approvalChain: attendance.approvalChain,
      approvedBy: attendance.approvedBy,
      approvedAt: attendance.approvedAt,
      createdAt: attendance.createdAt,
      updatedAt: attendance.updatedAt,
    );
  }

  Attendance toEntity() {
    return Attendance(
      id: id,
      userId: userId,
      userName: userName,
      type: type,
      shiftType: shiftType,
      timestamp: timestamp,
      guardLocation: guardLocation,
      currentLocation: currentLocation,
      latitude: latitude,
      longitude: longitude,
      personalClothing: personalClothing,
      securityReport: securityReport,
      photoPath: photoPath,
      patrolRoute: patrolRoute,
      status: status,
      rejectionReason: rejectionReason,
      approvalChain: approvalChain,
      approvedBy: approvedBy,
      approvedAt: approvedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
