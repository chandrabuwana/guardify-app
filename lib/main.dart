import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'features/panic_button/presentation/bloc/panic_button_bloc.dart';
import 'features/bmi/presentation/pages/bmi_navigation_page.dart';
import 'features/profile/presentation/pages/profile_screen.dart';
import 'features/cuti/presentation/pages/cuti_page.dart';
import 'features/cuti/presentation/pages/form_ajuan_cuti_page.dart';
import 'features/cuti/presentation/pages/detail_cuti_page.dart';
import 'features/laporan_kegiatan/presentation/pages/laporan_kegiatan_page.dart';
import 'features/laporan_kegiatan/presentation/bloc/laporan_kegiatan_bloc.dart';
import 'features/chat/presentation/pages/chat_list_page.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';
import 'features/news/presentation/pages/news_list_page.dart';
import 'features/news/presentation/bloc/news_bloc.dart';
import 'features/schedule/presentation/pages/schedule_page.dart';
import 'features/schedule/presentation/bloc/schedule_bloc.dart';
import 'core/constants/enums.dart';
import 'core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting for Indonesian locale
  await initializeDateFormatting('id_ID', null);

  await configureDependencies();
  runApp(const GuardifyApp());
}

class GuardifyApp extends StatelessWidget {
  const GuardifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone 11 Pro design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
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
          routes: {
            '/': (context) => BlocProvider(
                  create: (context) => getIt<AuthBloc>(),
                  child: const LoginPage(),
                ),
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
              final arguments = ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
              final String userId = arguments?['userId'] ?? 'current_user';
              final String userRoleString = arguments?['userRole'] ?? 'anggota';
              final UserRole userRole = UserRole.fromValue(userRoleString);

              return BlocProvider(
                create: (context) => getIt<LaporanKegiatanBloc>(),
                child: LaporanKegiatanPage(
                  userId: userId,
                  userRole: userRole,
                ),
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
            '/schedule': (context) => BlocProvider(
                  create: (context) => getIt<ScheduleBloc>(),
                  child: const SchedulePage(),
                ),
          },
          initialRoute: '/',
        );
      },
    );
  }
}
