import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../../../core/di/injection.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/Buttons/ui_button.dart';
import '../../../../shared/widgets/confirm_dialog.dart';
import '../bloc/cuti_bloc.dart';
import '../bloc/cuti_event.dart';
import '../bloc/cuti_state.dart';
import '../dialogs/success_dialog.dart';
import '../../domain/entities/cuti_entity.dart';

class DetailCutiPage extends StatefulWidget {
  final String cutiId;
  final bool showActions;
  final UserRole currentUserRole;

  const DetailCutiPage({
    Key? key,
    required this.cutiId,
    this.showActions = false,
    required this.currentUserRole,
  }) : super(key: key);

  @override
  State<DetailCutiPage> createState() => _DetailCutiPageState();
}

class _DetailCutiPageState extends State<DetailCutiPage> {
  final _feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDetailCuti();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _loadDetailCuti() {
    context.read<CutiBloc>().add(GetDetailCutiEvent(widget.cutiId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<CutiBloc>()..add(GetDetailCutiEvent(widget.cutiId)),
      child: AppScaffold(
        child: BlocListener<CutiBloc, CutiState>(
          listener: (context, state) {
            if (state is StatusCutiUpdated) {
              SuccessDialog.show(
                context: context,
                title: 'Status Berhasil Diperbarui',
                message: 'Status cuti telah berhasil diperbarui.',
                buttonText: 'Kembali',
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Close detail page
                },
              );
            } else if (state is CutiError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          child: BlocBuilder<CutiBloc, CutiState>(
            builder: (context, state) {
              if (state is CutiLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: primaryColor),
                );
              }

              if (state is CutiError) {
                return _buildErrorWidget(state.message);
              }

              if (state is DetailCutiLoaded) {
                return _buildDetailContent(state.cuti);
              }

              return const Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailContent(CutiEntity cuti) {
    final formatter = DateFormat('dd/MM/yyyy');

    return SingleChildScrollView(
      padding: REdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            width: double.infinity,
            padding: REdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getStatusColor(cuti.status),
                  _getStatusColor(cuti.status).withOpacity(0.8)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: _getStatusColor(cuti.status).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        cuti.nama,
                        style: TS.titleLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildStatusChip(cuti.status, isDark: true),
                  ],
                ),
                8.verticalSpace,
                Text(
                  cuti.tipeCutiDisplayName,
                  style: TS.titleMedium.copyWith(
                    color: Colors.white70,
                  ),
                ),
                16.verticalSpace,
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.white70,
                      size: 16.sp,
                    ),
                    8.horizontalSpace,
                    Text(
                      '${formatter.format(cuti.tanggalMulai)} - ${formatter.format(cuti.tanggalSelesai)}',
                      style: TS.bodyMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    12.horizontalSpace,
                    Container(
                      padding:
                          REdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        '${cuti.jumlahHari} hari',
                        style: TS.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          24.verticalSpace,

          // Detail Information
          _buildInfoSection('Informasi Detail', [
            _buildInfoItem('ID Cuti', cuti.id),
            _buildInfoItem(
                'Tanggal Pengajuan', formatter.format(cuti.tanggalPengajuan)),
            if (cuti.reviewerName != null)
              _buildInfoItem('Direview oleh', cuti.reviewerName!),
            if (cuti.tanggalReview != null)
              _buildInfoItem(
                  'Tanggal Review', formatter.format(cuti.tanggalReview!)),
          ]),

          20.verticalSpace,

          // Alasan Section
          _buildInfoSection('Alasan Cuti', [
            _buildTextContent(cuti.alasan),
          ]),

          if (cuti.umpanBalik != null && cuti.umpanBalik!.isNotEmpty) ...[
            20.verticalSpace,
            _buildInfoSection('Feedback', [
              _buildTextContent(cuti.umpanBalik!),
            ]),
          ],

          if (widget.showActions && cuti.status == CutiStatus.pending) ...[
            32.verticalSpace,
            _buildActionButtons(cuti),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TS.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          12.verticalSpace,
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: REdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              '$label:',
              style: TS.bodyMedium.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TS.bodyMedium.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextContent(String text) {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TS.bodyMedium.copyWith(
          color: Colors.black87,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildActionButtons(CutiEntity cuti) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: UIButton(
                text: 'Tolak',
                buttonType: UIButtonType.outline,
                variant: UIButtonVariant.error,
                onPressed: () => _showRejectionDialog(cuti),
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: UIButton(
                text: 'Setujui',
                variant: UIButtonVariant.success,
                onPressed: () => _showApprovalDialog(cuti),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusChip(CutiStatus status, {bool isDark = false}) {
    Color backgroundColor;
    Color textColor;

    if (isDark) {
      backgroundColor = Colors.white.withOpacity(0.2);
      textColor = Colors.white;
    } else {
      switch (status) {
        case CutiStatus.pending:
          backgroundColor = Colors.orange.shade100;
          textColor = Colors.orange.shade700;
          break;
        case CutiStatus.approved:
          backgroundColor = Colors.green.shade100;
          textColor = Colors.green.shade700;
          break;
        case CutiStatus.rejected:
          backgroundColor = Colors.red.shade100;
          textColor = Colors.red.shade700;
          break;
        case CutiStatus.cancelled:
          backgroundColor = Colors.grey.shade100;
          textColor = Colors.grey.shade700;
          break;
      }
    }

    return Container(
      padding: REdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status == CutiStatus.pending
            ? 'Menunggu'
            : status == CutiStatus.approved
                ? 'Disetujui'
                : status == CutiStatus.rejected
                    ? 'Ditolak'
                    : 'Dibatalkan',
        style: TS.bodySmall.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getStatusColor(CutiStatus status) {
    switch (status) {
      case CutiStatus.pending:
        return Colors.orange;
      case CutiStatus.approved:
        return Colors.green;
      case CutiStatus.rejected:
        return Colors.red;
      case CutiStatus.cancelled:
        return Colors.grey;
    }
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.r,
            color: Colors.red,
          ),
          16.verticalSpace,
          Text(
            'Terjadi Kesalahan',
            style: TS.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          8.verticalSpace,
          Text(
            message,
            style: TS.bodyMedium.copyWith(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          24.verticalSpace,
          UIButton(
            text: 'Coba Lagi',
            onPressed: _loadDetailCuti,
          ),
        ],
      ),
    );
  }

  void _showApprovalDialog(CutiEntity cuti) {
    showDialog(
      context: context,
      builder: (context) => _buildFeedbackDialog(
        title: 'Setujui Cuti',
        message: 'Apakah Anda yakin ingin menyetujui ajuan cuti ini?',
        confirmText: 'Setujui',
        isApproval: true,
        cuti: cuti,
      ),
    );
  }

  void _showRejectionDialog(CutiEntity cuti) {
    showDialog(
      context: context,
      builder: (context) => _buildFeedbackDialog(
        title: 'Tolak Cuti',
        message: 'Berikan alasan penolakan ajuan cuti ini:',
        confirmText: 'Tolak',
        isApproval: false,
        cuti: cuti,
      ),
    );
  }

  Widget _buildFeedbackDialog({
    required String title,
    required String message,
    required String confirmText,
    required bool isApproval,
    required CutiEntity cuti,
  }) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      title: Text(
        title,
        style: TS.titleMedium.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TS.bodyMedium,
          ),
          if (!isApproval) ...[
            16.verticalSpace,
            TextField(
              controller: _feedbackController,
              decoration: const InputDecoration(
                hintText: 'Masukkan alasan penolakan...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            _feedbackController.clear();
            Navigator.of(context).pop();
          },
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            final feedback =
                isApproval ? 'Cuti disetujui' : _feedbackController.text.trim();

            if (!isApproval && feedback.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Alasan penolakan harus diisi'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            context.read<CutiBloc>().add(
                  UpdateStatusCutiEvent(
                    cutiId: cuti.id,
                    status:
                        isApproval ? CutiStatus.approved : CutiStatus.rejected,
                    reviewerId: 'current_reviewer', // TODO: Get from auth
                    reviewerName: 'Current Reviewer', // TODO: Get from auth
                    umpanBalik: feedback,
                  ),
                );

            _feedbackController.clear();
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isApproval ? Colors.green : Colors.red,
            foregroundColor: Colors.white,
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}
