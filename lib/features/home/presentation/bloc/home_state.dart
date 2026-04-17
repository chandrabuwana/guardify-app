import 'package:equatable/equatable.dart';
import '../../../../core/constants/enums.dart';
import '../../../patrol/domain/entities/patrol_route.dart';
import '../../../schedule/domain/repositories/schedule_repository.dart';

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
  final bool isCheckedOut;
  final String currentTime;
  final String shift;
  final String position;
  final DateTime date;
  final bool hasShift; // Flag to indicate if there's shift data available
  final bool isOnLeave; // Flag to indicate if user is on leave

  const AttendanceInfo({
    required this.isCheckedIn,
    required this.isCheckedOut,
    required this.currentTime,
    required this.shift,
    required this.position,
    required this.date,
    required this.hasShift,
    this.isOnLeave = false,
  });

  AttendanceInfo copyWith({
    bool? isCheckedIn,
    bool? isCheckedOut,
    String? currentTime,
    String? shift,
    String? position,
    DateTime? date,
    bool? hasShift,
    bool? isOnLeave,
  }) {
    return AttendanceInfo(
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
      isCheckedOut: isCheckedOut ?? this.isCheckedOut,
      currentTime: currentTime ?? this.currentTime,
      shift: shift ?? this.shift,
      position: position ?? this.position,
      date: date ?? this.date,
      hasShift: hasShift ?? this.hasShift,
      isOnLeave: isOnLeave ?? this.isOnLeave,
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
  final bool isLoadingPatrolTasks;
  final List<PatrolRoute> patrolRoutes;
  final UserRole userRole; // Add user role to state
  final CurrentShiftData? currentShift; // Current shift data from API
  final CurrentTaskData? currentTask; // Current task data from API
  final ShiftNowData? shiftNow; // Shift now data for pengawas

  const HomeLoaded({
    required this.currentBottomNavIndex,
    required this.userProfile,
    required this.attendanceInfo,
    required this.todayTasks,
    this.snackbarMessage,
    this.showPanicDialog = false,
    this.navigationRoute,
    this.navigationArguments,
    this.isLoadingPatrolTasks = false,
    this.patrolRoutes = const [],
    this.userRole = UserRole.anggota, // Default to anggota
    this.currentShift,
    this.currentTask,
    this.shiftNow,
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
    bool? isLoadingPatrolTasks,
    List<PatrolRoute>? patrolRoutes,
    UserRole? userRole,
    CurrentShiftData? currentShift,
    CurrentTaskData? currentTask,
    ShiftNowData? shiftNow,
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
      isLoadingPatrolTasks: isLoadingPatrolTasks ?? this.isLoadingPatrolTasks,
      patrolRoutes: patrolRoutes ?? this.patrolRoutes,
      userRole: userRole ?? this.userRole,
      currentShift: currentShift ?? this.currentShift,
      currentTask: currentTask ?? this.currentTask,
      shiftNow: shiftNow ?? this.shiftNow,
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
        isLoadingPatrolTasks,
        patrolRoutes,
        userRole,
        currentShift ?? '',
        currentTask ?? '',
        shiftNow ?? '',
      ];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
