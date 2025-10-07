import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/styles.dart';
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

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');

    return Card(
      margin: REdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(
          color: statusColor,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: REdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${dateFormat.format(laporan.tanggal)} - ${laporan.shift}',
                    style: TS.titleSmall.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (laporan.status == LaporanStatus.revisi)
                    Container(
                      padding:
                          REdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        'Revisi',
                        style: TS.labelSmall.copyWith(color: Colors.orange),
                      ),
                    ),
                  if (laporan.status == LaporanStatus.menungguVerifikasi)
                    Container(
                      padding:
                          REdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        'Menunggu',
                        style: TS.labelSmall.copyWith(color: Colors.grey),
                      ),
                    ),
                  if (laporan.status == LaporanStatus.terverifikasi)
                    Container(
                      padding:
                          REdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E3A8A).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        'Terverifikasi',
                        style: TS.labelSmall
                            .copyWith(color: const Color(0xFF1E3A8A)),
                      ),
                    ),
                ],
              ),
              12.verticalSpace,
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  4.horizontalSpace,
                  Text(
                    'Nama Personil',
                    style: TS.bodySmall.copyWith(color: Colors.grey),
                  ),
                  const Spacer(),
                  Text(
                    ': ${laporan.namaPersonil}',
                    style: TS.bodySmall,
                  ),
                ],
              ),
              4.verticalSpace,
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  4.horizontalSpace,
                  Text(
                    'Jam Kerja',
                    style: TS.bodySmall.copyWith(color: Colors.grey),
                  ),
                  const Spacer(),
                  Text(
                    ': ${laporan.jamKerja}',
                    style: TS.bodySmall,
                  ),
                ],
              ),
              4.verticalSpace,
              Row(
                children: [
                  const Icon(Icons.check_circle, size: 16, color: Colors.grey),
                  4.horizontalSpace,
                  Text(
                    'Tugas Tertunda',
                    style: TS.bodySmall.copyWith(color: Colors.grey),
                  ),
                  const Spacer(),
                  Text(
                    ': ${laporan.tugasTertunda ? "Selesai" : "Tidak"}',
                    style: TS.bodySmall,
                  ),
                ],
              ),
              4.verticalSpace,
              Row(
                children: [
                  const Icon(Icons.work, size: 16, color: Colors.grey),
                  4.horizontalSpace,
                  Text(
                    'Lembur',
                    style: TS.bodySmall.copyWith(color: Colors.grey),
                  ),
                  const Spacer(),
                  Text(
                    ': ${laporan.lembur ? "Tidak" : "Tidak"}',
                    style: TS.bodySmall,
                  ),
                ],
              ),
              12.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kehadiran : ',
                    style: TS.bodySmall.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    laporan.kehadiran,
                    style: TS.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: laporan.kehadiran == 'Masuk'
                          ? Colors.green
                          : laporan.kehadiran == 'Cuti'
                              ? Colors.blue
                              : Colors.red,
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
