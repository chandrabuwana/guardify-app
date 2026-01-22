import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/pages/reset_password_page.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/panic_button/presentation/pages/panic_verification_page.dart';
import 'features/panic_button/presentation/pages/panic_disaster_confirmation_page.dart';
import 'features/panic_button/presentation/pages/panic_disaster_selection_page.dart';
import 'features/panic_button/presentation/pages/panic_incident_form_page.dart';
import 'features/panic_button/presentation/pages/panic_security_form_page.dart';
import 'features/panic_button/presentation/pages/panic_confirmation_page.dart';
import 'features/panic_button/presentation/pages/panic_button_history_page.dart';
import 'features/panic_button/presentation/bloc/panic_button_bloc.dart';
import 'features/bmi/presentation/pages/bmi_navigation_page.dart';
import 'features/profile/presentation/pages/profile_screen.dart';
import 'features/cuti/presentation/pages/cuti_page.dart';
import 'features/cuti/presentation/pages/form_ajuan_cuti_page.dart';
import 'features/cuti/presentation/pages/detail_cuti_page.dart';
import 'features/laporan_kegiatan/presentation/pages/laporan_kegiatan_page.dart';
import 'features/laporan_kegiatan/presentation/bloc/laporan_kegiatan_bloc.dart';
import 'features/laporan_kejadian/presentation/pages/incident_list_page.dart';
import 'features/laporan_kejadian/presentation/bloc/incident_bloc.dart';
import 'features/chat/presentation/pages/chat_list_page.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';
import 'features/news/presentation/pages/news_list_page.dart';
import 'features/news/presentation/bloc/news_bloc.dart';
import 'features/schedule/presentation/pages/schedule_page.dart';
import 'features/schedule/presentation/pages/schedule_pjo_deputy_page.dart';
import 'features/schedule/presentation/bloc/schedule_bloc.dart';
import 'features/tugas_lanjutan/presentation/pages/tugas_lanjutan_page.dart';
import 'features/tugas_lanjutan/presentation/bloc/tugas_lanjutan_bloc.dart';
import 'core/constants/enums.dart';
import 'core/constants/app_constants.dart';
import 'core/security/security_manager.dart';
import 'core/di/injection.dart';
import 'core/design/colors.dart';
import 'core/services/background_location_task.dart';
import 'core/services/push_notification_service.dart';
import 'shared/widgets/api_log_overlay_button.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isMobile = Platform.isAndroid || Platform.isIOS;
  if (isMobile) {
    try {
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
      await PushNotificationService.instance.initialize();
    } catch (e) {
      print('⚠️ [Main] Firebase init failed: $e');
    }
  }

  // Initialize date formatting for Indonesian locale
  await initializeDateFormatting('id_ID', null);

  await configureDependencies();
  
  // Initialize background location update service
  // Temporarily disabled due to Kotlin 2.1.0 compatibility issue with workmanager 0.5.2
  // TODO: Update workmanager to 0.9.0+3 when ready
  try {
    await BackgroundLocationTaskManager.initialize();
    await BackgroundLocationTaskManager.registerPeriodicTask();
  } catch (e) {
    print('⚠️ [Main] Failed to initialize workmanager: $e');
    print('⚠️ [Main] Background location updates will be disabled');
  }
  
  runApp(const GuardifyApp());
}

class GuardifyApp extends StatefulWidget {
  const GuardifyApp({super.key});

  @override
  State<GuardifyApp> createState() => _GuardifyAppState();
}

