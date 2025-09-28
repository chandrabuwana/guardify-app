import 'package:equatable/equatable.dart';

// Task Model
class TaskItem {
  final String id;
  final String title;
  final String subtitle;
  final double progress;
  final int completedTasks;
  final int totalTasks;
  final bool isCompleted;

  const TaskItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.completedTasks,
    required this.totalTasks,
    this.isCompleted = false,
  });

  TaskItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    double? progress,
    int? completedTasks,
    int? totalTasks,
    bool? isCompleted,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      progress: progress ?? this.progress,
      completedTasks: completedTasks ?? this.completedTasks,
      totalTasks: totalTasks ?? this.totalTasks,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

// User Profile Model
class UserProfile {
  final String name;
  final String position;
  final String greeting;
  final String? profileImageUrl;

  const UserProfile({
    required this.name,
    required this.position,
    required this.greeting,
    this.profileImageUrl,
  });

  UserProfile copyWith({
    String? name,
    String? position,
    String? greeting,
    String? profileImageUrl,
  }) {
    return UserProfile(
      name: name ?? this.name,
      position: position ?? this.position,
      greeting: greeting ?? this.greeting,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}

// Attendance Model
class AttendanceInfo {
  final bool isCheckedIn;
  final String currentTime;
  final String shift;
  final String position;
  final DateTime date;

  const AttendanceInfo({
    required this.isCheckedIn,
    required this.currentTime,
    required this.shift,
    required this.position,
    required this.date,
  });

  AttendanceInfo copyWith({
    bool? isCheckedIn,
    String? currentTime,
    String? shift,
    String? position,
    DateTime? date,
  }) {
    return AttendanceInfo(
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
      currentTime: currentTime ?? this.currentTime,
      shift: shift ?? this.shift,
      position: position ?? this.position,
      date: date ?? this.date,
    );
  }
}

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final int currentBottomNavIndex;
  final String? snackbarMessage;
  final bool showPanicDialog;
  final UserProfile userProfile;
  final AttendanceInfo attendanceInfo;
  final List<TaskItem> todayTasks;
  final String? navigationRoute;
  final Map<String, dynamic>? navigationArguments;

  const HomeLoaded({
    required this.currentBottomNavIndex,
    required this.userProfile,
    required this.attendanceInfo,
    required this.todayTasks,
    this.snackbarMessage,
    this.showPanicDialog = false,
    this.navigationRoute,
    this.navigationArguments,
  });

  HomeLoaded copyWith({
    int? currentBottomNavIndex,
    String? snackbarMessage,
    bool? showPanicDialog,
    UserProfile? userProfile,
    AttendanceInfo? attendanceInfo,
    List<TaskItem>? todayTasks,
    String? navigationRoute,
    Map<String, dynamic>? navigationArguments,
    bool clearSnackbar = false,
    bool clearNavigation = false,
  }) {
    return HomeLoaded(
      currentBottomNavIndex:
          currentBottomNavIndex ?? this.currentBottomNavIndex,
      snackbarMessage:
          clearSnackbar ? null : (snackbarMessage ?? this.snackbarMessage),
      showPanicDialog: showPanicDialog ?? this.showPanicDialog,
      userProfile: userProfile ?? this.userProfile,
      attendanceInfo: attendanceInfo ?? this.attendanceInfo,
      todayTasks: todayTasks ?? this.todayTasks,
      navigationRoute:
          clearNavigation ? null : (navigationRoute ?? this.navigationRoute),
      navigationArguments: clearNavigation
          ? null
          : (navigationArguments ?? this.navigationArguments),
    );
  }

  @override
  List<Object> get props => [
        currentBottomNavIndex,
        snackbarMessage ?? '',
        showPanicDialog,
        userProfile,
        attendanceInfo,
        todayTasks,
        navigationRoute ?? '',
        navigationArguments ?? {},
      ];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
