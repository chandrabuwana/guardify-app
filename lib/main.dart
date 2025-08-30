import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  try {
    // await configureDependencies();
    AppLogger.info('Dependencies configured successfully');
  } catch (e) {
    AppLogger.error('Failed to configure dependencies', e);
  }

  runApp(const GuardifyApp());
}

class GuardifyApp extends StatelessWidget {
  const GuardifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            authRepository: MockAuthRepository(),
            loginUseCase: MockLoginUseCase(),
          )..add(const AuthCheckStatusRequested()),
        ),
      ],
      child: MaterialApp(
        title: 'Guardify App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2E7D32),
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 2),
            ),
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2E7D32),
            brightness: Brightness.dark,
          ),
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            switch (state.status) {
              case AuthStatus.authenticated:
                return const HomePage();
              case AuthStatus.unauthenticated:
              case AuthStatus.initial:
              case AuthStatus.error:
              default:
                return const LoginPage();
            }
          },
        ),
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => const HomePage(),
        },
      ),
    );
  }
}

// Temporary implementations
class MockAuthRepository extends AuthRepository {
  @override
  Future<AuthResult> register({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return AuthResult(
      isSuccess: true,
      user: User(
        id: '1',
        email: email,
        name: name,
        phoneNumber: phoneNumber,
      ),
    );
  }

  @override
  Future<AuthResult> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const AuthResult(
      isSuccess: true,
      user: User(
        id: '1',
        email: 'user@example.com',
        name: 'John Doe',
      ),
    );
  }

  @override
  Future<AuthResult> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const AuthResult(isSuccess: true);
  }

  @override
  Future<AuthResult> loginWithBiometric() async {
    await Future.delayed(const Duration(seconds: 1));
    return const AuthResult(isSuccess: true, success: true);
  }

  @override
  Future<AuthResult> loginWithPin(String pin) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const AuthResult(isSuccess: true, success: true);
  }

  @override
  Future<AuthResult> forgotPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    return const AuthResult(isSuccess: true);
  }

  @override
  Future<AuthResult> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return const AuthResult(isSuccess: true);
  }

  @override
  Future<AuthResult> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return const AuthResult(isSuccess: true);
  }

  @override
  Future<bool> isLoggedIn() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return false;
  }

  @override
  Future<bool> hasValidToken() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return false;
  }

  @override
  Future<AuthResult> updateProfile({String? name, String? phoneNumber}) async {
    await Future.delayed(const Duration(seconds: 1));
    return const AuthResult(isSuccess: true);
  }

  @override
  Future<AuthResult> enableBiometric() async {
    await Future.delayed(const Duration(seconds: 1));
    return const AuthResult(isSuccess: true);
  }

  @override
  Future<AuthResult> disableBiometric() async {
    await Future.delayed(const Duration(seconds: 1));
    return const AuthResult(isSuccess: true);
  }

  @override
  Future<AuthResult> setPin(String pin) async {
    await Future.delayed(const Duration(seconds: 1));
    return const AuthResult(isSuccess: true);
  }

  @override
  Future<AuthResult> changePin({
    required String currentPin,
    required String newPin,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return const AuthResult(isSuccess: true);
  }
}

class MockLoginUseCase extends LoginUseCase {
  @override
  Future<AuthResult> call(
      {required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'test@example.com' && password == 'password123') {
      return const AuthResult(isSuccess: true);
    } else {
      return const AuthResult(
        isSuccess: false,
        failure: Failure('Email atau password salah'),
      );
    }
  }
}

// Placeholder pages
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guardify Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.security,
              size: 64,
              color: Colors.green,
            ),
            SizedBox(height: 16),
            Text(
              'Selamat Datang di Guardify!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Aplikasi keamanan Anda',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar'),
      ),
      body: const Center(
        child: Text(
          'Halaman Registrasi\n(Akan dikembangkan)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

// Logger implementation
class AppLogger {
  static void info(String message) {
    print('[INFO] $message');
  }

  static void error(String message, [dynamic error]) {
    print('[ERROR] $message${error != null ? ': $error' : ''}');
  }
}
