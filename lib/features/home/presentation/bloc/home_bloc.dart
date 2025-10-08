import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/enums.dart';
import 'home_event.dart';
import 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitial()) {
    on<HomeInitialEvent>(_onHomeInitial);
    on<BottomNavigationTappedEvent>(_onBottomNavigationTapped);
    on<ShowSnackbarEvent>(_onShowSnackbar);
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
    on<TaskProgressUpdateEvent>(_onTaskProgressUpdate);

    // Profile Events
    on<LoadUserProfileEvent>(_onLoadUserProfile);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
  }

  void _onHomeInitial(HomeInitialEvent event, Emitter<HomeState> emit) {
    // Initialize with default data
    final userProfile = UserProfile(
      name: 'Arsyada Rahmasyah',
      position: 'Security',
      greeting: _getGreeting(),
    );

    final attendanceInfo = AttendanceInfo(
      isCheckedIn: false,
      currentTime: _getCurrentTime(),
      shift: 'Shift Pagi - Pos Gajah',
      position: 'Security',
      date: DateTime.now(),
    );

    final todayTasks = _getInitialTasks();

    emit(HomeLoaded(
      currentBottomNavIndex: 0,
      userProfile: userProfile,
      attendanceInfo: attendanceInfo,
      todayTasks: todayTasks,
    ));
  }

  void _onBottomNavigationTapped(
    BottomNavigationTappedEvent event,
    Emitter<HomeState> emit,
  ) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;

      String message;
      switch (event.index) {
        case 0:
          message = 'Beranda';
          break;
        case 1:
          message = 'Pesan';
          break;
        case 2:
          message = 'Notifikasi';
          break;
        case 3:
          message = 'Profil';
          break;
        default:
          message = 'Menu';
      }

      emit(currentState.copyWith(
        currentBottomNavIndex: event.index,
        snackbarMessage: message,
      ));
    }
  }

  void _onShowSnackbar(ShowSnackbarEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(snackbarMessage: event.message));
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

  void _onNavigateToBMI(NavigateToBMIEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(
        snackbarMessage: 'Navigating to BMI Calculator...',
        navigationRoute: '/bmi',
        navigationArguments: {
          'userId': '2',
          'userRole': 'danton',
        },
      ));
    }
  }

  void _onNavigateToTestResult(
      NavigateToTestResultEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      // Determine role from position
      final userRole = _getUserRoleFromPosition(currentState.userProfile.position);
      
      emit(currentState.copyWith(
        snackbarMessage: 'Navigating to Hasil Ujian...',
        navigationRoute: '/test-result',
        navigationArguments: {
          'userId': 'user_1', // Mock user ID
          'userRole': userRole,
        },
      ));
    }
  }
  
  UserRole _getUserRoleFromPosition(String position) {
    // Simple mapping from position string to UserRole enum
    if (position.toLowerCase().contains('pjo') || position.toLowerCase().contains('deputy')) {
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
        navigationRoute: '/disaster-info',
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
