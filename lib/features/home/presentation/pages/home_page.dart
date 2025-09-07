import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/home_header_widget.dart';
import '../widgets/weather_info_section.dart';
import '../widgets/panic_button_widget.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/report_section.dart';
import '../widgets/quick_actions_section.dart';
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
        if (state is HomeLoaded &&
            state.snackbarMessage != null &&
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
      },
      builder: (context, state) {
        if (state is! HomeLoaded) {
          return const AppScaffold(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return AppScaffold(
          bottomNavigationBar: CustomBottomNavigation(
            currentIndex: state.currentBottomNavIndex,
            onTap: (index) {
              context.read<HomeBloc>().add(BottomNavigationTappedEvent(index));
            },
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const HomeHeaderWidget(
                greeting: 'Selamat Pagi!',
                userName: 'Gilang William',
                subtitle: 'Security',
              ),

              20.verticalSpace,

              // Weather and Disaster Info
              WeatherInfoSection(
                temperature: '30°C',
                weatherInfo: 'Hari Ini',
                onWeatherTap: () {
                  context
                      .read<HomeBloc>()
                      .add(const ShowSnackbarEvent('Informasi Cuaca'));
                },
                onDisasterInfoTap: () {
                  context
                      .read<HomeBloc>()
                      .add(const ShowSnackbarEvent('Informasi Bencana'));
                },
              ),

              20.verticalSpace,

              // Panic Button
              PanicButtonWidget(
                onPressed: () {
                  _showPanicConfirmationDialog(context);
                },
              ),

              24.verticalSpace,

              // Calendar
              const CalendarWidget(),

              24.verticalSpace,

              // Report Section
              ReportSection(
                onActivityReportTap: () {
                  context
                      .read<HomeBloc>()
                      .add(const ShowSnackbarEvent('Laporan Kegiatan'));
                },
                onIncidentReportTap: () {
                  context
                      .read<HomeBloc>()
                      .add(const ShowSnackbarEvent('Laporan Kejadian'));
                },
                onStartWorkTap: () {
                  context
                      .read<HomeBloc>()
                      .add(const ShowSnackbarEvent('Mulai Bekerja'));
                },
              ),

              24.verticalSpace,

              // Quick Actions
              QuickActionsSection(
                onRecapTap: () {
                  context
                      .read<HomeBloc>()
                      .add(const ShowSnackbarEvent('Rekapitulasi Kehadiran'));
                },
                onSubmissionTap: () {
                  context
                      .read<HomeBloc>()
                      .add(const ShowSnackbarEvent('Pengajuan Cuti'));
                },
                onRegulationTap: () {
                  context
                      .read<HomeBloc>()
                      .add(const ShowSnackbarEvent('Peraturan Perusahaan'));
                },
                onBMITap: () {
                  context
                      .read<HomeBloc>()
                      .add(const ShowSnackbarEvent('BMI Calculator'));
                },
                onTestResultTap: () {
                  context
                      .read<HomeBloc>()
                      .add(const ShowSnackbarEvent('Hasil Ujian'));
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
