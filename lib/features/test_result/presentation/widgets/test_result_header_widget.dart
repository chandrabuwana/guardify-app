import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../domain/entities/test_summary_entity.dart';

/// Widget untuk menampilkan ringkasan hasil Test
/// Layout berbeda berdasarkan role:
/// - PJO/Deputy/Pengawas: Tampilkan Jml Lulus & Tidak Lulus
/// - Danton: Tidak tampilkan Jml Lulus & Tidak Lulus
class TestResultHeaderWidget extends StatelessWidget {
  final TestSummaryEntity summary;
  final UserRole userRole;
  final bool showPassFailCount;

  const TestResultHeaderWidget({
    Key? key,
    required this.summary,
    required this.userRole,
    this.showPassFailCount = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool shouldShowPassFail = showPassFailCount &&
        (userRole == UserRole.pjo ||
            userRole == UserRole.deputy ||
            userRole == UserRole.pengawas);

    return Container(
      margin: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Test Pengetahuan Umum
          Container(
            padding: REdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12.r),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.assignment,
                  color: primaryColor,
                  size: 24.w,
                ),
                12.horizontalSpace,
                Text(
                  'Test Pengetahuan Umum',
                  style: TS.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: neutral90,
                  ),
                ),
              ],
            ),
          ),

          // Summary Cards
          Padding(
            padding: REdgeInsets.all(16),
            child: Column(
              children: [
                // Row pertama: Jml Lulus & Tidak Lulus (jika role PJO/Deputy/Pengawas)
                if (shouldShowPassFail) ...[
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          value: summary.jumlahPesertaLulus.toString(),
                          label: 'Jumlah\nPeserta Lulus',
                          color: successColor,
                        ),
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: _buildSummaryCard(
                          value: summary.jumlahPesertaTidakLulus.toString(),
                          label: 'Peserta\nTidak Lulus',
                          color: errorColor,
                        ),
                      ),
                    ],
                  ),
                  12.verticalSpace,
                ],

                // Row kedua: Rata-rata & Minimal
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        value: summary.nilaiRataRata.toStringAsFixed(1),
                        label: 'Nilai\nRata Rata',
                        color: const Color(0xFF2196F3),
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: _buildSummaryCard(
                        value: summary.nilaiMinimal.toInt().toString(),
                        label: 'Nilai\nMinimal',
                        color: const Color(0xFFFF9800),
                      ),
                    ),
                  ],
                ),

                16.verticalSpace,

                // PIC Details
                Container(
                  padding: REdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('PIC', summary.picPeserta ?? '-'),
                      if (summary.anggotaList != null &&
                          summary.anggotaList!.isNotEmpty)
                        _buildDetailRow(
                            'Peserta', summary.anggotaList!.join(', ')),
                      _buildDetailRow('Tipe Test', summary.tipeTest ?? '-'),
                      if (summary.tanggalPelaksanaan != null)
                        _buildDetailRow(
                          'Tanggal Pelaksanaan',
                          DateFormat('dd MMMM yyyy', 'id')
                              .format(summary.tanggalPelaksanaan!),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TS.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          4.verticalSpace,
          Text(
            label,
            style: TS.bodySmall.copyWith(
              color: neutral70,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: REdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              label,
              style: TS.bodySmall.copyWith(
                color: neutral70,
              ),
            ),
          ),
          Text(
            ': ',
            style: TS.bodySmall.copyWith(
              color: neutral70,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TS.bodySmall.copyWith(
                color: neutral90,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

