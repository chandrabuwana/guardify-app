import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/home_header_widget.dart';
import '../widgets/attendance_card_widget.dart';
import '../widgets/today_tasks_card_widget.dart';
import '../widgets/menu_grid_widget.dart';
import '../widgets/sos_button_widget.dart';
import '../../../../shared/widgets/custom_bottom_navigation.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../../../../core/di/injection.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeBloc>()..add(const HomeInitialEvent()),
      child: const _HomePageView(),
    );
  }
}

class _HomePageView extends StatelessWidget {
  const _HomePageView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeLoaded) {
          // Handle snackbar messages
          if (state.snackbarMessage != null &&
              state.snackbarMessage!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.snackbarMessage!),
                backgroundColor: const Color(0xFFE74C3C),
                behavior: SnackBarBehavior.floating,
              ),
            );
            // Clear snackbar message after showing
            context.read<HomeBloc>().clearSnackbar();
          }

          // Handle navigation
          if (state.navigationRoute != null &&
              state.navigationRoute!.isNotEmpty) {
            if (state.navigationArguments != null) {
              Navigator.pushNamed(
                context,
                state.navigationRoute!,
                arguments: state.navigationArguments,
              );
            } else {
              Navigator.pushNamed(context, state.navigationRoute!);
            }
            // Clear navigation after handling
            context.read<HomeBloc>().clearNavigation();
          }
        }
      },
      builder: (context, state) {
        if (state is HomeLoading) {
          return const AppScaffold(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is HomeError) {
          return AppScaffold(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.r,
                    color: Colors.red,
                  ),
                  16.verticalSpace,
                  Text(
                    'Terjadi kesalahan',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  8.verticalSpace,
                  Text(
                    state.message,
                    style: TextStyle(fontSize: 14.sp),
                    textAlign: TextAlign.center,
                  ),
                  24.verticalSpace,
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeBloc>().add(const HomeInitialEvent());
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is! HomeLoaded) {
          return const AppScaffold(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return AppScaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          enableScrolling: true,
          safeArea: false, // We handle safe area in header
          bottomNavigationBar: CustomBottomNavigation(
            currentIndex: state.currentBottomNavIndex,
            onTap: (index) {
              context.read<HomeBloc>().add(BottomNavigationTappedEvent(index));
            },
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Header with profile info
              HomeHeaderWidget(
                greeting: state.userProfile.greeting,
                userName: state.userProfile.name,
                subtitle: state.userProfile.position,
              ),

              16.verticalSpace,

              // Section 2: Attendance card
              AttendanceCardWidget(
                isCheckedIn: state.attendanceInfo.isCheckedIn,
                shift: state.attendanceInfo.shift,
                position: state.attendanceInfo.position,
                currentTime: state.attendanceInfo.currentTime,
                onTap: () {
                  context.read<HomeBloc>().add(const AttendanceToggleEvent());
                },
              ),

              16.verticalSpace,

              // Section 3: Today's tasks
              TodayTasksCardWidget(
                tasks: state.todayTasks,
                onTaskTap: (taskId) {
                  context
                      .read<HomeBloc>()
                      .add(const ShowSnackbarEvent('Task tapped'));
                },
              ),

              16.verticalSpace,

              // Section 4: Menu grid
              MenuGridWidget(
                onActivityReportTap: () {
                  context
                      .read<HomeBloc>()
                      .add(const NavigateToActivityReportEvent());
                },
                onIncidentReportTap: () {
                  context
                      .read<HomeBloc>()
                      .add(const NavigateToIncidentReportEvent());
                },
                onActivityRecapTap: () {
                  context
                      .read<HomeBloc>()
                      .add(const NavigateToAttendanceRecapEvent());
                },
                onBMITap: () {
                  context.read<HomeBloc>().add(const NavigateToBMIEvent());
                },
                onTestResultTap: () {
                  context
                      .read<HomeBloc>()
                      .add(const NavigateToTestResultEvent());
                },
                onLeaveTap: () {
                  context
                      .read<HomeBloc>()
                      .add(const NavigateToLeaveRequestEvent());
                },
                onRegulationsTap: () {
                  context
                      .read<HomeBloc>()
                      .add(const NavigateToRegulationsEvent());
                },
                onEmergencyHistoryTap: () {
                  context
                      .read<HomeBloc>()
                      .add(const NavigateToEmergencyHistoryEvent());
                },
                onDisasterInfoTap: () {
                  context
                      .read<HomeBloc>()
                      .add(const NavigateToDisasterInfoEvent());
                },
              ),

              24.verticalSpace,

              // Section 5: SOS Emergency Button
              SOSButtonWidget(
                onPressed: () {
                  context.read<HomeBloc>().add(const PanicButtonPressedEvent());
                  _showPanicConfirmationDialog(context);
                },
              ),

              100.verticalSpace, // Space for bottom navigation
            ],
          ),
        );
      },
    );
  }

  void _showPanicConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          content: SizedBox(
            width: 300.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning Icon
                Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE74C3C),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning,
                    color: Colors.white,
                    size: 45.r,
                  ),
                ),
                20.verticalSpace,

                Text(
                  'Apakah anda yakin ingin mengaktifkan Panic Button? Pastikan situasi darurat yang terjadi valid',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                24.verticalSpace,

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Kembali',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushNamed(context, '/panic-verification');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE74C3C),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'YA',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
