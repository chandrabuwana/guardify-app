import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/di/injection.dart';
import '../bloc/bmi_bloc.dart';
import 'bmi_page.dart';

/// Navigation wrapper untuk BMI page yang menghandle user role
class BMINavigationPage extends StatelessWidget {
  const BMINavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get arguments from navigation
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // Default values if no arguments provided
    final String userId = arguments?['userId'] ?? '1';

    // Convert String userRole to UserRole enum
    final String userRoleString = arguments?['userRole'] ?? 'anggota';
    final UserRole userRole = UserRole.fromValue(userRoleString);

    // Cek apakah bloc sudah ada di context
    try {
      final existingBloc = context.read<BMIBloc>();
      // Jika bloc sudah ada, gunakan BlocProvider.value
      print('✅ BMINavigationPage: Using existing BMIBloc from context');
      return BlocProvider.value(
        value: existingBloc,
        child: BMIPage(
          userId: userId,
          userRole: userRole,
        ),
      );
    } catch (e) {
      // Jika bloc belum ada, buat baru dengan key untuk memastikan tidak dibuat ulang
      print('🔄 BMINavigationPage: Creating new BMIBloc instance');
      return BlocProvider<BMIBloc>(
        key: const ValueKey('bmi_bloc_provider_navigation'), // Key untuk memastikan tidak dibuat ulang
        create: (context) => getIt<BMIBloc>(),
        child: BMIPage(
          userId: userId,
          userRole: userRole,
        ),
      );
    }
  }
}
