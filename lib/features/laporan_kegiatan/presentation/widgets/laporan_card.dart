import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/styles.dart';
import '../../../../core/design/colors.dart';
import '../../domain/entities/laporan_kegiatan_entity.dart';
import 'package:intl/intl.dart';

class LaporanCard extends StatelessWidget {
  final LaporanKegiatanEntity laporan;
  final Color statusColor;
  final VoidCallback onTap;

  const LaporanCard({
    Key? key,
    required this.laporan,
    required this.statusColor,
    required this.onTap,
  }) : super(key: key);

  Color _getKehadiranColor(String kehadiran) {
    switch (kehadiran) {
      case 'Masuk':
        return const Color(0xFF1E88E5); // Blue
      case 'Terlambat':
        return Colors.orange;
      case 'Cuti':
        return const Color(0xFF1E88E5); // Blue
      case 'Tidak Masuk':
        return errorColor; // Red
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');

    return Container(
      margin: REdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Left border indicator
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4.w,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  bottomLeft: Radius.circular(12.r),
                ),
              ),
            ),
          ),
          // Card content
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12.r),
            child: Opacity(
              opacity: (laporan.idAttendance != null && 
                       laporan.checkIn != null && 
                       laporan.checkOut != null) ? 1.0 : 0.6,
              child: Padding(
              padding: REdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with date and status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          '${dateFormat.format(laporan.tanggal)} - ${laporan.shift}',
                          style: TS.titleSmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      _buildStatusBadge(laporan.status),
                    ],
                  ),
                  12.verticalSpace,
                  // Personnel Name
                  _buildInfoRow(
                    'Nama Personil',
                    laporan.namaPersonil,
                  ),
                  4.verticalSpace,
                  // Work Hours
                  _buildInfoRow(
                    'Jam Kerja',
                    laporan.jamKerja,
                  ),
                  4.verticalSpace,
                  // Pending Tasks
                  _buildInfoRow(
                    'Tugas Tertunda',
                    laporan.tugasTertunda ? 'Selesai' : 'Belum Selesai',
                  ),
                  4.verticalSpace,
                  // Overtime
                  _buildInfoRow(
                    'Lembur',
                    laporan.lembur ? 'Ya' : 'Tidak',
                  ),
                  12.verticalSpace,
                  // Attendance
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Kehadiran : ',
                        style: TS.bodySmall.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        laporan.kehadiran,
                        style: TS.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _getKehadiranColor(laporan.kehadiran),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(LaporanStatus status) {
    String text;
    Color textColor;
    Color bgColor;

    switch (status) {
      case LaporanStatus.checkIn:
        text = 'Check In';
        textColor = Colors.blue[700]!;
        bgColor = Colors.blue[50]!;
        break;
      case LaporanStatus.waiting:
        text = 'Waiting';
        textColor = Colors.blue[700]!;
        bgColor = Colors.blue[50]!;
        break;
      case LaporanStatus.verified:
        text = 'Verified';
        textColor = Colors.lightBlue[700]!;
        bgColor = Colors.lightBlue[50]!;
        break;
      case LaporanStatus.revision:
        text = 'Revision';
        textColor = Colors.orange[700]!;
        bgColor = Colors.orange[50]!;
        break;
    }

    return Container(
      padding: REdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: TS.labelSmall.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            '$label : ',
            style: TS.bodySmall.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TS.bodySmall.copyWith(
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
