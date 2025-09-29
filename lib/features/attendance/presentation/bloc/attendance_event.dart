import 'package:equatable/equatable.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/entities/attendance_validation_rules.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object?> get props => [];
}

// Initialization Events
class AttendanceInitialEvent extends AttendanceEvent {
  const AttendanceInitialEvent();
}

class CheckAttendanceStatusEvent extends AttendanceEvent {
  final String userId;

  const CheckAttendanceStatusEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

// Form Events
class AttendanceFormFieldChangedEvent extends AttendanceEvent {
  final String fieldName;
  final String value;

  const AttendanceFormFieldChangedEvent({
    required this.fieldName,
    required this.value,
  });

  @override
  List<Object> get props => [fieldName, value];
}

class LocationDetectedEvent extends AttendanceEvent {
  final double latitude;
  final double longitude;
  final String locationName;

  const LocationDetectedEvent({
    required this.latitude,
    required this.longitude,
    required this.locationName,
  });

  @override
  List<Object> get props => [latitude, longitude, locationName];
}

class PhotoCapturedEvent extends AttendanceEvent {
  final String photoPath;

  const PhotoCapturedEvent(this.photoPath);

  @override
  List<Object> get props => [photoPath];
}

class PhotoRemovedEvent extends AttendanceEvent {
  const PhotoRemovedEvent();
}

// Validation Events
class ValidateAttendanceFormEvent extends AttendanceEvent {
  const ValidateAttendanceFormEvent();
}

class ValidateTimeAndLocationEvent extends AttendanceEvent {
  final ShiftType shiftType;
  final String guardLocation;
  final String currentLocation;
  final UserRole userRole;

  const ValidateTimeAndLocationEvent({
    required this.shiftType,
    required this.guardLocation,
    required this.currentLocation,
    required this.userRole,
  });

  @override
  List<Object> get props =>
      [shiftType, guardLocation, currentLocation, userRole];
}

// Submission Events
class SubmitAttendanceEvent extends AttendanceEvent {
  final AttendanceType type;
  final ShiftType shiftType;
  final String userId;
  final String userName;
  final String guardLocation;

  const SubmitAttendanceEvent({
    required this.type,
    required this.shiftType,
    required this.userId,
    required this.userName,
    required this.guardLocation,
  });

  @override
  List<Object> get props => [type, shiftType, userId, userName, guardLocation];
}

// History Events
class LoadAttendanceHistoryEvent extends AttendanceEvent {
  final String userId;

  const LoadAttendanceHistoryEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

// Reset Events
class ResetAttendanceFormEvent extends AttendanceEvent {
  const ResetAttendanceFormEvent();
}

class ClearAttendanceErrorEvent extends AttendanceEvent {
  const ClearAttendanceErrorEvent();
}
