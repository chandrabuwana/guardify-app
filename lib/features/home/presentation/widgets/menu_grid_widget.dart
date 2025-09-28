import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuGridWidget extends StatelessWidget {
  final VoidCallback? onActivityReportTap;
  final VoidCallback? onIncidentReportTap;
  final VoidCallback? onActivityRecapTap;
  final VoidCallback? onBMITap;
  final VoidCallback? onTestResultTap;
  final VoidCallback? onLeaveTap;
  final VoidCallback? onRegulationsTap;
  final VoidCallback? onEmergencyHistoryTap;
  final VoidCallback? onDisasterInfoTap;

  const MenuGridWidget({
    super.key,
    this.onActivityReportTap,
    this.onIncidentReportTap,
    this.onActivityRecapTap,
    this.onBMITap,
    this.onTestResultTap,
    this.onLeaveTap,
    this.onRegulationsTap,
    this.onEmergencyHistoryTap,
    this.onDisasterInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Menu',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          16.verticalSpace,
          GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 0.9,
            children: [
              _buildMenuItem(
                icon: Icons.assignment,
                label: 'Laporan\nKegiatan',
                onTap: onActivityReportTap,
                hasNotification: true,
              ),
              _buildMenuItem(
                icon: Icons.warning,
                label: 'Rekapitulasi\nKehadiran',
                onTap: onActivityRecapTap,
                hasNotification: true,
              ),
              _buildMenuItem(
                icon: Icons.report,
                label: 'Laporan\nKegiatan',
                onTap: onIncidentReportTap,
              ),
              _buildMenuItem(
                icon: Icons.monitor_weight,
                label: 'Body Mass\nIndex (BMI)',
                onTap: onBMITap,
                hasNotification: true,
              ),
              _buildMenuItem(
                icon: Icons.quiz,
                label: 'Hasil\nUjian',
                onTap: onTestResultTap,
                hasNotification: true,
              ),
              _buildMenuItem(
                icon: Icons.event_available,
                label: 'Pengajuan\nCuti',
                onTap: onLeaveTap,
              ),
              _buildMenuItem(
                icon: Icons.book,
                label: 'Peraturan\nPerusahaan',
                onTap: onRegulationsTap,
              ),
              _buildMenuItem(
                icon: Icons.history,
                label: 'Riwayat Tombol\nDarurat',
                onTap: onEmergencyHistoryTap,
              ),
              _buildMenuItem(
                icon: Icons.info,
                label: 'Informasi\nBencana',
                onTap: onDisasterInfoTap,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    bool hasNotification = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: REdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB71C1C),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 20.r,
                    ),
                  ),
                  8.verticalSpace,
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (hasNotification)
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
