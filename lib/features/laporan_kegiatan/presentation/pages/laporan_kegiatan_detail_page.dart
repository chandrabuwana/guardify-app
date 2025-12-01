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
import '../widgets/patrol_timeline_widget.dart';
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
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    context
        .read<LaporanKegiatanBloc>()
        .add(GetLaporanDetailEvent(widget.laporanId));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                contentPadding: REdgeInsets.all(24),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64.w,
                      height: 64.h,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 32.sp,
                      ),
                    ),
                    16.verticalSpace,
                    Text(
                      'Laporan Kegiatan Berhasil Diterima!',
                      style: TS.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    24.verticalSpace,
                    UIButton(
                      text: 'OK',
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                        Navigator.of(context).pop(); // Go back to list
                      },
                    ),
                  ],
                ),
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
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              _buildFirstPage(laporan),
              _buildSecondPage(laporan),
            ],
          ),
        ),
        // Page indicator and navigation
        if (_currentPage == 0)
          Container(
            padding: REdgeInsets.all(16),
            child: UIButton(
              text: 'Selanjutnya →',
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          )
        else
          _buildActionButtons(laporan),
      ],
    );
  }

  Widget _buildFirstPage(LaporanKegiatanEntity laporan) {
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
                  backgroundImage: laporan.profileImageUrl != null
                      ? NetworkImage(laporan.profileImageUrl!)
                      : null,
                  child: laporan.profileImageUrl == null
                      ? Icon(Icons.person, size: 40.sp)
                      : null,
                ),
                8.verticalSpace,
                Text(
                  laporan.namaPersonil,
                  style: TS.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                4.verticalSpace,
                Text(
                  '${laporan.role.displayName} - ${laporan.nrp}',
                  style: TS.bodySmall.copyWith(color: Colors.grey[600]),
                ),
                4.verticalSpace,
                Text(
                  _getKehadiranText(laporan.kehadiran),
                  style: TS.bodySmall.copyWith(
                    color: _getKehadiranColor(laporan.kehadiran),
                    fontWeight: FontWeight.w600,
                  ),
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
            style: TS.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          16.verticalSpace,

          // Jam Absensi
          _buildInfoCard(
            'Jam Absensi',
            laporan.jamAbsensi ?? '-',
          ),
          16.verticalSpace,

          // Pakaian Personil
          _buildFileCard(
            'Pakaian Personil',
            laporan.fotoPakaianPersonil ?? 'Foto.jpg',
          ),
          16.verticalSpace,

          // Laporan Pengamanan
          _buildInfoCard('Laporan Pengamanan', laporan.laporanPengamanan),
          16.verticalSpace,

          // Foto Pengamanan
          _buildFileCard(
            'Foto Pengamanan',
            laporan.fotoPengamanan?.isNotEmpty == true
                ? laporan.fotoPengamanan!.first
                : 'Foto.jpg',
          ),
          16.verticalSpace,

          // Tugas Lanjutan
          _buildTugasLanjutanCard(laporan),
        ],
      ),
    );
  }

  Widget _buildSecondPage(LaporanKegiatanEntity laporan) {
    return SingleChildScrollView(
      padding: REdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selesai Bekerja Section
          Text(
            'Selesai Bekerja',
            style: TS.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          16.verticalSpace,

          // Pakaian Personil (selesai)
          _buildFileCard(
            'Pakaian Personil',
            laporan.fotoPakaianPersonil ?? 'Foto.jpg',
          ),
          16.verticalSpace,

          // Patroli Section
          if (laporan.routeName != null && laporan.checkpoints != null) ...[
            PatrolTimelineWidget(
              routeName: laporan.routeName!,
              checkpoints: laporan.checkpoints!,
              isDiperiksa: laporan.checkpoints!
                  .every((cp) => cp.isDiperiksa && cp.buktiUrl != null),
            ),
            16.verticalSpace,
          ],

          // Laporan Pengamanan
          _buildInfoCard('Laporan Pengamanan', laporan.laporanPengamanan),
          16.verticalSpace,

          // Foto Pengamanan
          _buildFileCard(
            'Foto Pengamanan',
            laporan.fotoPengamanan?.isNotEmpty == true
                ? laporan.fotoPengamanan!.first
                : 'Foto.jpg',
          ),
          16.verticalSpace,

          // Tugas Tertunda
          _buildInfoCard(
            'Tugas Tertunda',
            laporan.tugasLanjutan ?? '-',
          ),
          16.verticalSpace,

          // Jam Selesai Bekerja
          _buildInfoCard(
            'Jam Selesai Bekerja',
            laporan.jamSelesaiBekerja ?? '-',
          ),
          16.verticalSpace,

          // Lembur
          _buildInfoCard('Lembur', laporan.lembur ? 'Ya' : 'Tidak'),
          16.verticalSpace,

          // Bukti Lembur
          if (laporan.lembur)
            _buildFileCard(
              'Bukti Lembur',
              laporan.fotoLembur ?? 'Foto.jpg',
            )
          else
            _buildInfoCard('Bukti Lembur', '-'),
          16.verticalSpace,

          // Status Selesai Bekerja
          _buildInfoCard(
            'Status Selesai Bekerja',
            laporan.jamSelesaiBekerja ?? 'On Time, Early, Late, ...',
          ),
          16.verticalSpace,

          // Umpan Balik
          _buildInfoCard(
            'Umpan Balik',
            laporan.umpanBalik ?? 'Keterangan Tugas Tertunda',
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(LaporanKegiatanEntity laporan) {
    final canTakeAction = widget.userRole.isHighAccess &&
        laporan.status == LaporanStatus.menungguVerifikasi;

    return Container(
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (canTakeAction) ...[
            Row(
              children: [
                // WhatsApp Button
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF25D366),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.chat, color: Colors.white),
                    onPressed: () {
                      _openWhatsApp(laporan);
                    },
                  ),
                ),
                12.horizontalSpace,
                // Revisi Button
                Expanded(
                  child: UIButton(
                    text: 'Revisi',
                    buttonType: UIButtonType.outline,
                    variant: UIButtonVariant.error,
                    onPressed: () {
                      _showRevisiDialog(laporan);
                    },
                  ),
                ),
                12.horizontalSpace,
                // Terima Button
                Expanded(
                  flex: 2,
                  child: UIButton(
                    text: 'Terima Laporan Kegiatan',
                    onPressed: () {
                      _showAcceptConfirmation(laporan);
                    },
                  ),
                ),
              ],
            ),
            12.verticalSpace,
          ],
          // Tandai Sebagai Tidak Masuk Button
          if (canTakeAction)
            UIButton(
              text: 'Tandai Sebagai Tidak Masuk',
              buttonType: UIButtonType.outline,
              variant: UIButtonVariant.neutral,
              onPressed: () {
                _showMarkAsTidakMasukDialog(laporan);
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
            style: TS.bodyMedium.copyWith(color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildFileCard(String label, String fileName) {
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
          GestureDetector(
            onTap: () {
              // Open image preview
            },
            child: Text(
              fileName,
              style: TS.bodyMedium.copyWith(
                color: const Color(0xFF1E88E5),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTugasLanjutanCard(LaporanKegiatanEntity laporan) {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tugas Lanjutan',
                  style: TS.bodySmall.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                4.verticalSpace,
                Text(
                  laporan.tugasLanjutan ?? 'Selesai (5/5 Selesai Dikerjakan)',
                  style: TS.bodyMedium.copyWith(color: Colors.black87),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16.sp,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  String _getKehadiranText(String kehadiran) {
    switch (kehadiran) {
      case 'Masuk':
        return 'Masuk';
      case 'Terlambat':
        return 'Terlambat';
      case 'Cuti':
        return 'Cuti';
      case 'Tidak Masuk':
        return 'Tidak Masuk';
      default:
        return kehadiran;
    }
  }

  Color _getKehadiranColor(String kehadiran) {
    switch (kehadiran) {
      case 'Masuk':
        return const Color(0xFF1E88E5);
      case 'Terlambat':
        return Colors.orange;
      case 'Cuti':
        return const Color(0xFF1E88E5);
      case 'Tidak Masuk':
        return errorColor;
      default:
        return Colors.grey;
    }
  }

  void _showAcceptConfirmation(LaporanKegiatanEntity laporan) {
    ConfirmDialog.show(
      context: context,
      title: 'Konfirmasi',
      message: 'Apakah Anda yakin menerima laporan kegiatan ini?',
      confirmText: 'Ya',
      cancelText: 'Tidak',
      icon: Icons.check_circle_outline,
      iconColor: primaryColor,
    ).then((confirmed) {
      if (confirmed == true) {
        context.read<LaporanKegiatanBloc>().add(AcceptLaporanEvent(laporan.id));
      }
    });
  }

  void _showRevisiDialog(LaporanKegiatanEntity laporan) {
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Request Revisi',
          style: TS.titleMedium.copyWith(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: noteController,
          decoration: InputDecoration(
            hintText: 'Masukkan catatan revisi...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          maxLines: 4,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Batal', style: TS.bodyMedium),
          ),
          UIButton(
            text: 'Kirim',
            onPressed: () {
              if (noteController.text.isNotEmpty) {
                context.read<LaporanKegiatanBloc>().add(
                      RequestRevisiEvent(
                        id: laporan.id,
                        note: noteController.text,
                      ),
                    );
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  void _showMarkAsTidakMasukDialog(LaporanKegiatanEntity laporan) {
    ConfirmDialog.show(
      context: context,
      title: 'Konfirmasi',
      message: 'Yakin menandai laporan kegiatan ini sebagai "Tidak Masuk"?',
      confirmText: 'Ya',
      cancelText: 'Tidak',
      icon: Icons.help_outline,
      iconColor: errorColor,
      isDestructive: true,
    ).then((confirmed) {
      if (confirmed == true) {
        context.read<LaporanKegiatanBloc>().add(
              MarkAsTidakMasukEvent(laporan.id),
            );
      }
    });
  }

  void _openWhatsApp(LaporanKegiatanEntity laporan) {
    // TODO: Add url_launcher package to pubspec.yaml
    // Format: https://wa.me/PHONENUMBER?text=MESSAGE
    final phoneNumber = '6281234567890'; // Replace with actual phone number
    final message = 'Halo, saya ingin membahas laporan kegiatan untuk ${laporan.namaPersonil}';
    final url = 'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';

    // For now, show a message that WhatsApp integration will be available after API integration
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fitur WhatsApp akan tersedia setelah integrasi API'),
        duration: const Duration(seconds: 2),
      ),
    );

    // Uncomment when url_launcher is added:
    // if (await canLaunchUrl(Uri.parse(url))) {
    //   await launchUrl(Uri.parse(url));
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Tidak dapat membuka WhatsApp')),
    //   );
    // }
  }
}
