import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../domain/entities/cuti_kuota_entity.dart';

class KuotaCutiCard extends StatelessWidget {
  final CutiKuotaEntity kuota;

  const KuotaCutiCard({
    Key? key,
    required this.kuota,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double progressPercentage = kuota.totalKuotaPerTahun > 0
        ? (kuota.kuotaTerpakai / kuota.totalKuotaPerTahun)
        : 0.0;

    return Container(
      padding: REdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, primaryColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kuota Cuti ${kuota.tahun}',
                style: TS.titleMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.calendar_month,
                color: Colors.white,
                size: 24.sp,
              ),
            ],
          ),

          20.verticalSpace,

          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Terpakai',
                    style: TS.bodyMedium.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    '${kuota.kuotaTerpakai}/${kuota.totalKuotaPerTahun} hari',
                    style: TS.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              8.verticalSpace,
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: LinearProgressIndicator(
                  value: progressPercentage,
                  backgroundColor: Colors.white30,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progressPercentage > 0.8
                        ? Colors.orange.shade300
                        : Colors.white,
                  ),
                  minHeight: 8.h,
                ),
              ),
            ],
          ),

          20.verticalSpace,

          // Statistik
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Sisa Kuota',
                  '${kuota.kuotaSisa}',
                  'hari',
                  Icons.event_available,
                ),
              ),
              Container(
                width: 1,
                height: 40.h,
                color: Colors.white30,
              ),
              Expanded(
                child: _buildStatItem(
                  'Total Kuota',
                  '${kuota.totalKuotaPerTahun}',
                  'hari',
                  Icons.event_note,
                ),
              ),
            ],
          ),

          if (kuota.kuotaSisa <= 2) ...[
            16.verticalSpace,
            Container(
              width: double.infinity,
              padding: REdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade100.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: Colors.orange.shade200,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: Colors.orange.shade200,
                    size: 20.sp,
                  ),
                  8.horizontalSpace,
                  Expanded(
                    child: Text(
                      'Kuota cuti Anda hampir habis!',
                      style: TS.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, String unit, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white70,
          size: 20.sp,
        ),
        8.verticalSpace,
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: TS.titleLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: ' $unit',
                style: TS.bodySmall.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        4.verticalSpace,
        Text(
          label,
          style: TS.bodySmall.copyWith(
            color: Colors.white70,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
