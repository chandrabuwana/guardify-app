import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/security/security_manager.dart';
import '../../../../core/utils/user_role_helper.dart';
import '../../../patrol/domain/usecases/get_patrol_routes_paginated.dart';
import '../../../patrol/domain/entities/patrol_location.dart';
import '../../../schedule/domain/usecases/get_current_shift.dart';
import '../../../schedule/domain/usecases/get_current_task.dart';
import '../../../schedule/domain/usecases/get_shift_now.dart';
import '../../../schedule/domain/repositories/schedule_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetPatrolRoutesPaginated _getPatrolRoutesPaginated;
  final GetCurrentShift _getCurrentShift;
  final GetCurrentTask _getCurrentTask;
  final GetShiftNow _getShiftNow;

  HomeBloc(this._getPatrolRoutesPaginated, this._getCurrentShift, this._getCurrentTask, this._getShiftNow) : super(const HomeInitial()) {
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
    on<LoadCurrentTaskEvent>(_onLoadCurrentTask);
    on<TaskProgressUpdateEvent>(_onTaskProgressUpdate);

    // Profile Events
    on<LoadUserProfileEvent>(_onLoadUserProfile);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
  }

  void _onHomeInitial(HomeInitialEvent event, Emitter<HomeState> emit) async {
    // Get user role from secure storage
    final userRole = await UserRoleHelper.getUserRole();
    final savedFullName = await SecurityManager.readSecurely('user_fullname');
    
    // print('');
    // print('🏠 ========================================');
    // print('🏠 HOME BLOC - INITIALIZATION');
    // print('🏠 ========================================');
    // print('🏠 Loaded user full name: $savedFullName');
    // print('🏠 Loaded user role: ${userRole.displayName}');
    // print('🏠 User role value: ${userRole.value}');
    // print('🏠 Is Pengawas: ${userRole == UserRole.pengawas}');
    // print('🏠 ========================================');
    // print('');
    
    // Initialize with default data
    final userProfile = UserProfile(
      name: (savedFullName != null && savedFullName.trim().isNotEmpty)
          ? savedFullName.trim()
          : 'User',
      position: 'Security',
      greeting: _getGreeting(),
    );

    // Get user ID for API calls
    final userId = await SecurityManager.readSecurely(AppConstants.userIdKey) ?? '';

    // For pengawas, use get_shift_now endpoint
    // For other roles, use get_current endpoint
    ShiftNowData? shiftNow;
    CurrentShiftData? currentShift;
    AttendanceInfo attendanceInfo;

    if (userRole == UserRole.pengawas) {
      // Load shift now from API for pengawas
      print('');
      print('🏠 Loading shift now from API (pengawas)...');
      final shiftNowResult = await _getShiftNow();
      print('🏠 Shift now result:');
      print('  - isSuccess: ${shiftNowResult.isSuccess}');
      print('  - hasData: ${shiftNowResult.shiftNow != null}');
      if (shiftNowResult.shiftNow != null) {
        print('  - shiftName: ${shiftNowResult.shiftNow!.shiftName}');
        print('  - totalPersonel: ${shiftNowResult.shiftNow!.totalPersonel}');
        print('  - totalAttendance: ${shiftNowResult.shiftNow!.totalAttendance}');
        shiftNow = shiftNowResult.shiftNow;
      }

      // Parse ShiftDate from get_shift_now response
      DateTime shiftDate;
      if (shiftNowResult.isSuccess && shiftNowResult.shiftNow != null) {
        final shift = shiftNowResult.shiftNow!;
        try {
          shiftDate = DateTime.parse(shift.shiftDate);
        } catch (e) {
          shiftDate = DateTime.now();
        }

        attendanceInfo = AttendanceInfo(
          isCheckedIn: false, // Pengawas doesn't have checkin/checkout
          isCheckedOut: false,
          currentTime: _getCurrentTime(),
          shift: shift.shiftName,
          position: 'Pengawas',
          date: shiftDate,
          hasShift: true,
        );
      } else {
        attendanceInfo = AttendanceInfo(
          isCheckedIn: false,
          isCheckedOut: false,
          currentTime: _getCurrentTime(),
          shift: 'Tidak ada shift hari ini',
          position: 'Pengawas',
          date: DateTime.now(),
          hasShift: false,
        );
      }
    } else {
      // Load current shift from API for other roles
      print('');
      print('🏠 Loading current shift from API...');
      final currentShiftResult = await _getCurrentShift(userId: userId);
      print('🏠 Current shift result:');
      print('  - isSuccess: ${currentShiftResult.isSuccess}');
      print('  - hasData: ${currentShiftResult.currentShift != null}');
      if (currentShiftResult.currentShift != null) {
        print('  - shift.id: ${currentShiftResult.currentShift!.id}');
        print('  - shift.idShiftDetail: ${currentShiftResult.currentShift!.idShiftDetail}');
        print('  - shift.name: ${currentShiftResult.currentShift!.name}');
      }
      currentShift = currentShiftResult.isSuccess ? currentShiftResult.currentShift : null;

      if (currentShiftResult.isSuccess && currentShiftResult.currentShift != null) {
        final shift = currentShiftResult.currentShift!;
        
        // Save shift id to storage for use in AttendanceDetail/insert
        if (shift.id.isNotEmpty) {
          await SecurityManager.storeSecurely(
            AppConstants.shiftDetailIdKey,
            shift.id,
          );
          print('🏠 ✅ Saved shift id to storage: ${shift.id}');
        }
        
        // Format checkin time with date and time or show "-" if not checked in
        String checkinTime;
        if (shift.checkin && shift.checkinTime != null) {
          try {
            // Parse checkinTime from API (format: 2025-12-22T21:34:28.9226071)
            final checkinDateTime = DateTime.parse(shift.checkinTime!);
            checkinTime = _formatDateTime(checkinDateTime);
          } catch (e) {
            // If parsing fails, use time only as fallback
            checkinTime = _formatTime(shift.checkinTime!);
          }
        } else {
          checkinTime = '-';
        }
        
        // Parse ShiftDate from get_current response, fallback to DateTime.now() if not available
        DateTime shiftDate;
        if (shift.shiftDate != null && shift.shiftDate!.isNotEmpty) {
          try {
            shiftDate = DateTime.parse(shift.shiftDate!);
          } catch (e) {
            // If parsing fails, use current date as fallback
            shiftDate = DateTime.now();
          }
        } else {
          shiftDate = DateTime.now();
        }
        
        attendanceInfo = AttendanceInfo(
          isCheckedIn: shift.checkin,
          isCheckedOut: shift.checkout,
          currentTime: checkinTime,
          shift: shift.name,
          position: 'Security', // Position might need to come from another API
          date: shiftDate,
          hasShift: true, // There is shift data available
        );
      } else {
        // No shift data available - hide work button
        attendanceInfo = AttendanceInfo(
          isCheckedIn: false,
          isCheckedOut: false,
          currentTime: _getCurrentTime(),
          shift: 'Tidak ada shift hari ini',
          position: 'Security',
          date: DateTime.now(),
          hasShift: false, // No shift data available
        );
      }
    }

    emit(HomeLoaded(
      currentBottomNavIndex: 0,
      userProfile: userProfile,
      attendanceInfo: attendanceInfo,
      todayTasks: [],
      isLoadingPatrolTasks: true,
      userRole: userRole, // Add user role to state
      currentShift: currentShift,
      shiftNow: shiftNow,
    ));

    // Load current task if we have shift data (only for non-pengawas roles)
    if (userRole != UserRole.pengawas) {
      print('');
      print('🏠 Checking if we should load current task...');
      final currentState = state as HomeLoaded;
      final hasShift = currentState.currentShift != null;
      print('  - currentShift != null: $hasShift');
      
      if (hasShift) {
        final shift = currentState.currentShift!;
      print('🏠 ✅ Shift data available, preparing to load current task');
      
      // Try to get idShiftDetail, fallback to id if idShiftDetail is null
      // Ensure we always have a non-null value
      final String shiftDetailId = shift.idShiftDetail != null && shift.idShiftDetail!.isNotEmpty
          ? shift.idShiftDetail!
          : shift.id;
      
      if (shift.idShiftDetail != null && shift.idShiftDetail!.isNotEmpty) {
        print('🏠 ✅ Using idShiftDetail: $shiftDetailId');
      } else {
        print('🏠 ⚠️ idShiftDetail is null, using id as fallback: $shiftDetailId');
      }
      
      print('🏠 📋 Dispatching LoadCurrentTaskEvent with shiftDetailId: $shiftDetailId');
      // Use Future.microtask to ensure event is processed after state is emitted
      Future.microtask(() {
        print('🏠 📋 Executing microtask to dispatch LoadCurrentTaskEvent');
        add(LoadCurrentTaskEvent(idShiftDetail: shiftDetailId));
        print('🏠 ✅ Event dispatched in microtask');
      });
      } else {
        print('🏠 ⚠️ No shift data available');
        print('🏠 No shift data - updating state to show empty tasks');
        // Update state to show empty tasks (card will still appear with "Tidak ada tugas hari ini")
        // State was already emitted above, so we can safely use copyWith
        emit(currentState.copyWith(
          todayTasks: [], // Empty tasks - card will show "Tidak ada tugas hari ini"
          isLoadingPatrolTasks: false, // Stop loading so card appears
        ));
        print('🏠 ✅ State updated - card "Tugas Hari Ini" will appear with empty message');
      }
    } else {
      // For pengawas, don't load current task
      print('🏠 ⚠️ Pengawas role - skipping current task load');
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(
        todayTasks: [],
        isLoadingPatrolTasks: false,
      ));
    }
    print('');
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

  String _formatDateTime(DateTime dateTime) {
    final months = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];

    // Format: "22 Desember 2025 - 21:34"
    final dateStr = '${dateTime.day} ${months[dateTime.month]} ${dateTime.year}';
    final timeStr = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    
    return '$dateStr - $timeStr';
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
        snackbarMessage: 'Navigating to Body Mass Index Calculator...',
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

  Future<void> _onLoadCurrentTask(
      LoadCurrentTaskEvent event, Emitter<HomeState> emit) async {
    print('');
    print('📋 ========================================');
    print('📋 EVENT RECEIVED: LoadCurrentTaskEvent');
    print('📋 ========================================');
    print('📋 idShiftDetail: ${event.idShiftDetail}');
    
    if (state is! HomeLoaded) {
      print('📋 ❌ State is not HomeLoaded, returning');
      print('📋 Current state: ${state.runtimeType}');
      print('📋 ========================================');
      print('');
      return;
    }

    final currentState = state as HomeLoaded;
    print('📋 ✅ State is HomeLoaded, proceeding...');

    try {
      print('');
      print('📋 ========================================');
      print('📋 HOME BLOC - LOADING CURRENT TASK');
      print('📋 ========================================');
      print('📋 idShiftDetail: ${event.idShiftDetail}');
      print('📋 ========================================');
      print('');

      // Set loading state
      emit(currentState.copyWith(isLoadingPatrolTasks: true));

      // Fetch current task from API
      print('📋 Calling get_current_task API...');
      final result = await _getCurrentTask.call(
        idShiftDetail: event.idShiftDetail,
      );
      
      print('📋 API Response received:');
      print('  - isSuccess: ${result.isSuccess}');
      print('  - hasData: ${result.currentTask != null}');

      if (result.isSuccess && result.currentTask != null) {
        final taskData = result.currentTask!;
        
        print('📋 Task data loaded:');
        print('  - ListRoute count: ${taskData.listRoute.length}');
        print('  - ListCarryOver count: ${taskData.listCarryOver.length}');

        // Convert ListRoute to TaskItem for "Tugas Patroli"
        final routeTasks = taskData.listRoute.map((route) {
          final isCompleted = route.status.toUpperCase() == 'SELESAI' || 
                             route.status.toUpperCase() == 'DONE';
          
          return TaskItem(
            id: 'patrol_${route.idAreas}', // Use patrol_ prefix for patrol tasks
            title: route.areasName,
            subtitle: 'Patroli - Status: ${route.status}',
            progress: isCompleted ? 1.0 : 0.0,
            completedTasks: isCompleted ? 1 : 0,
            totalTasks: 1,
            isCompleted: isCompleted,
          );
        }).toList();

        // Convert ListCarryOver to TaskItem for "Tugas Lanjutan"
        final carryOverTasks = taskData.listCarryOver.map((carryOver) {
          final isOpen = carryOver.status.toUpperCase() == 'OPEN';
          
          return TaskItem(
            id: 'patrol_continue', // Special ID for carry-over tasks
            title: carryOver.reportNote.isNotEmpty ? carryOver.reportNote : 'Tugas Lanjutan',
            subtitle: 'Tugas Lanjutan - Status: ${carryOver.status}',
            progress: isOpen ? 0.0 : 1.0,
            completedTasks: isOpen ? 0 : 1,
            totalTasks: 1,
            isCompleted: !isOpen,
          );
        }).toList();

        // Combine route tasks and carry over tasks
        final allTasks = [...routeTasks, ...carryOverTasks];

        print('📋 ✅ Loaded ${routeTasks.length} route tasks and ${carryOverTasks.length} carry over tasks');
        
        // Create summary tasks for better overview
        final List<TaskItem> summaryTasks = [];
        
        // Add patrol summary if there are patrol routes
        if (routeTasks.isNotEmpty) {
          final completedPatrols = routeTasks.where((task) => task.isCompleted).length;
          final totalPatrols = routeTasks.length;
          
          summaryTasks.add(TaskItem(
            id: 'patrol_summary',
            title: 'Patroli',
            subtitle: '$completedPatrols dari $totalPatrols area selesai',
            progress: totalPatrols > 0 ? completedPatrols / totalPatrols : 0.0,
            completedTasks: completedPatrols,
            totalTasks: totalPatrols,
            isCompleted: completedPatrols == totalPatrols,
          ));
        }
        
        // Always add "Tugas Lanjutan" card (only 1 card with summary), even if list is empty
        if (carryOverTasks.isNotEmpty) {
          // Calculate summary for carry-over tasks
          final openTasks = carryOverTasks.where((task) => !task.isCompleted).length;
          final totalTasks = carryOverTasks.length;
          final completedTasks = carryOverTasks.where((task) => task.isCompleted).length;
          
          // Add only 1 summary card for "Tugas Lanjutan" (no individual task cards)
          summaryTasks.add(TaskItem(
            id: 'patrol_continue',
            title: 'Tugas Lanjutan',
            subtitle: totalTasks > 1 
                ? '$openTasks belum selesai, $completedTasks selesai dari $totalTasks tugas'
                : openTasks > 0 
                    ? '1 tugas belum selesai'
                    : '1 tugas selesai',
            progress: totalTasks > 0 ? completedTasks / totalTasks : 0.0,
            completedTasks: completedTasks,
            totalTasks: totalTasks,
            isCompleted: openTasks == 0,
          ));
          
          // DO NOT add individual carry-over tasks as separate cards
          // Only show 1 summary card regardless of how many tasks are in the list
        } else {
          // Add empty "Tugas Lanjutan" card when list is empty
          summaryTasks.add(TaskItem(
            id: 'patrol_continue',
            title: 'Tugas Lanjutan',
            subtitle: 'Tidak ada tugas lanjutan',
            progress: 1.0, // 100% karena tidak ada tugas
            completedTasks: 0,
            totalTasks: 0,
            isCompleted: true, // Completed karena tidak ada tugas yang perlu dikerjakan
          ));
        }
        
        print('📋 Total summary tasks: ${summaryTasks.length}');
        print('📋 ========================================');
        print('');
        
        // Use summary tasks for display, but keep all tasks for detailed view
        emit(currentState.copyWith(
          todayTasks: summaryTasks.isNotEmpty ? summaryTasks : allTasks,
          isLoadingPatrolTasks: false,
          currentTask: taskData,
        ));
      } else {
        print('📋 ❌ Failed to load current task');
        print('  - isSuccess: ${result.isSuccess}');
        print('  - hasData: ${result.currentTask != null}');
        if (result.failure != null) {
          print('  - failure: ${result.failure}');
        }
        print('📋 ========================================');
        print('');
        
        // On failure, use fallback or empty
        emit(currentState.copyWith(
          todayTasks: [],
          isLoadingPatrolTasks: false,
        ));
      }
    } catch (e, stackTrace) {
      print('📋 ❌ Error loading current task: $e');
      print('📋 Stack trace: $stackTrace');
      print('📋 ========================================');
      print('');
      
      emit(currentState.copyWith(
        todayTasks: [],
        isLoadingPatrolTasks: false,
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
