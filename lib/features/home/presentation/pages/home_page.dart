import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import '../widgets/shift_card.dart';
import '../widgets/task_card.dart';
import '../widgets/menu_grid.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/panic_button_widget.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/design/colors.dart';
import '../../../attendance/presentation/pages/check_in_page.dart';
import '../../../bmi/presentation/pages/bmi_navigation_page.dart';
import '../../../panic_button/presentation/pages/panic_verification_page.dart';
import '../../../panic_button/presentation/bloc/panic_button_bloc.dart';
import '../../../company_regulations/presentation/pages/company_regulations_page.dart';
import '../../../company_regulations/presentation/bloc/document_bloc.dart';
import '../../../patrol/presentation/pages/patrol_detail_page.dart';
import '../../../patrol/presentation/bloc/patrol_bloc.dart';
import '../../../patrol/domain/entities/patrol_route.dart';
import '../../../patrol/domain/entities/patrol_location.dart';
import '../../../profile/presentation/pages/profile_screen.dart';
import '../../../test_result/presentation/pages/test_result_page.dart';
import '../../../chat/presentation/pages/chat_list_page.dart';
import '../../../chat/presentation/bloc/chat_bloc.dart';
import '../../../news/presentation/pages/news_list_page.dart';
import '../../../news/presentation/bloc/news_bloc.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/security/security_manager.dart';

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

class _HomePageView extends StatefulWidget {
  const _HomePageView();

  @override
  State<_HomePageView> createState() => __HomePageViewState();
}

