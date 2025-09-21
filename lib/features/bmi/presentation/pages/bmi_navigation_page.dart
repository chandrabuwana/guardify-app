import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/di/injection.dart';
import '../bloc/bmi_bloc.dart';
import 'bmi_page.dart';

/// Navigation wrapper untuk BMI page yang menghandle user role
class BMINavigationPage extends StatelessWidget {
  const BMINavigationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get arguments from navigation
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // Default values if no arguments provided
    final String userId = arguments?['userId'] ?? '1';
    final UserRole userRole = arguments?['userRole'] ?? UserRole.anggota;

    return BlocProvider<BMIBloc>(
      create: (context) => getIt<BMIBloc>(),
      child: BMIPage(
        userId: userId,
        userRole: userRole,
      ),
    );
  }
}
