import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/Buttons/ui_button.dart';
import '../../../../shared/widgets/confirm_dialog.dart';
import '../bloc/laporan_kegiatan_bloc.dart';
import '../../domain/entities/laporan_kegiatan_entity.dart';
import 'package:intl/intl.dart';

class LaporanKegiatanDetailPage extends StatefulWidget {
  final String laporanId;
  final UserRole userRole;

  const LaporanKegiatanDetailPage({
    Key? key,
    required this.laporanId,
    required this.userRole,
  }) : super(key: key);

  @override
  State<LaporanKegiatanDetailPage> createState() =>
      _LaporanKegiatanDetailPageState();
}

class _LaporanKegiatanDetailPageState extends State<LaporanKegiatanDetailPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<LaporanKegiatanBloc>()
        .add(GetLaporanDetailEvent(widget.laporanId));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text('Detail Laporan Kegiatan'),
        centerTitle: true,
      ),
      child: BlocConsumer<LaporanKegiatanBloc, LaporanKegiatanState>(
        listener: (context, state) {
          if (state is LaporanUpdated) {
            // Show success dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Berhasil'),
                content: const Text('Laporan Kegiatan Berhasil Diterima!'),
                actions: [
                  UIButton(
                    text: 'OK',
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.of(context).pop(); // Go back to list
                    },
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is LaporanLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LaporanError) {
            return Center(child: Text(state.message));
          }

          if (state is LaporanDetailLoaded) {
            return _buildDetailContent(state.laporan);
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildDetailContent(LaporanKegiatanEntity laporan) {
    final dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');

    return SingleChildScrollView(
      padding: REdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Section
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40.r,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 40.sp),
                ),
                8.verticalSpace,
                Text(
                  laporan.namaPersonil,
                  style: TS.titleMedium.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${laporan.role.displayName} - ${laporan.nrp}',
                  style: TS.bodySmall.copyWith(color: Colors.grey),
                ),
                Text(
                  'Hadir',
                  style: TS.bodySmall.copyWith(color: Colors.blue),
                ),
              ],
            ),
          ),
          24.verticalSpace,

          // Status Laporan
          _buildInfoCard('Status Laporan', laporan.status.displayName),
          16.verticalSpace,

          // Tanggal
          _buildInfoCard('Tanggal', dateFormat.format(laporan.tanggal)),
          16.verticalSpace,

          // Nama Shift
          _buildInfoCard('Nama Shift', laporan.shift),
          16.verticalSpace,

          // Lokasi Jaga
          _buildInfoCard('Lokasi Jaga', laporan.lokasiJaga),
          16.verticalSpace,

          // Mulai Bekerja Section
          Text(
            'Mulai Bekerja',
            style: TS.titleMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          16.verticalSpace,

          // Jam Absensi
          _buildInfoCard('Jam Absensi', laporan.jamAbsensi ?? '-'),
          16.verticalSpace,

          // Pakaian Personil
          _buildInfoCard(
              'Pakaian Personil', laporan.pakaianPersonil ?? 'Foto.jpg'),
          16.verticalSpace,

          // Laporan Pengamanan
          _buildInfoCard('Laporan Pengamanan', laporan.laporanPengamanan),
          16.verticalSpace,

          // Foto Pengamanan
          _buildInfoCard('Foto Pengamanan', 'Foto.jpg'),
          16.verticalSpace,

          // Tugas Lanjutan
          _buildInfoCard(
            'Tugas Lanjutan',
            laporan.tugasLanjutan ?? 'Selesai (5/5 Selesai Dikerjakan)',
          ),
          24.verticalSpace,

          // Action Buttons based on role
          if (widget.userRole.isHighAccess &&
              laporan.status == LaporanStatus.menungguVerifikasi)
            UIButton(
              text: 'Selanjutnya →',
              onPressed: () {
                _showConfirmationDialog(laporan);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TS.bodySmall.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          4.verticalSpace,
          Text(
            value,
            style: TS.bodyMedium,
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(LaporanKegiatanEntity laporan) {
    ConfirmDialog.show(
      context: context,
      title: 'Konfirmasi',
      message: 'Apakah Anda yakin menerima laporan kegiatan?',
      confirmText: 'Ya',
      cancelText: 'Tidak',
      icon: Icons.help_outline,
      iconColor: primaryColor,
    ).then((confirmed) {
      if (confirmed == true) {
        context.read<LaporanKegiatanBloc>().add(AcceptLaporanEvent(laporan.id));
      }
    });
  }
}
