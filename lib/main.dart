import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
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
import 'core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
          },
          initialRoute: '/',
        );
      },
    );
  }
}
