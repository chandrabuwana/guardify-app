import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
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
    final borderColor = _getBorderColor(result.status);
    final statusText = _getStatusText(result.status);

    return Container(
      margin: REdgeInsets.only(bottom: 16),
      child: Stack(
        children: [
          // Main card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: const Color(0xFFE0E0E0),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: REdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header dengan ID & Tipe
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ID : ${result.id}',
                        style: TS.bodyMedium.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      if (result.tipeTest != null)
                        Text(
                          'Tipe : ${result.tipeTest}',
                          style: TS.bodyMedium.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                    ],
                  ),

                  8.verticalSpace,

                  // Nama Ujian
                  RichText(
                    text: TextSpan(
                      style: TS.bodyMedium.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        const TextSpan(text: 'Nama Ujian        : '),
                        TextSpan(
                          text: result.namaTest,
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),

                  4.verticalSpace,

                  // Tanggal Ujian
                  RichText(
                    text: TextSpan(
                      style: TS.bodyMedium.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        const TextSpan(text: 'Tanggal Ujian   : '),
                        TextSpan(
                          text: DateFormat('dd MMMM yyyy', 'id').format(result.tanggalTest),
                        ),
                      ],
                    ),
                  ),

                  4.verticalSpace,

                  // Nilai Ujian
                  RichText(
                    text: TextSpan(
                      style: TS.bodyMedium.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        const TextSpan(text: 'Nilai Ujian        : '),
                        TextSpan(
                          text: result.status == TestKelulusanStatus.belumDinilai 
                              ? '-'
                              : '${result.nilaiTest}',
                        ),
                      ],
                    ),
                  ),

                  4.verticalSpace,

                  // Nilai KKM
                  RichText(
                    text: TextSpan(
                      style: TS.bodyMedium.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        const TextSpan(text: 'Nilai KKM         : '),
                        TextSpan(text: '${result.nilaiKKM}'),
                      ],
                    ),
                  ),

                  8.verticalSpace,

                  // Status
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Status : $statusText',
                      style: TS.bodyMedium.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Left border color indicator
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4.w,
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.r),
                  bottomLeft: Radius.circular(8.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(TestKelulusanStatus status) {
    switch (status) {
      case TestKelulusanStatus.lulus:
        return const Color(0xFF4CAF50); // Green untuk text status
      case TestKelulusanStatus.tidakLulus:
        return const Color(0xFFE53935); // Red untuk text status
      case TestKelulusanStatus.belumDinilai:
        return Colors.black87; // Black untuk text status
    }
  }

  Color _getBorderColor(TestKelulusanStatus status) {
    switch (status) {
      case TestKelulusanStatus.lulus:
        return const Color(0xFF2196F3); // Blue border untuk Lulus
      case TestKelulusanStatus.tidakLulus:
        return const Color(0xFFB71C1C); // Red border untuk Tidak Lulus
      case TestKelulusanStatus.belumDinilai:
        return Colors.black87; // Black border untuk Belum Dinilai
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
}