class _GuardifyAppState extends State<GuardifyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone 11 Pro design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Guardify App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFE74C3C),
              brightness: Brightness.light,
            ),
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 0,
            ),
          ),
          builder: (context, child) {
            return Stack(
              children: [
                child ?? const SizedBox.shrink(),
                ApiLogOverlayButton(navigatorKey: navigatorKey),
              ],
            );
          },
          routes: {
            '/': (context) => const _AuthGate(),
            '/home': (context) => const HomePage(),
            '/login': (context) => BlocProvider(
                  create: (context) => getIt<AuthBloc>(),
                  child: const LoginPage(),
                ),
            '/register': (context) => BlocProvider(
                  create: (context) => getIt<AuthBloc>(),
                  child: const RegisterPage(),
                ),
            '/reset-password': (context) => BlocProvider(
                  create: (context) => getIt<AuthBloc>(),
                  child: const ResetPasswordPage(),
                ),
            '/bmi': (context) => const BMINavigationPage(),
            '/panic-verification': (context) => BlocProvider(
                  create: (context) => getIt<PanicButtonBloc>(),
                  child: const PanicVerificationPage(),
                ),
            '/panic-disaster-confirmation': (context) =>
                const PanicDisasterConfirmationPage(),
            '/panic-disaster-selection': (context) =>
                const PanicDisasterSelectionPage(),
            '/panic-incident-form': (context) => BlocProvider(
                  create: (context) => getIt<PanicButtonBloc>(),
                  child: const PanicIncidentFormPage(),
                ),
            '/panic-security-form': (context) => BlocProvider(
                  create: (context) => getIt<PanicButtonBloc>(),
                  child: const PanicSecurityFormPage(),
                ),
            '/panic-confirmation': (context) => BlocProvider(
                  create: (context) => getIt<PanicButtonBloc>(),
                  child: const PanicConfirmationPage(),
                ),
            '/panic-button-history': (context) => BlocProvider(
                  create: (context) => getIt<PanicButtonBloc>(),
                  child: const PanicButtonHistoryPage(),
                ),
            '/profile': (context) {
              // Get user ID from arguments or secure storage
              final arguments = ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
              final String userId = arguments?['userId'] ?? 'current_user';

              return ProfileScreen(userId: userId);
            },
            '/cuti': (context) => const CutiPage(),
            '/cuti/form': (context) {
              final arguments = ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
              return FormAjuanCutiPage(
                userId: arguments?['userId'] ?? 'current_user',
                userName: arguments?['userName'] ?? 'User',
              );
            },
            '/laporan-kegiatan': (context) {
              return FutureBuilder<String?>(
                future: SecurityManager.readSecurely('user_role_id'),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final roleId = snapshot.data ?? 'AGT';
                  final userRole = UserRole.fromValue(roleId);

                  // Check if user has access (semua role selain anggota)
                  if (userRole == UserRole.anggota) {
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text('Akses Ditolak'),
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.block,
                              size: 64,
                              color: errorColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Akses Ditolak',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Anda tidak memiliki akses ke halaman ini.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                              ),
                              child: const Text('Kembali'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final arguments = ModalRoute.of(context)?.settings.arguments
                      as Map<String, dynamic>?;
                  final String userId = arguments?['userId'] ??
                      (snapshot.data != null ? snapshot.data! : 'current_user');

                  return BlocProvider(
                    create: (context) => getIt<LaporanKegiatanBloc>(),
                    child: LaporanKegiatanPage(
                      userId: userId,
                      userRole: userRole,
                    ),
                  );
                },
              );
            },
            '/cuti/detail': (context) {
              final arguments = ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
              return DetailCutiPage(
                cutiId: arguments['cutiId'] as String,
                currentUserRole: arguments['currentUserRole'] as UserRole? ??
                    UserRole.anggota,
                showActions: arguments['showActions'] as bool? ?? false,
              );
            },
            '/chat': (context) => BlocProvider(
                  create: (context) => getIt<ChatBloc>(),
                  child: const ChatListPage(),
                ),
            '/news': (context) => BlocProvider(
                  create: (context) => getIt<NewsBloc>(),
                  child: const NewsListPage(),
                ),
            '/schedule': (context) {
              return BlocProvider(
                create: (context) => getIt<ScheduleBloc>(),
                child: FutureBuilder<String?>(
                  future: SecurityManager.readSecurely('user_role_id'),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    }
                    
                    final roleId = snapshot.data ?? 'AGT';
                    
                    // PJO, Deputy, dan Pengawas menggunakan halaman schedule khusus
                    if (roleId == 'PJO' || roleId == 'DPT' || roleId == 'PGW') {
                      return const SchedulePJODeputyPage();
                    }
                    
                    // Anggota dan Danton menggunakan halaman schedule asli
                    return const SchedulePage();
                  },
                ),
              );
            },
            '/tugas-lanjutan': (context) {
              final arguments = ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
              final String userId = arguments?['userId'] ?? 'current_user';

              return BlocProvider(
                create: (context) => getIt<TugasLanjutanBloc>(),
                child: TugasLanjutanPage(
                  userId: userId,
                ),
              );
            },
            '/laporan-kejadian': (context) => BlocProvider(
                  create: (context) => getIt<IncidentBloc>(),
                  child: const IncidentListPage(),
                ),
          },
          initialRoute: '/',
        );
      },
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: SecurityManager.readSecurely(AppConstants.tokenKey),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final token = snapshot.data;
        final hasToken = token != null && token.trim().isNotEmpty;

        if (hasToken) {
          return const HomePage();
        }

        return BlocProvider(
          create: (context) => getIt<AuthBloc>(),
          child: const LoginPage(),
        );
      },
    );
  }
}
