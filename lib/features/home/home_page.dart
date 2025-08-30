import 'package:flutter/material.dart';
import 'widgets/home_header_widget.dart';
import 'widgets/weather_info_section.dart';
import 'widgets/panic_button_widget.dart';
import 'widgets/calendar_widget.dart';
import 'widgets/report_section.dart';
import 'widgets/quick_actions_section.dart';
import '../../shared/widgets/custom_bottom_navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentBottomNavIndex = 0;

  // Sample calendar data for January
  final List<List<String>> _januaryWeeks = [
    ['', '1', '2', '3', '4', '5', '6'],
    ['7', '8', '9', '10', '11', '12', '13'],
    ['14', '15', '16', '17', '18', '19', '20'],
    ['21', '22', '23', '24', '25', '26', '27'],
    ['28', '29', '30', '31', '', '', ''],
  ];

  final List<int> _redDates = [1, 8, 15, 22, 29]; // Sundays in red

  @override
  Widget build(BuildContext context) {
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
                  _showSnackbar('Informasi Cuaca');
                },
                onDisasterInfoTap: () {
                  _showSnackbar('Informasi Bencana');
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
              CalendarWidget(
                monthName: 'Januari',
                weekData: _januaryWeeks,
                redDates: _redDates,
              ),

              const SizedBox(height: 24),

              // Report Section
              ReportSection(
                onActivityReportTap: () {
                  _showSnackbar('Laporan Kegiatan');
                },
                onIncidentReportTap: () {
                  _showSnackbar('Laporan Kejadian');
                },
                onStartWorkTap: () {
                  _showSnackbar('Mulai Bekerja');
                },
              ),

              const SizedBox(height: 24),

              // Quick Actions
              QuickActionsSection(
                onRecapTap: () {
                  _showSnackbar('Rekapitulasi Kehadiran');
                },
                onSubmissionTap: () {
                  _showSnackbar('Pengajuan Cuti');
                },
                onRegulationTap: () {
                  _showSnackbar('Peraturan Perusahaan');
                },
                onBMITap: () {
                  _showSnackbar('BMI Calculator');
                },
                onTestResultTap: () {
                  _showSnackbar('Hasil Ujian');
                },
              ),

              const SizedBox(height: 100), // Space for bottom navigation
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });
          _handleBottomNavTap(index);
        },
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFE74C3C),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showPanicDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'PANIC BUTTON',
          style: TextStyle(
            color: Color(0xFFE74C3C),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Apakah Anda yakin ingin mengaktifkan panic button?\n\nIni akan mengirim alert darurat ke semua kontak emergency.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackbar('Alert darurat telah dikirim!');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE74C3C),
              foregroundColor: Colors.white,
            ),
            child: const Text('Aktifkan'),
          ),
        ],
      ),
    );
  }

  void _handleBottomNavTap(int index) {
    switch (index) {
      case 0:
        _showSnackbar('Beranda');
        break;
      case 1:
        _showSnackbar('Pesan');
        break;
      case 2:
        _showSnackbar('Notifikasi');
        break;
      case 3:
        _showSnackbar('Profil');
        break;
    }
  }
}
