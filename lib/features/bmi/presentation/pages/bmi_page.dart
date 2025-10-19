import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/di/injection.dart';
import '../bloc/bmi_bloc.dart';
import 'bmi_detail_page.dart';
import 'bmi_list_page.dart';
import '../../../../shared/widgets/app_scaffold.dart';

/// Main BMI page yang mengarahkan ke page yang sesuai berdasarkan role user
class BMIPage extends StatelessWidget {
  final String userId;
  final UserRole userRole;

  const BMIPage({
    Key? key,
    required this.userId,
    required this.userRole,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BMIBloc>(
      create: (context) => getIt<BMIBloc>(),
      child: userRole.isAnggota
          ? _BMIDetailWrapper(userId: userId, userRole: userRole)
          : BMIListPage(currentUserRole: userRole),
    );
  }
}

/// Wrapper untuk load user profile dan redirect ke detail page (untuk anggota)
class _BMIDetailWrapper extends StatefulWidget {
  final String userId;
  final UserRole userRole;

  const _BMIDetailWrapper({
    required this.userId,
    required this.userRole,
  });

  @override
  State<_BMIDetailWrapper> createState() => _BMIDetailWrapperState();
}

class _BMIDetailWrapperState extends State<_BMIDetailWrapper> {
  @override
  void initState() {
    super.initState();
    // Load user profile hanya sekali saat pertama kali dibuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<BMIBloc>();
      final state = bloc.state;
      // Hanya load jika belum ada data dan tidak sedang loading
      if (state.currentUserProfile == null && !state.isLoading) {
        bloc.add(BMIGetUserProfile(widget.userId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BMIBloc, BMIState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const AppScaffold(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state.hasError) {
          return AppScaffold(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<BMIBloc>()
                          .add(BMIGetUserProfile(widget.userId));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state.currentUserProfile == null) {
          return const AppScaffold(
            child: Center(
              child: Text('User profile not found'),
            ),
          );
        }

        // Redirect ke detail page dengan user profile yang sudah diload
        return BMIDetailPage(
          userProfile: state.currentUserProfile!,
          currentUserRole: widget.userRole,
        );
      },
    );
  }
}
