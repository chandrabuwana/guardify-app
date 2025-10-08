import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../domain/entities/test_result_entity.dart';

/// Widget card untuk menampilkan item hasil Test individu
class TestResultCardWidget extends StatelessWidget {
  final TestResultEntity result;

  const TestResultCardWidget({
    Key? key,
    required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(result.status);
    final statusText = _getStatusText(result.status);

    return Container(
      margin: REdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: REdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan ID & Tipe
            Row(
              children: [
                Container(
                  padding: REdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: neutral20,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'ID: ${result.id}',
                    style: TS.caption.copyWith(
                      color: neutral70,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                const Spacer(),
                if (result.tipeTest != null)
                  Text(
                    result.tipeTest!,
                    style: TS.caption.copyWith(
                      color: neutral70,
                    ),
                  ),
              ],
            ),

            12.verticalSpace,

            // Nama Test
            Text(
              result.namaTest,
              style: TS.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: neutral90,
              ),
            ),

            8.verticalSpace,

            // Tanggal Test
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14.w, color: neutral70),
                6.horizontalSpace,
                Text(
                  'Tanggal Test: ${DateFormat('dd MMMM yyyy', 'id').format(result.tanggalTest)}',
                  style: TS.bodySmall.copyWith(color: neutral70),
                ),
              ],
            ),

            12.verticalSpace,

            // Nilai
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    label: 'Nilai Test',
                    value: result.nilaiTest.toString(),
                    valueColor: result.isLulus ? successColor : errorColor,
                  ),
                ),
                16.horizontalSpace,
                Expanded(
                  child: _buildInfoItem(
                    label: 'Nilai KKM',
                    value: result.nilaiKKM.toString(),
                    valueColor: neutral70,
                  ),
                ),
              ],
            ),

            12.verticalSpace,

            // Status
            Container(
              padding: REdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: statusColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getStatusIcon(result.status),
                    size: 16.w,
                    color: statusColor,
                  ),
                  8.horizontalSpace,
                  Text(
                    'Status: $statusText',
                    style: TS.bodySmall.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TS.caption.copyWith(
            color: neutral70,
          ),
        ),
        4.verticalSpace,
        Text(
          value,
          style: TS.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(TestKelulusanStatus status) {
    switch (status) {
      case TestKelulusanStatus.lulus:
        return successColor;
      case TestKelulusanStatus.tidakLulus:
        return errorColor;
      case TestKelulusanStatus.belumDinilai:
        return const Color(0xFFFF9800);
    }
  }

  String _getStatusText(TestKelulusanStatus status) {
    switch (status) {
      case TestKelulusanStatus.lulus:
        return 'Lulus';
      case TestKelulusanStatus.tidakLulus:
        return 'Tidak Lulus';
      case TestKelulusanStatus.belumDinilai:
        return 'Belum Dinilai';
    }
  }

  IconData _getStatusIcon(TestKelulusanStatus status) {
    switch (status) {
      case TestKelulusanStatus.lulus:
        return Icons.check_circle;
      case TestKelulusanStatus.tidakLulus:
        return Icons.cancel;
      case TestKelulusanStatus.belumDinilai:
        return Icons.schedule;
    }
  }
}

