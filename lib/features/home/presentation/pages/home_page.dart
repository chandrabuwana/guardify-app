import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/home_header_widget.dart';
import '../widgets/weather_info_section.dart';
import '../widgets/panic_button_widget.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/report_section.dart';
import '../widgets/quick_actions_section.dart';
import '../../../../shared/widgets/custom_bottom_navigation.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import 'panic_verification_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.grey[50],
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const HomeHeaderWidget(
                    greeting: 'Selamat Pagi!',
                    userName: 'Gilang William',
                    subtitle: 'Security',
                  ),

                  const SizedBox(height: 20),

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

                  const SizedBox(height: 20),

                  // Panic Button
                  PanicButtonWidget(
                    onPressed: () {
                      _showPanicDialog();
                    },
                  ),

                  const SizedBox(height: 24),

                  // Calendar
                  const CalendarWidget(),

                  const SizedBox(height: 24),

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

                  const SizedBox(height: 24),

                  // Quick Actions
                  QuickActionsSection(
                    onRecapTap: () {
                      context.read<HomeBloc>().add(
                          const ShowSnackbarEvent('Rekapitulasi Kehadiran'));
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

                  const SizedBox(height: 100), // Space for bottom navigation
                ],
              ),
            ),
          ),
          bottomNavigationBar: CustomBottomNavigation(
            currentIndex: state.currentBottomNavIndex,
            onTap: (index) {
              context.read<HomeBloc>().add(BottomNavigationTappedEvent(index));
            },
          ),
        );
      },
    );
  }

  void _showPanicDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: const Text(
                      'X',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Warning icon
              SizedBox(
                width: 80,
                height: 80,
                child: CustomPaint(
                  painter: WarningTrianglePainter(),
                  size: const Size(80, 80),
                ),
              ),

              const SizedBox(height: 20),

              // Main text
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(text: 'Apakah anda yakin ingin\nmengaktifkan '),
                    TextSpan(
                      text: 'Panic Button',
                      style: TextStyle(
                        color: Color(0xFFE74C3C),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: '?'),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Sub text
              const Text(
                'Pastikan situasi darurat yang\nterjadi valid',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 30),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE74C3C),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Kembali',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const PanicVerificationPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE74C3C),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'YA',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WarningTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE74C3C)
      ..style = PaintingStyle.fill;

    final path = Path();

    // Create a triangle shape
    final double width = size.width * 0.8;
    final double height = size.height * 0.7;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // Move to top point
    path.moveTo(centerX, centerY - height / 2);
    // Line to bottom right
    path.lineTo(centerX + width / 2, centerY + height / 2);
    // Line to bottom left
    path.lineTo(centerX - width / 2, centerY + height / 2);
    // Close the path
    path.close();

    canvas.drawPath(path, paint);

    // Draw exclamation mark
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '!',
        style: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        centerX - textPainter.width / 2,
        centerY - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
