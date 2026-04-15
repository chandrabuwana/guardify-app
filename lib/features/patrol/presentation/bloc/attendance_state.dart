part of 'attendance_bloc.dart';

abstract class AttendanceState {
  const AttendanceState();
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceSubmitted extends AttendanceState {
  final String message;

  const AttendanceSubmitted(this.message);
}

class LocationVerified extends AttendanceState {
  final bool isVerified;
  final String message;

  const LocationVerified({
    required this.isVerified,
    required this.message,
  });
}

class CurrentLocationLoaded extends AttendanceState {
  final String address;

  const CurrentLocationLoaded(this.address);
}

class ImageUploaded extends AttendanceState {
  final String imageUrl;

  const ImageUploaded(this.imageUrl);
}

class AttendanceError extends AttendanceState {
  final String message;

  const AttendanceError(this.message);
}