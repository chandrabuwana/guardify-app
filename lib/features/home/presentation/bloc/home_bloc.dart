import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/security/security_manager.dart';
import '../../../../core/utils/user_role_helper.dart';
import '../../../patrol/domain/usecases/get_patrol_routes_paginated.dart';
import '../../../patrol/domain/entities/patrol_location.dart';
import '../../../schedule/domain/usecases/get_current_shift.dart';
import '../../../schedule/domain/repositories/schedule_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetPatrolRoutesPaginated _getPatrolRoutesPaginated;
  final GetCurrentShift _getCurrentShift;

  HomeBloc(this._getPatrolRoutesPaginated, this._getCurrentShift) : super(const HomeInitial()) {
    on<HomeInitialEvent>(_onHomeInitial);
    on<BottomNavigationTappedEvent>(_onBottomNavigationTapped);
    on<ShowSnackbarEvent>(_onShowSnackbar);
    on<ClearNavigationEvent>(_onClearNavigation);
    on<PanicButtonPressedEvent>(_onPanicButtonPressed);

    // Attendance Events
    on<AttendanceToggleEvent>(_onAttendanceToggle);
    on<AttendanceCheckInEvent>(_onAttendanceCheckIn);
    on<AttendanceCheckOutEvent>(_onAttendanceCheckOut);
    on<NavigateToAttendanceScreenEvent>(_onNavigateToAttendanceScreen);

    // Navigation Events
    on<NavigateToActivityReportEvent>(_onNavigateToActivityReport);
    on<NavigateToIncidentReportEvent>(_onNavigateToIncidentReport);
    on<NavigateToAttendanceRecapEvent>(_onNavigateToAttendanceRecap);
    on<NavigateToBMIEvent>(_onNavigateToBMI);
    on<NavigateToTestResultEvent>(_onNavigateToTestResult);
    on<NavigateToLeaveRequestEvent>(_onNavigateToLeaveRequest);
    on<NavigateToRegulationsEvent>(_onNavigateToRegulations);
    on<NavigateToPatrolEvent>(_onNavigateToPatrol);
    on<NavigateToEmergencyHistoryEvent>(_onNavigateToEmergencyHistory);
    on<NavigateToDisasterInfoEvent>(_onNavigateToDisasterInfo);

    // Tasks Events
    on<LoadTodayTasksEvent>(_onLoadTodayTasks);
    on<LoadPatrolTasksEvent>(_onLoadPatrolTasks);
    on<TaskProgressUpdateEvent>(_onTaskProgressUpdate);

    // Profile Events
    on<LoadUserProfileEvent>(_onLoadUserProfile);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
  }

  void _onHomeInitial(HomeInitialEvent event, Emitter<HomeState> emit) async {
    // Get user role from secure storage
    final userRole = await UserRoleHelper.getUserRole();
    
    print('');
    print('🏠 ========================================');
    print('🏠 HOME BLOC - INITIALIZATION');
    print('🏠 ========================================');
    print('🏠 Loaded user role: ${userRole.displayName}');
    print('🏠 User role value: ${userRole.value}');
    print('🏠 Is Pengawas: ${userRole == UserRole.pengawas}');
    print('🏠 ========================================');
    print('');
    
    // Initialize with default data
    final userProfile = UserProfile(
      name: 'Arsyada Rahmasyah',
      position: 'Security',
      greeting: _getGreeting(),
    );

    // Get user ID for API calls
    final userId = await SecurityManager.readSecurely(AppConstants.userIdKey) ?? '';

    // Load current shift from API
    final currentShiftResult = await _getCurrentShift(userId: userId);
    
    AttendanceInfo attendanceInfo;
    if (currentShiftResult.isSuccess && currentShiftResult.currentShift != null) {
      final shift = currentShiftResult.currentShift!;
      // Format checkin time or show "-" if not checked in
      final checkinTime = shift.checkin && shift.checkinTime != null
          ? _formatTime(shift.checkinTime!)
          : '-';
      
      attendanceInfo = AttendanceInfo(
        isCheckedIn: shift.checkin,
        isCheckedOut: shift.checkout,
        currentTime: checkinTime,
        shift: shift.name,
        position: 'Security', // Position might need to come from another API
        date: DateTime.now(),
      );
    } else {
      // Fallback to default if API fails
      attendanceInfo = AttendanceInfo(
        isCheckedIn: false,
        isCheckedOut: false,
        currentTime: _getCurrentTime(),
        shift: 'Shift Pagi - Pos Gajah',
        position: 'Security',
        date: DateTime.now(),
      );
    }

    emit(HomeLoaded(
      currentBottomNavIndex: 0,
      userProfile: userProfile,
      attendanceInfo: attendanceInfo,
      todayTasks: [],
      isLoadingPatrolTasks: true,
      userRole: userRole, // Add user role to state
      currentShift: currentShiftResult.isSuccess ? currentShiftResult.currentShift : null,
    ));

    // Load patrol tasks from API
    add(const LoadPatrolTasksEvent());
  }

  String _formatTime(String timeString) {
    try {
      // Parse time string like "07:00:00" and format to "07:00"
      final parts = timeString.split(':');
      if (parts.length >= 2) {
        return '${parts[0]}:${parts[1]}';
      }
      return timeString;
    } catch (e) {
      return timeString;
    }
  }

  void _onBottomNavigationTapped(
    BottomNavigationTappedEvent event,
    Emitter<HomeState> emit,
  ) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;

      String message;
      String? navigationRoute;
      switch (event.index) {
              case 0:
                message = 'Beranda';
                navigationRoute = '/';
                break;        case 1:
          message = 'Jadwal';
          navigationRoute = '/schedule';
          break;
        case 2:
          message = 'Pesan';
          navigationRoute = '/chat';
          break;
        case 3:
          message = 'Notifikasi';
          break;
        default:
          message = 'Menu';
      }

      emit(currentState.copyWith(
        currentBottomNavIndex: event.index,
        snackbarMessage: message,
        navigationRoute: navigationRoute,
      ));
    }
  }

  void _onShowSnackbar(ShowSnackbarEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(snackbarMessage: event.message));
    }
  }

  void _onClearNavigation(ClearNavigationEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(
        navigationRoute: null,
      ));
    }
  }

  void _onPanicButtonPressed(
    PanicButtonPressedEvent event,
    Emitter<HomeState> emit,
  ) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(showPanicDialog: true));
    }
  }

  // Attendance Event Handlers
  void _onAttendanceToggle(
      AttendanceToggleEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final newAttendance = currentState.attendanceInfo.copyWith(
        isCheckedIn: !currentState.attendanceInfo.isCheckedIn,
        currentTime: _getCurrentTime(),
      );

      final message = newAttendance.isCheckedIn
          ? 'Berhasil Check In'
          : 'Berhasil Check Out';

      emit(currentState.copyWith(
        attendanceInfo: newAttendance,
        snackbarMessage: message,
      ));
    }
  }

  void _onAttendanceCheckIn(
      AttendanceCheckInEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final newAttendance = currentState.attendanceInfo.copyWith(
        isCheckedIn: true,
        currentTime: _getCurrentTime(),
      );

      emit(currentState.copyWith(
        attendanceInfo: newAttendance,
        snackbarMessage: 'Berhasil Check In',
      ));
    }
  }

  void _onAttendanceCheckOut(
      AttendanceCheckOutEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final newAttendance = currentState.attendanceInfo.copyWith(
        isCheckedIn: false,
        isCheckedOut: true,
        currentTime: _getCurrentTime(),
      );

      emit(currentState.copyWith(
        attendanceInfo: newAttendance,
        snackbarMessage: 'Berhasil Check Out',
      ));
    }
  }

  void _onNavigateToAttendanceScreen(
      NavigateToAttendanceScreenEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(
        navigationRoute: '/attendance',
        navigationArguments: {
          'attendanceType': 'clockIn',
          'shiftType': 'morning',
          'userId': '1',
          'userName': currentState.userProfile.name,
          'guardLocation': 'Pos Utama',
        },
      ));
    }
  }

  // Navigation Event Handlers
  void _onNavigateToActivityReport(
      NavigateToActivityReportEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(
        snackbarMessage: 'Membuka Laporan Kegiatan...',
        navigationRoute: '/laporan-kegiatan',
        navigationArguments: {
          'userId': 'user_1',
          'userRole': 'anggota',
        },
      ));
    }
  }

  void _onNavigateToIncidentReport(
      NavigateToIncidentReportEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(
        snackbarMessage: 'Navigating to Laporan Kejadian...',
        navigationRoute: '/incident-report',
      ));
    }
  }

  void _onNavigateToAttendanceRecap(
      NavigateToAttendanceRecapEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(
        snackbarMessage: 'Navigating to Rekapitulasi Kehadiran...',
        navigationRoute: '/attendance-recap',
      ));
    }
  }

  Future<void> _onNavigateToBMI(
      NavigateToBMIEvent event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;

      // Get user ID and role from secure storage
      final userId =
          await SecurityManager.readSecurely(AppConstants.userIdKey) ??
              'unknown';
      final userRoleId =
          await SecurityManager.readSecurely('user_role_id') ?? 'AGT';

      emit(currentState.copyWith(
        snackbarMessage: 'Navigating to BMI Calculator...',
        navigationRoute: '/bmi',
        navigationArguments: {
          'userId': userId,
          'userRole': userRoleId,
        },
      ));
    }
  }

  void _onNavigateToTestResult(
      NavigateToTestResultEvent event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      
      // Get real user ID and role ID from secure storage
      final userId = await SecurityManager.readSecurely(AppConstants.userIdKey);
      final roleId = await SecurityManager.readSecurely('user_role_id');
      
      print('');
      print('🏠 ========================================');
      print('🏠 HOME BLOC: NAVIGATE TO TEST RESULT');
      print('🏠 ========================================');
      print('🏠 UserId from secure storage: $userId');
      print('🏠 RoleId from secure storage: $roleId');
      print('🏠 User position: ${currentState.userProfile.position}');
      print('🏠 ========================================');
      print('');
      
      // Get UserRole from role ID (DTN, AGT, PJO, etc.)
      final userRole = roleId != null 
          ? UserRole.fromValue(roleId)
          : _getUserRoleFromPosition(currentState.userProfile.position);
      
      print('🏠 Resolved UserRole: ${userRole.displayName} (${userRole.value})');
      print('🏠 ========================================');
      print('');

      emit(currentState.copyWith(
        snackbarMessage: 'Navigating to Hasil Ujian...',
        navigationRoute: '/test-result',
        navigationArguments: {
          'userId': userId, // Real user ID from secure storage
          'userRole': userRole,
        },
      ));
    }
  }

  UserRole _getUserRoleFromPosition(String position) {
    // Simple mapping from position string to UserRole enum
    if (position.toLowerCase().contains('pjo') ||
        position.toLowerCase().contains('deputy')) {
      return UserRole.pjo;
    } else if (position.toLowerCase().contains('danton')) {
      return UserRole.danton;
    } else if (position.toLowerCase().contains('pengawas')) {
      return UserRole.pengawas;
    }
    return UserRole.anggota;
  }

  void _onNavigateToLeaveRequest(
      NavigateToLeaveRequestEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(
        snackbarMessage: 'Navigating to Pengajuan Cuti...',
        navigationRoute: '/cuti',
      ));
    }
  }

  void _onNavigateToRegulations(
      NavigateToRegulationsEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(
        snackbarMessage: 'Navigating to Peraturan Perusahaan...',
        navigationRoute: '/regulations',
      ));
    }
  }

  void _onNavigateToPatrol(
      NavigateToPatrolEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(
        snackbarMessage: 'Navigating to Patroli...',
        navigationRoute: '/patrol',
      ));
    }
  }

  void _onNavigateToEmergencyHistory(
      NavigateToEmergencyHistoryEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(
        snackbarMessage: 'Navigating to Riwayat Tombol Darurat...',
        navigationRoute: '/emergency-history',
      ));
    }
  }

  void _onNavigateToDisasterInfo(
      NavigateToDisasterInfoEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(
        snackbarMessage: 'Navigating to Informasi Bencana...',
        navigationRoute: '/news',
      ));
    }
  }

  // Tasks Event Handlers
  void _onLoadTodayTasks(LoadTodayTasksEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final tasks = _getInitialTasks();

      emit(currentState.copyWith(
        todayTasks: tasks,
        snackbarMessage: 'Tugas hari ini berhasil dimuat',
      ));
    }
  }

  Future<void> _onLoadPatrolTasks(
      LoadPatrolTasksEvent event, Emitter<HomeState> emit) async {
    if (state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;

    try {
      // Set loading state
      emit(currentState.copyWith(isLoadingPatrolTasks: true));

      // Fetch patrol routes from API
      final result = await _getPatrolRoutesPaginated.call(
        page: 1,
        pageSize: 10,
      );

      result.fold(
        (failure) {
          print('Failed to load patrol tasks: ${failure.message}');
          // On failure, use fallback tasks
          emit(currentState.copyWith(
            todayTasks: _getInitialTasks(),
            isLoadingPatrolTasks: false,
          ));
        },
        (paginatedResponse) {
          print(
              'Successfully loaded ${paginatedResponse.data.length} patrol routes');

          // Store patrol routes
          final patrolRoutes = paginatedResponse.data;

          // Convert patrol routes to task items
          final patrolTasks = paginatedResponse.data.map((route) {
            final totalLocations =
                route.locations.length + route.additionalLocations.length;
            final completedLocations = route.locations
                    .where(
                        (loc) => loc.status == PatrolLocationStatus.completed)
                    .length +
                route.additionalLocations
                    .where(
                        (loc) => loc.status == PatrolLocationStatus.completed)
                    .length;
            final progress =
                totalLocations > 0 ? completedLocations / totalLocations : 0.0;

            return TaskItem(
              id: 'patrol_${route.id}',
              title: route.name,
              subtitle: '$totalLocations Lokasi',
              progress: progress,
              completedTasks: completedLocations,
              totalTasks: totalLocations,
            );
          }).toList();

          print('Converted to ${patrolTasks.length} task items');

          emit(currentState.copyWith(
            todayTasks: patrolTasks,
            isLoadingPatrolTasks: false,
            patrolRoutes: patrolRoutes,
          ));
        },
      );
    } catch (e) {
      print('Error loading patrol tasks: $e');
      // On error, use fallback tasks
      emit(currentState.copyWith(
        todayTasks: _getInitialTasks(),
        isLoadingPatrolTasks: false,
      ));
    }
  }

  void _onTaskProgressUpdate(
      TaskProgressUpdateEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final updatedTasks = currentState.todayTasks.map((task) {
        if (task.id == event.taskId) {
          return task.copyWith(progress: event.progress);
        }
        return task;
      }).toList();

      emit(currentState.copyWith(
        todayTasks: updatedTasks,
        snackbarMessage: 'Progress tugas berhasil diperbarui',
      ));
    }
  }

  // Profile Event Handlers
  void _onLoadUserProfile(LoadUserProfileEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(
        snackbarMessage: 'Profil pengguna berhasil dimuat',
      ));
    }
  }

  void _onUpdateUserProfile(
      UpdateUserProfileEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final updatedProfile = currentState.userProfile.copyWith(
        name: event.userName,
        position: event.position,
        profileImageUrl: event.profileImageUrl,
      );

      emit(currentState.copyWith(
        userProfile: updatedProfile,
        snackbarMessage: 'Profil berhasil diperbarui',
      ));
    }
  }

  // Helper Methods
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Selamat Pagi';
    } else if (hour < 15) {
      return 'Selamat Siang';
    } else if (hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}.${now.minute.toString().padLeft(2, '0')}';
  }

  List<TaskItem> _getInitialTasks() {
    return [
      const TaskItem(
        id: 'patrol_a',
        title: 'Patroli Rute A',
        subtitle: '5 Lokasi Rute + 1 Lokasi Tambahan',
        progress: 0.66,
        completedTasks: 4,
        totalTasks: 6,
      ),
      const TaskItem(
        id: 'patrol_continue',
        title: 'Tugas Lanjutan',
        subtitle: '1 Belum Selesai, 0 Terverifikasi',
        progress: 0.75,
        completedTasks: 3,
        totalTasks: 4,
      ),
    ];
  }

  // Public methods for external use
  void clearSnackbar() {
    add(const ShowSnackbarEvent(''));
  }

  void clearNavigation() {
    // Navigation clearing is handled in the UI layer
  }

  void hidePanicDialog() {
    add(const ShowSnackbarEvent(''));
  }
}
