import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../../../core/di/injection.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/Buttons/ui_button.dart';
import '../../domain/entities/attendance_rekap_detail_entity.dart';
import '../bloc/attendance_rekap_detail_bloc.dart';
import '../bloc/attendance_rekap_detail_event.dart';
import '../bloc/attendance_rekap_detail_state.dart';
import 'attendance_rekap_edit_screen.dart';

class AttendanceRekapKehadiranDetailScreen extends StatelessWidget {
  final String idAttendance;

  const AttendanceRekapKehadiranDetailScreen({
    super.key,
    required this.idAttendance,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AttendanceRekapDetailBloc>()
        ..add(LoadAttendanceRekapDetailEvent(idAttendance)),
      child: _AttendanceRekapKehadiranDetailScreenContent(idAttendance: idAttendance),
    );
  }
}

class _AttendanceRekapKehadiranDetailScreenContent extends StatefulWidget {
  final String idAttendance;

  const _AttendanceRekapKehadiranDetailScreenContent({required this.idAttendance});

  @override
  State<_AttendanceRekapKehadiranDetailScreenContent> createState() =>
      _AttendanceRekapKehadiranDetailScreenContentState();
}

class _AttendanceRekapKehadiranDetailScreenContentState
    extends State<_AttendanceRekapKehadiranDetailScreenContent> {
  int _stepIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      enableScrolling: true,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Detail Kehadiran',
          style: TS.titleLarge.copyWith(color: Colors.white),
        ),
        centerTitle: true,
      ),
      child: BlocConsumer<AttendanceRekapDetailBloc, AttendanceRekapDetailState>(
        listener: (context, state) {
          if (state is AttendanceRekapDetailFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AttendanceRekapDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          if (state is AttendanceRekapDetailFailure) {
            return _buildErrorState(context, state.message);
          }

          if (state is AttendanceRekapDetailLoaded) {
            return _buildContent(context, state.detail);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, AttendanceRekapDetailEntity detail) {
    final canEdit = detail.statusLaporan.toUpperCase() == 'REVISI';

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSectionInCard(detail),
            16.verticalSpace,
            Padding(
              padding: REdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoFieldInCard(
                    'Status Laporan',
                    _formatStatusLaporan(detail.statusLaporan),
                  ),
                  16.verticalSpace,
                  _buildInfoFieldInCard(
                    'Diverifikasi Oleh',
                    (detail.updateBy != null && detail.updateBy!.isNotEmpty)
                        ? detail.updateBy!
                        : '-',
                  ),
                  16.verticalSpace,
                  _buildInfoFieldInCard(
                    'Tanggal Verifikasi',
                    detail.updateDate != null ? _formatTime(detail.updateDate!) : '-',
                  ),
                  16.verticalSpace,
                  _buildTextAreaFieldInCard(
                    'Feedback',
                    (detail.feedback != null && detail.feedback!.isNotEmpty)
                        ? detail.feedback!
                        : '-',
                  ),
                  16.verticalSpace,
                  _buildInfoFieldInCard('Tanggal', _formatDate(detail.shiftDate)),
                  16.verticalSpace,
                  _buildInfoFieldInCard('Nama Shift', detail.shiftName),
                  16.verticalSpace,
                  _buildInfoFieldInCard('Lokasi Jaga', detail.location ?? '-'),
                  16.verticalSpace,
                  _stepIndex == 0
                      ? _buildMulaiBekerjaSection(detail)
                      : _buildSelesaiBekerjaSection(detail),
                ],
              ),
            ),
            32.verticalSpace,
            Padding(
              padding: REdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: UIButton(
                      text: _stepIndex == 0 ? 'Selanjutnya' : 'Kembali',
                      onPressed: () {
                        setState(() {
                          _stepIndex = _stepIndex == 0 ? 1 : 0;
                        });
                      },
                      variant: UIButtonVariant.primary,
                      size: UIButtonSize.large,
                      fullWidth: true,
                      suffixIcon: _stepIndex == 0
                          ? const Icon(Icons.arrow_forward, color: Colors.white)
                          : const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: UIButton(
                      text: 'Edit',
                      onPressed: canEdit
                          ? () => _navigateToEdit(context)
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Laporan hanya dapat diedit ketika status REVISI.',
                                  ),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            },
                      variant: canEdit ? UIButtonVariant.primary : UIButtonVariant.secondary,
                      size: UIButtonSize.large,
                      fullWidth: true,
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

  Future<void> _navigateToEdit(BuildContext context) async {
    final currentState = context.read<AttendanceRekapDetailBloc>().state;
    if (currentState is AttendanceRekapDetailLoaded) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AttendanceRekapEditScreen(
            idAttendance: widget.idAttendance,
            detail: currentState.detail,
            editMode: _stepIndex == 0
                ? AttendanceRekapEditMode.checkIn
                : AttendanceRekapEditMode.checkOut,
          ),
        ),
      );

      if (result == true && mounted) {
        Navigator.of(context).pop(true);
      }
    }
  }

  Widget _buildMulaiBekerjaSection(AttendanceRekapDetailEntity detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mulai Bekerja',
          style: TS.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: neutral90,
          ),
        ),
        8.verticalSpace,
        _buildInfoFieldInCard(
          'Jam Absensi',
          detail.checkIn != null ? _formatTime(detail.checkIn!) : '-',
        ),
        16.verticalSpace,
        _buildImageCard('Pakaian Personil', detail.photoPakaian?.url),
        16.verticalSpace,
        _buildTextAreaFieldInCard(
          'Laporan Pengamanan',
          (detail.notes != null && detail.notes!.isNotEmpty) ? detail.notes! : '-',
        ),
        16.verticalSpace,
        _buildImageCard('Foto Pengamanan', detail.photoPengamanan?.url),
      ],
    );
  }

  Widget _buildSelesaiBekerjaSection(AttendanceRekapDetailEntity detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selesai Bekerja',
          style: TS.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: neutral90,
          ),
        ),
        8.verticalSpace,
        _buildInfoFieldInCard('Status Selesai Bekerja', detail.statusKerja ?? '-'),
        16.verticalSpace,
        _buildImageCard('Pakaian Personil', detail.photoCheckoutPakaian?.url),
        16.verticalSpace,
        _buildInfoFieldInCard('Lokasi Pengamanan', detail.location ?? '-'),
        if (detail.patrol == 'Yes' && detail.route != null) ...[
          16.verticalSpace,
          _buildPatrolSectionInCard(detail.route!, detail.listCarryOver),
        ],
        16.verticalSpace,
        _buildImageCard('Bukti Penyelesaian Tugas Lanjutan', detail.photoCheckout?.url),
        16.verticalSpace,
        _buildTextAreaFieldInCard(
          'Laporan Pengamanan',
          (detail.notesCheckout != null && detail.notesCheckout!.isNotEmpty)
              ? detail.notesCheckout!
              : '-',
        ),
        16.verticalSpace,
        _buildImageCard('Foto Pengamanan', detail.photoCheckoutPengamanan?.url),
        if (detail.carryOver != null && detail.carryOver!.isNotEmpty) ...[
          16.verticalSpace,
          _buildTextAreaFieldInCard('Tugas Tertunda', detail.carryOver!),
        ],
        16.verticalSpace,
        _buildInfoFieldInCard(
          'Jam Selesai Bekerja',
          detail.checkOut != null ? _formatTime(detail.checkOut!) : '-',
        ),
        16.verticalSpace,
        _buildInfoFieldInCard('Lembur', detail.isOvertime ? 'Ya' : 'Tidak'),
        16.verticalSpace,
        _buildImageCard('Bukti Lembur', detail.photoOvertime?.url),
      ],
    );
  }

  Widget _buildProfileSectionInCard(AttendanceRekapDetailEntity detail) {
    return Padding(
      padding: REdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: detail.photoPegawai != null
                ? CircleAvatar(
                    radius: 40.r,
                    backgroundImage: NetworkImage(detail.photoPegawai!),
                  )
                : CircleAvatar(
                    radius: 40.r,
                    backgroundColor: primaryColor.withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      size: 40.r,
                      color: primaryColor,
                    ),
                  ),
          ),
          12.verticalSpace,
          Center(
            child: Text(
              detail.fullname,
              style: TS.titleMedium.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          4.verticalSpace,
          Center(
            child: Text(
              '${detail.jabatan} - ${detail.nrp}',
              style: TS.bodyMedium.copyWith(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoFieldInCard(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TS.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: neutral90,
          ),
        ),
        8.verticalSpace,
        Container(
          width: double.infinity,
          padding: REdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(value, style: TS.bodyMedium),
        ),
      ],
    );
  }

  Widget _buildTextAreaFieldInCard(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TS.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: neutral90,
          ),
        ),
        8.verticalSpace,
        Container(
          width: double.infinity,
          padding: REdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(value, style: TS.bodyMedium),
        ),
      ],
    );
  }

  Widget _buildImageCard(String label, String? imageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TS.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: neutral90,
          ),
        ),
        8.verticalSpace,
        if (imageUrl != null && imageUrl.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              imageUrl,
              height: 200.h,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200.h,
                  width: double.infinity,
                  color: Colors.grey.shade100,
                  child: const Center(child: Icon(Icons.broken_image)),
                );
              },
            ),
          )
        else
          Container(
            height: 100.h,
            width: double.infinity,
            padding: REdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(Icons.image_outlined, color: Colors.grey.shade600),
                8.horizontalSpace,
                Expanded(
                  child: Text(
                    'Tidak ada gambar',
                    style: TS.bodyMedium.copyWith(color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildPatrolSectionInCard(String routeName, List<CarryOverItem> listCarryOver) {
    final allChecked = listCarryOver.isNotEmpty && listCarryOver.every((item) => item.isCompleted);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              routeName,
              style: TS.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: neutral90,
              ),
            ),
            if (!allChecked && listCarryOver.isNotEmpty) ...[
              8.horizontalSpace,
              Text(
                '(Belum Selesai Diperiksa)',
                style: TS.bodySmall.copyWith(color: Colors.red),
              ),
            ],
          ],
        ),
        if (listCarryOver.isEmpty) ...[
          16.verticalSpace,
          Text(
            'Belum ada data patroli',
            style: TS.bodyMedium.copyWith(color: Colors.grey.shade600),
          ),
        ] else ...[
          16.verticalSpace,
          ...listCarryOver.map(_buildPatrolItem),
        ],
      ],
    );
  }

  Widget _buildPatrolItem(CarryOverItem item) {
    final isCompleted = item.isCompleted;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: REdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isCompleted ? Colors.green : Colors.orange,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: isCompleted ? Colors.green : Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Text(item.note, style: TS.bodyMedium.copyWith(color: neutral90)),
          ),
          8.horizontalSpace,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: isCompleted
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              item.status,
              style: TS.bodySmall.copyWith(
                color: isCompleted ? Colors.green : Colors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
          16.verticalSpace,
          Text(
            'Terjadi Kesalahan',
            style: TS.titleMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          8.verticalSpace,
          Text(
            message,
            style: TS.bodyMedium.copyWith(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          24.verticalSpace,
          ElevatedButton(
            onPressed: () {
              context.read<AttendanceRekapDetailBloc>().add(
                    LoadAttendanceRekapDetailEvent(widget.idAttendance),
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    try {
      final formatter = DateFormat('d MMMM yyyy', 'id_ID');
      return formatter.format(date);
    } catch (e) {
      final formatter = DateFormat('d MMMM yyyy');
      return formatter.format(date);
    }
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('dd MMMM yyyy - HH.mm', 'id_ID').format(dateTime) + ' WIB';
  }

  String _formatStatusLaporan(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Menunggu Verifikasi';
      case 'CHECKIN':
        return 'Check In';
      case 'CHECKOUT':
        return 'Check Out';
      case 'REVISI':
        return 'Revisi';
      default:
        return status;
    }
  }
}
