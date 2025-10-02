import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeInitialEvent extends HomeEvent {
  const HomeInitialEvent();
}

class BottomNavigationTappedEvent extends HomeEvent {
  final int index;

  const BottomNavigationTappedEvent(this.index);

  @override
  List<Object> get props => [index];
}

class ShowSnackbarEvent extends HomeEvent {
  final String message;

  const ShowSnackbarEvent(this.message);

  @override
  List<Object> get props => [message];
}

class PanicButtonPressedEvent extends HomeEvent {
  const PanicButtonPressedEvent();
}

// Attendance Events
class AttendanceToggleEvent extends HomeEvent {
  const AttendanceToggleEvent();
}

class AttendanceCheckInEvent extends HomeEvent {
  const AttendanceCheckInEvent();
}

class AttendanceCheckOutEvent extends HomeEvent {
  const AttendanceCheckOutEvent();
}

class NavigateToAttendanceScreenEvent extends HomeEvent {
  const NavigateToAttendanceScreenEvent();
}

// Menu Navigation Events
class NavigateToActivityReportEvent extends HomeEvent {
  const NavigateToActivityReportEvent();
}

class NavigateToIncidentReportEvent extends HomeEvent {
  const NavigateToIncidentReportEvent();
}

class NavigateToAttendanceRecapEvent extends HomeEvent {
  const NavigateToAttendanceRecapEvent();
}

class NavigateToBMIEvent extends HomeEvent {
  const NavigateToBMIEvent();
}

class NavigateToTestResultEvent extends HomeEvent {
  const NavigateToTestResultEvent();
}

class NavigateToLeaveRequestEvent extends HomeEvent {
  const NavigateToLeaveRequestEvent();
}

class NavigateToRegulationsEvent extends HomeEvent {
  const NavigateToRegulationsEvent();
}

class NavigateToPatrolEvent extends HomeEvent {
  const NavigateToPatrolEvent();
}

class NavigateToEmergencyHistoryEvent extends HomeEvent {
  const NavigateToEmergencyHistoryEvent();
}

class NavigateToDisasterInfoEvent extends HomeEvent {
  const NavigateToDisasterInfoEvent();
}

// Tasks Events
class LoadTodayTasksEvent extends HomeEvent {
  const LoadTodayTasksEvent();
}

class TaskProgressUpdateEvent extends HomeEvent {
  final String taskId;
  final double progress;

  const TaskProgressUpdateEvent(this.taskId, this.progress);

  @override
  List<Object> get props => [taskId, progress];
}

// User Profile Events
class LoadUserProfileEvent extends HomeEvent {
  const LoadUserProfileEvent();
}

class UpdateUserProfileEvent extends HomeEvent {
  final String userName;
  final String position;
  final String? profileImageUrl;

  const UpdateUserProfileEvent({
    required this.userName,
    required this.position,
    this.profileImageUrl,
  });

  @override
  List<Object> get props => [userName, position, profileImageUrl ?? ''];
}
