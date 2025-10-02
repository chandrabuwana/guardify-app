part of 'attendance_bloc.dart';

abstract class AttendanceEvent {
  const AttendanceEvent();
}

class SubmitAttendanceEvent extends AttendanceEvent {
  final String patrolLocationId;
  final String currentAddress;
  final String proofImagePath;
  final String? notes;

  const SubmitAttendanceEvent({
    required this.patrolLocationId,
    required this.currentAddress,
    required this.proofImagePath,
    this.notes,
  });
}

class VerifyLocationEvent extends AttendanceEvent {
  final double currentLatitude;
  final double currentLongitude;
  final double targetLatitude;
  final double targetLongitude;

  const VerifyLocationEvent({
    required this.currentLatitude,
    required this.currentLongitude,
    required this.targetLatitude,
    required this.targetLongitude,
  });
}

class GetCurrentLocationEvent extends AttendanceEvent {}

class UploadProofImageEvent extends AttendanceEvent {
  final String imagePath;

  const UploadProofImageEvent(this.imagePath);
}