class __HomePageViewState extends State<_HomePageView> {
  Timer? _timer;
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    });
  }

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
                backgroundColor: primaryColor,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }

          // Handle navigation
          if (state.navigationRoute != null &&
              state.navigationRoute!.isNotEmpty) {
            switch (state.navigationRoute) {
              case '/attendance':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckInPage(
                      userId: state.navigationArguments?['userId'] ?? '1',
                      namaPersonil:
                          state.navigationArguments?['userName'] ?? 'User',
                    ),
                  ),
                );
                break;
              case '/bmi':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BMINavigationPage(),
                    settings: RouteSettings(
                      arguments: {
                        'userId': state.navigationArguments?['userId'] ?? '2',
                        'userRole':
                            state.navigationArguments?['userRole'] ?? 'danton',
                      },
                    ),
                  ),
                );
                break;
              case '/panic-verification':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => getIt<PanicButtonBloc>(),
                      child: const PanicVerificationPage(),
                    ),
                  ),
                );
                break;
              case '/regulations':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => getIt<DocumentBloc>(),
                      child: const CompanyRegulationsPage(),
                    ),
                  ),
                );
                break;
              case '/patrol':
                // Create mock patrol route data
                final mockPatrolRoute = PatrolRoute(
                  id: '1',
                  name: 'Patroli Rute A',
                  description: '4 Lokasi',
                  date: DateTime.now(),
                  locations: const [
                    PatrolLocation(
                      id: '1',
                      name: 'Pos Macan',
                      description: 'Lokasi 1',
                      latitude: -6.2088,
                      longitude: 106.8456,
                      address: 'Jl. Sudirman No. 1',
                      status: PatrolLocationStatus.pending,
                    ),
                    PatrolLocation(
                      id: '2',
                      name: 'Pos Macan',
                      description: 'Lokasi 2',
                      latitude: -6.2089,
                      longitude: 106.8457,
                      address: 'Jl. Sudirman No. 2',
                      status: PatrolLocationStatus.completed,
                      proofImagePath: 'bukti.jpg',
                    ),
                    PatrolLocation(
                      id: '3',
                      name: 'Pos Macan',
                      description: 'Lokasi 3',
                      latitude: -6.2090,
                      longitude: 106.8458,
                      address: 'Jl. Sudirman No. 3',
                      status: PatrolLocationStatus.pending,
                    ),
                    PatrolLocation(
                      id: '4',
                      name: 'Pos Macan',
                      description: 'Lokasi 4',
                      latitude: -6.2091,
                      longitude: 106.8459,
                      address: 'Jl. Sudirman No. 4',
                      status: PatrolLocationStatus.pending,
                    ),
                  ],
                  additionalLocations: const [
                    PatrolLocation(
                      id: 'add1',
                      name: 'Patroli Tambahan',
                      description: '1 Lokasi',
                      latitude: -6.2092,
                      longitude: 106.8460,
                      address: 'Jl. Tambahan No. 1',
                      status: PatrolLocationStatus.pending,
                      isAdditional: true,
                    ),
                  ],
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => getIt<PatrolBloc>(),
                      child: PatrolDetailPage(route: mockPatrolRoute),
                    ),
                  ),
                );
                break;
              case '/cuti':
                Navigator.pushNamed(context, '/cuti');
                break;
              case '/laporan-kegiatan':
                Navigator.pushNamed(
                  context,
                  '/laporan-kegiatan',
                  arguments: {
                    'userId': state.navigationArguments?['userId'] ?? 'user_1',
                    'userRole':
                        state.navigationArguments?['userRole'] ?? 'anggota',
                  },
                );
                break;
              case '/test-result':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestResultPage(
                      userId: state.navigationArguments?['userId'] ?? 'user_1',
                      userRole:
                          state.navigationArguments?['userRole'] as UserRole? ??
                              UserRole.anggota,
                    ),
                  ),
                );
                break;
              case '/chat':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => getIt<ChatBloc>(),
                      child: const ChatListPage(),
                    ),
                  ),
                );
                // Clear navigation route after navigation
                context.read<HomeBloc>().add(const ClearNavigationEvent());
                break;
              case '/news':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => getIt<NewsBloc>(),
                      child: const NewsListPage(),
                    ),
                  ),
                );
                // Clear navigation route after navigation
                context.read<HomeBloc>().add(const ClearNavigationEvent());
                break;
              default:
                // For other routes, show snackbar instead of navigating
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Fitur "${state.navigationRoute}" sedang dalam pengembangan'),
                    backgroundColor: primaryColor,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                break;
            }
          }

          // Handle panic dialog
          if (state.showPanicDialog) {
            _showPanicDialog();
          }
        }
      },
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: primaryColor),
            ),
          );
        }

        if (state is HomeError) {
          return Scaffold(
            body: Center(
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
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: primaryColor),
            ),
          );
        }

        return Scaffold(
          backgroundColor: neutral10,
          body: SafeArea(
            child: Column(
              children: [
                // App Header
                _buildAppHeader(state.userProfile),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.verticalSpace,

                        // Shift Card
                        ShiftCard(
                          attendanceInfo: state.attendanceInfo,
                          teamMembersImages: _getTeamMembersImages(),
                          onWorkButtonPressed: () {
                            if (!state.attendanceInfo.isCheckedIn) {
                              // Navigate directly to check-in form (mulai bekerja)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckInPage(
                                    userId: '1',
                                    namaPersonil: state.userProfile.name,
                                  ),
                                ),
                              );
                            } else {
                              // Handle check-out directly
                              context
                                  .read<HomeBloc>()
                                  .add(const AttendanceToggleEvent());
                            }
                          },
                        ),

                        24.verticalSpace,

                        // Today's Tasks Section
                        _buildTodayTasksSection(state.todayTasks),

                        24.verticalSpace,

                        // Menu Grid
                        MenuGrid(
                          menuItems: _buildMenuItems(),
                        ),

                        24.verticalSpace,

                        // Panic Button Widget
                        PanicButtonWidget(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => getIt<PanicButtonBloc>(),
                                  child: const PanicVerificationPage(),
                                ),
                              ),
                            );
                          },
                        ),

                        80.verticalSpace, // Bottom padding for bottom nav
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: CustomBottomNav(
            currentIndex: state.currentBottomNavIndex,
            onTap: (index) {
              context.read<HomeBloc>().add(BottomNavigationTappedEvent(index));
            },
          ),
        );
      },
    );
  }

  Widget _buildAppHeader(UserProfile userProfile) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        children: [
          // Time and Profile Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Time
              Text(
                _currentTime,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),

              // Profile Avatar
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20.r),
                  onTap: () => _navigateToProfile(context, userProfile),
                  child: Container(
                    padding: EdgeInsets.all(
                        2.r), // Small padding for better tap area
                    child: CircleAvatar(
                      radius: 20.r,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      backgroundImage: userProfile.profileImageUrl != null
                          ? NetworkImage(userProfile.profileImageUrl!)
                          : null,
                      child: userProfile.profileImageUrl == null
                          ? Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 24.sp,
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            ],
          ),

          16.verticalSpace,

          // Greeting and Name
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userProfile.greeting,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                4.verticalSpace,
                Text(
                  userProfile.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayTasksSection(List<TaskItem> tasks) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tugas Hari Ini',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: neutral90,
            ),
          ),
          16.verticalSpace,
          ...tasks.map((task) => TaskCard(
                task: task,
                onTap: () {
                  // Handle patrol task navigation
                  if (task.id.startsWith('patrol')) {
                    context.read<HomeBloc>().add(const NavigateToPatrolEvent());
                  } else {
                    context.read<HomeBloc>().add(
                          ShowSnackbarEvent('Membuka tugas: ${task.title}'),
                        );
                  }
                },
              )),
        ],
      ),
    );
  }

  List<MenuItem> _buildMenuItems() {
    return [
      MenuItem(
        id: 'incident',
        title: 'Insiden Kejadian',
        icon: Icons.report_problem,
        hasNotification: true,
        onTap: () =>
            context.read<HomeBloc>().add(const NavigateToIncidentReportEvent()),
      ),
      MenuItem(
        id: 'attendance_recap',
        title: 'Rekapitulasi Kehadiran',
        icon: Icons.assignment,
        onTap: () => context
            .read<HomeBloc>()
            .add(const NavigateToAttendanceRecapEvent()),
      ),
      MenuItem(
        id: 'activity_report',
        title: 'Laporan Kegiatan',
        icon: Icons.description,
        onTap: () =>
            context.read<HomeBloc>().add(const NavigateToActivityReportEvent()),
      ),
      MenuItem(
        id: 'bmi',
        title: 'Body Mass Index (BMI)',
        icon: Icons.monitor_weight,
        onTap: () => context.read<HomeBloc>().add(const NavigateToBMIEvent()),
      ),
      MenuItem(
        id: 'test_result',
        title: 'Hasil Ujian',
        icon: Icons.quiz,
        hasNotification: true,
        onTap: () =>
            context.read<HomeBloc>().add(const NavigateToTestResultEvent()),
      ),
      MenuItem(
        id: 'leave_request',
        title: 'Pengajuan Cuti',
        icon: Icons.calendar_month,
        onTap: () =>
            context.read<HomeBloc>().add(const NavigateToLeaveRequestEvent()),
      ),
      MenuItem(
        id: 'regulations',
        title: 'Peraturan Perusahaan',
        icon: Icons.gavel,
        onTap: () =>
            context.read<HomeBloc>().add(const NavigateToRegulationsEvent()),
      ),
      MenuItem(
        id: 'emergency_history',
        title: 'Riwayat Tombol Darurat',
        icon: Icons.history,
        onTap: () => context
            .read<HomeBloc>()
            .add(const NavigateToEmergencyHistoryEvent()),
      ),
      MenuItem(
        id: 'disaster_info',
        title: 'Informasi Bencana',
        icon: Icons.info,
        onTap: () =>
            context.read<HomeBloc>().add(const NavigateToDisasterInfoEvent()),
      ),
      MenuItem(
        id: 'news',
        title: 'Berita',
        icon: Icons.article,
        hasNotification: true,
        onTap: () => context.read<HomeBloc>().add(const NavigateToNewsEvent()),
      ),
    ];
  }

  List<String> _getTeamMembersImages() {
    // Mock team members images
    return [
      '', // Empty for default avatar
      '', // Empty for default avatar
      '', // Empty for default avatar
      '', // Empty for default avatar
    ];
  }

  void _showPanicDialog() {
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
                    color: primaryColor,
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
                  'TOMBOL DARURAT',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                8.verticalSpace,
                Text(
                  'Apakah anda yakin ingin mengaktifkan Panic Button? Pastikan situasi darurat yang terjadi valid',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: neutral70,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                24.verticalSpace,

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'Batal',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.read<HomeBloc>().add(
                                const ShowSnackbarEvent(
                                    'Tombol darurat telah diaktifkan!'),
                              );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'Ya, Aktifkan',
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

  /// Navigate to Profile screen when profile avatar is tapped
  void _navigateToProfile(BuildContext context, UserProfile userProfile) async {
    // Get user ID from secure storage
    final userId = await SecurityManager.readSecurely(AppConstants.userIdKey);

    if (!context.mounted) return;

    if (userId == null || userId.isEmpty) {
      // If no user ID, show error and logout
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User ID tidak ditemukan. Silakan login kembali.'),
          backgroundColor: Colors.red,
        ),
      );
      // Navigate to login
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          userId: userId, // Real user ID from secure storage
        ),
      ),
    );
  }
}
