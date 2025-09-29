import 'package:equatable/equatable.dart';
import '../../domain/entities/attendance.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {
  const AttendanceInitial();
}

class AttendanceLoading extends AttendanceState {
  const AttendanceLoading();
}

class AttendanceFormState extends AttendanceState {
  final String personalClothing;
  final String securityReport;
  final String photoPath;
  final String currentLocation;
  final double? latitude;
  final double? longitude;
  final String patrolRoute;
  final bool isFormValid;
  final Map<String, String> fieldErrors;
  final bool isLocationDetected;
  final bool isTimeValid;
  final String? validationMessage;

  const AttendanceFormState({
    this.personalClothing = '',
    this.securityReport = '',
    this.photoPath = '',
    this.currentLocation = '',
    this.latitude,
    this.longitude,
    this.patrolRoute = '',
    this.isFormValid = false,
    this.fieldErrors = const {},
    this.isLocationDetected = false,
    this.isTimeValid = false,
    this.validationMessage,
  });

  AttendanceFormState copyWith({
    String? personalClothing,
    String? securityReport,
    String? photoPath,
    String? currentLocation,
    double? latitude,
    double? longitude,
    String? patrolRoute,
    bool? isFormValid,
    Map<String, String>? fieldErrors,
    bool? isLocationDetected,
    bool? isTimeValid,
    String? validationMessage,
    bool clearPhoto = false,
    bool clearValidationMessage = false,
  }) {
    return AttendanceFormState(
      personalClothing: personalClothing ?? this.personalClothing,
      securityReport: securityReport ?? this.securityReport,
      photoPath: clearPhoto ? '' : (photoPath ?? this.photoPath),
      currentLocation: currentLocation ?? this.currentLocation,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      patrolRoute: patrolRoute ?? this.patrolRoute,
      isFormValid: isFormValid ?? this.isFormValid,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      isLocationDetected: isLocationDetected ?? this.isLocationDetected,
      isTimeValid: isTimeValid ?? this.isTimeValid,
      validationMessage: clearValidationMessage
          ? null
          : (validationMessage ?? this.validationMessage),
    );
  }

  @override
  List<Object?> get props => [
        personalClothing,
        securityReport,
        photoPath,
        currentLocation,
        latitude,
        longitude,
        patrolRoute,
        isFormValid,
        fieldErrors,
        isLocationDetected,
        isTimeValid,
        validationMessage,
      ];
}

class AttendanceValidationSuccess extends AttendanceState {
  final String message;

  const AttendanceValidationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class AttendanceValidationError extends AttendanceState {
  final String message;

  const AttendanceValidationError(this.message);

  @override
  List<Object> get props => [message];
}

class AttendanceSubmissionLoading extends AttendanceState {
  const AttendanceSubmissionLoading();
}

class AttendanceSubmissionSuccess extends AttendanceState {
  final Attendance attendance;
  final String message;

  const AttendanceSubmissionSuccess({
    required this.attendance,
    this.message = 'Check In Berhasil\nSelamat Bekerja!',
  });

  @override
  List<Object> get props => [attendance, message];
}

class AttendanceSubmissionError extends AttendanceState {
  final String message;

  const AttendanceSubmissionError(this.message);

  @override
  List<Object> get props => [message];
}

class AttendanceStatusLoaded extends AttendanceState {
  final bool hasCheckedIn;
  final Attendance? currentAttendance;

  const AttendanceStatusLoaded({
    required this.hasCheckedIn,
    this.currentAttendance,
  });

  @override
  List<Object?> get props => [hasCheckedIn, currentAttendance];
}

class AttendanceHistoryLoaded extends AttendanceState {
  final List<Attendance> attendanceHistory;

  const AttendanceHistoryLoaded(this.attendanceHistory);

  @override
  List<Object> get props => [attendanceHistory];
}

class AttendanceError extends AttendanceState {
  final String message;

  const AttendanceError(this.message);

  @override
  List<Object> get props => [message];
}
