import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../domain/entities/tugas_lanjutan_entity.dart';
import 'package:intl/intl.dart';

class TugasLanjutanCard extends StatelessWidget {
  final TugasLanjutanEntity tugas;
  final VoidCallback onTap;
  final bool? isCheckedIn; // Checkin status from get_current API
  final bool? isCheckedOut; // Checkout status from get_current API

  const TugasLanjutanCard({
    Key? key,
    required this.tugas,
    required this.onTap,
    this.isCheckedIn,
    this.isCheckedOut,
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () => _showDetailModal(context),
        child: Container(
          margin: REdgeInsets.only(bottom: 16),
          padding: REdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and "Selesai" button
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
                  if (tugas.status == TugasLanjutanStatus.selesai ||
                      tugas.status == TugasLanjutanStatus.terverifikasi)
                    Container(
                      padding:
                          REdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E3A8A),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Selesai',
                        style: TS.labelSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),

              12.verticalSpace,

              // Details
              _buildDetailRow(
                  'Lokasi', ': ${tugas.lokasi.isEmpty ? '' : tugas.lokasi}'),
              4.verticalSpace,
              _buildDetailRow('Pelapor', ': ${tugas.pelapor}'),
              4.verticalSpace,
              _buildDetailRow(
                'Tanggal',
                ': ${dateFormat.format(tugas.tanggal)} WIB',
              ),

              12.verticalSpace,

              // Description
              if (tugas.deskripsi.isNotEmpty)
                _ExpandableText(
                  tugas.deskripsi,
                  maxChars: 400,
                  style: TS.bodySmall.copyWith(color: Colors.grey[700]),
                ),

              if (tugas.deskripsi.isNotEmpty) 12.verticalSpace,

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
                      style: TS.bodySmall.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    4.verticalSpace,
                    if (tugas.tanggalSelesai != null)
                      Text(
                        dateFormat.format(tugas.tanggalSelesai!) + ' WIB',
                        style: TS.bodySmall.copyWith(color: Colors.grey[600]),
                      ),
                    8.verticalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bukti',
                          style: TS.bodySmall.copyWith(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        8.verticalSpace,
                        if (tugas.buktiUrl != null &&
                            tugas.buktiUrl!.isNotEmpty)
                          GestureDetector(
                            onTap: () => _showFullImageModal(context, tugas.buktiUrl!),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.network(
                                tugas.buktiUrl!,
                                width: double.infinity,
                                height: 120.h,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: double.infinity,
                                    height: 120.h,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.broken_image_outlined,
                                        color: Colors.grey[400],
                                        size: 32.sp,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        else
                          Container(
                            width: double.infinity,
                            height: 120.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Center(
                              child: Text(
                                '-',
                                style: TS.bodyMedium.copyWith(color: Colors.grey[400]),
                              ),
                            ),
                          ),
                      ],
                    ),
                    16.verticalSpace,
                  ],
                )
              else
                16.verticalSpace,

              // Action Button (always visible, but disabled if completed or not checked in)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      (tugas.status == TugasLanjutanStatus.belum &&
                              isCheckedIn == true &&
                              (isCheckedOut ?? false) == false)
                          ? onTap
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        (tugas.status == TugasLanjutanStatus.belum &&
                                isCheckedIn == true &&
                                (isCheckedOut ?? false) == false)
                            ? primaryColor
                            : Colors.grey[400],
                    disabledBackgroundColor: Colors.grey[400],
                    padding: REdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Tandai Sebagai Selesai',
                    style: TS.labelLarge.copyWith(
                      color: (tugas.status == TugasLanjutanStatus.belum &&
                              isCheckedIn == true &&
                              (isCheckedOut ?? false) == false)
                          ? Colors.white
                          : Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDetailModal(BuildContext context) async {
    final dateFormat = DateFormat('dd-MM-yyyy HH:mm');

    if (!context.mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Padding(
              padding: REdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                  12.verticalSpace,
                  Text(
                    'Detail Tugas Lanjutan',
                    style: TS.titleMedium.copyWith(fontWeight: FontWeight.bold),
                  ),
                  12.verticalSpace,
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow(
                              'Status', ': ${_getStatusText(tugas.status)}'),
                          8.verticalSpace,
                          _buildDetailRow('Lokasi', ': ${tugas.lokasi}'),
                          8.verticalSpace,
                          _buildDetailRow(
                            'Tugas',
                            ': ${tugas.deskripsi?.isNotEmpty == true ? tugas.deskripsi! : '-'}',
                          ),
                          8.verticalSpace,
                          Text(
                            'Bukti Penyelesaian',
                            style: TS.titleSmall
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          8.verticalSpace,
                          if (tugas.buktiUrl?.isNotEmpty == true)
                            GestureDetector(
                              onTap: () => _showFullImageModal(context, tugas.buktiUrl!),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Image.network(
                                  tugas.buktiUrl!,
                                  width: double.infinity,
                                  height: 180.h,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: double.infinity,
                                      padding: REdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      child: Text(
                                        tugas.buktiUrl!,
                                        style: TS.bodySmall
                                            .copyWith(color: Colors.black54),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          else
                            Container(
                              width: double.infinity,
                              padding: REdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text('-', style: TS.bodyMedium),
                            ),
                          8.verticalSpace,
                          _buildDetailRow(
                            'Catatan',
                            ': ${tugas.catatan?.isNotEmpty == true ? tugas.catatan! : '-'}',
                          ),
                          8.verticalSpace,
                          _buildDetailRow(
                            'Diselesaikan Oleh',
                            ': ${tugas.diselesaikanOleh?.isNotEmpty == true ? tugas.diselesaikanOleh! : '-'}',
                          ),
                          8.verticalSpace,
                          _buildDetailRow(
                            'Diselesaikan Pada',
                            ': ${tugas.tanggalSelesai != null ? dateFormat.format(tugas.tanggalSelesai!) : '-'}',
                          ),
                          16.verticalSpace,
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[200],
                                padding: REdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Tutup',
                                style: TS.labelLarge
                                    .copyWith(color: Colors.black87),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TS.bodySmall.copyWith(color: Colors.grey[600]),
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

  Future<void> _showFullImageModal(BuildContext context, String imageUrl) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(16.w),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Full image
            GestureDetector(
              onTap: () => Navigator.of(ctx).pop(),
              child: InteractiveViewer(
                panEnabled: true,
                boundaryMargin: const EdgeInsets.all(80),
                minScale: 0.5,
                maxScale: 4,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.black87,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image_outlined,
                              color: Colors.white,
                              size: 64.sp,
                            ),
                            16.verticalSpace,
                            Text(
                              'Gagal memuat gambar',
                              style: TS.bodyMedium.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Close button
            Positioned(
              top: 16.h,
              right: 16.w,
              child: GestureDetector(
                onTap: () => Navigator.of(ctx).pop(),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpandableText extends StatefulWidget {
  final String text;
  final int maxChars;
  final TextStyle? style;

  const _ExpandableText(
    this.text, {
    required this.maxChars,
    this.style,
  });

  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final fullText = widget.text;
    final isLong = fullText.length > widget.maxChars;
    final displayText = !_expanded && isLong
        ? '${fullText.substring(0, widget.maxChars)}...'
        : fullText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(displayText, style: widget.style),
        if (isLong)
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: REdgeInsets.only(top: 4),
              child: Text(
                _expanded ? 'Less' : 'More',
                style: (widget.style ?? const TextStyle())
                    .copyWith(color: primaryColor, fontWeight: FontWeight.w600),
              ),
            ),
          ),
      ],
    );
  }
}
