import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../domain/entities/tugas_lanjutan_entity.dart';
import 'package:intl/intl.dart';

class TugasLanjutanCard extends StatelessWidget {
  final TugasLanjutanEntity tugas;
  final VoidCallback onTap;

  const TugasLanjutanCard({
    Key? key,
    required this.tugas,
    required this.onTap,
  }) : super(key: key);

  Color _getStatusColor(TugasLanjutanStatus status) {
    switch (status) {
      case TugasLanjutanStatus.belum:
        return Colors.red;
      case TugasLanjutanStatus.selesai:
        return const Color(0xFF1E3A8A); // Dark blue
      case TugasLanjutanStatus.terverifikasi:
        return Colors.green;
    }
  }

  String _getStatusText(TugasLanjutanStatus status) {
    switch (status) {
      case TugasLanjutanStatus.belum:
        return 'Belum';
      case TugasLanjutanStatus.selesai:
        return 'Selesai';
      case TugasLanjutanStatus.terverifikasi:
        return 'Terverifikasi';
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy - HH.mm', 'id_ID');

    return Container(
      margin: REdgeInsets.only(bottom: 16),
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  tugas.title,
                  style: TS.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: REdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(tugas.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  _getStatusText(tugas.status),
                  style: TS.labelSmall.copyWith(
                    color: _getStatusColor(tugas.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          12.verticalSpace,

          // Details
          _buildDetailRow('Lokasi', ': ${tugas.lokasi}'),
          4.verticalSpace,
          _buildDetailRow('Pelapor', ': ${tugas.pelapor}'),
          4.verticalSpace,
          _buildDetailRow(
            'Tanggal',
            ': ${dateFormat.format(tugas.tanggal)} WIB',
          ),

          12.verticalSpace,

          // Description
          Text(
            tugas.deskripsi,
            style: TS.bodySmall.copyWith(color: Colors.grey[700]),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),

          12.verticalSpace,

          // Completion info (if completed)
          if (tugas.status == TugasLanjutanStatus.selesai ||
              tugas.status == TugasLanjutanStatus.terverifikasi)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Diselesaikan Oleh',
                  style: TS.bodySmall.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                4.verticalSpace,
                Text(
                  tugas.diselesaikanOleh ?? '-',
                  style: TS.bodySmall,
                ),
                4.verticalSpace,
                if (tugas.tanggalSelesai != null)
                  Text(
                    dateFormat.format(tugas.tanggalSelesai!) + ' WIB',
                    style: TS.bodySmall.copyWith(color: Colors.grey[600]),
                  ),
                8.verticalSpace,
                Row(
                  children: [
                    Text(
                      'Bukti',
                      style: TS.bodySmall.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    8.horizontalSpace,
                    if (tugas.buktiUrl != null)
                      GestureDetector(
                        onTap: () {
                          // Show proof image
                        },
                        child: Text(
                          tugas.buktiUrl!,
                          style: TS.bodySmall.copyWith(
                            color: primaryColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    else
                      Text(
                        '-',
                        style: TS.bodySmall,
                      ),
                  ],
                ),
              ],
            ),

          16.verticalSpace,

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: tugas.status == TugasLanjutanStatus.belum
                  ? onTap
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: tugas.status == TugasLanjutanStatus.belum
                    ? primaryColor
                    : Colors.grey,
                padding: REdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Tandai Sebagai Selesai',
                style: TS.labelLarge.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80.w,
          child: Text(
            label,
            style: TS.bodySmall.copyWith(color: Colors.grey[600]),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TS.bodySmall,
          ),
        ),
      ],
    );
  }
}

