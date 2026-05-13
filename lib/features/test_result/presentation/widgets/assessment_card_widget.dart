import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/design/styles.dart';
import '../../domain/entities/assessment_entity.dart';
import '../bloc/test_result_bloc.dart';
import '../pages/assessment_detail_page.dart';

/// Widget card untuk menampilkan item Assessment (tanpa nilai)
/// Digunakan untuk Ujian Anggota tab
class AssessmentCardWidget extends StatelessWidget {
  final AssessmentEntity assessment;

  const AssessmentCardWidget({
    Key? key,
    required this.assessment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(assessment.status);
    final borderColor = _getBorderColor(assessment.status);
    final statusText = _getStatusText(assessment.status);

    return GestureDetector(
      onTap: () {
        final bloc = context.read<TestResultBloc>();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: bloc,
              child: AssessmentDetailPage(assessmentId: assessment.id),
            ),
          ),
        );
      },
      child: Container(
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
                  // Header dengan Code & Category
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Code : ${assessment.code ?? assessment.id}',
                        style: TS.bodyMedium.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (assessment.categoryName != null)
                        Text(
                          'Tipe : ${assessment.categoryName}',
                          style: TS.bodyMedium.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                    ],
                  ),

                  8.verticalSpace,

                  // Nama Assessment
                  RichText(
                    text: TextSpan(
                      style: TS.bodyMedium.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        const TextSpan(text: 'Nama Ujian: '),
                        TextSpan(
                          text: assessment.name,
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),

                  4.verticalSpace,

                  // Tanggal Assessment
                  if (assessment.assessmentDate != null)
                    RichText(
                      text: TextSpan(
                        style: TS.bodyMedium.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          const TextSpan(text: 'Tanggal Ujian: '),
                          TextSpan(
                            text: DateFormat('dd MMMM yyyy', 'id')
                                .format(assessment.assessmentDate!),
                          ),
                        ],
                      ),
                    ),

                  4.verticalSpace,

                  // Min Value
                  if (assessment.minValue != null)
                    RichText(
                      text: TextSpan(
                        style: TS.bodyMedium.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          const TextSpan(text: 'Nilai Minimum    : '),
                          TextSpan(text: '${assessment.minValue}'),
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
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.black87;
    
    final lowerStatus = status.toLowerCase();
    if (lowerStatus == 'upcoming' || lowerStatus == 'upcoming') {
      return const Color(0xFF2196F3); // Blue
    } else if (lowerStatus == 'completed' || lowerStatus == 'done') {
      return const Color(0xFF4CAF50); // Green
    } else if (lowerStatus == 'cancelled' || lowerStatus == 'expired') {
      return const Color(0xFFE53935); // Red
    }
    return Colors.black87;
  }

  Color _getBorderColor(String? status) {
    if (status == null) return Colors.black87;
    
    final lowerStatus = status.toLowerCase();
    if (lowerStatus == 'upcoming' || lowerStatus == 'upcoming') {
      return const Color(0xFF2196F3); // Blue
    } else if (lowerStatus == 'completed' || lowerStatus == 'done') {
      return const Color(0xFF4CAF50); // Green
    } else if (lowerStatus == 'cancelled' || lowerStatus == 'expired') {
      return const Color(0xFFB71C1C); // Red
    }
    return Colors.black87;
  }

  String _getStatusText(String? status) {
    if (status == null) return '-';
    
    final lowerStatus = status.toLowerCase();
    if (lowerStatus == 'upcoming') {
      return 'Akan Datang';
    } else if (lowerStatus == 'completed' || lowerStatus == 'done') {
      return 'Selesai';
    } else if (lowerStatus == 'cancelled') {
      return 'Dibatalkan';
    } else if (lowerStatus == 'expired') {
      return 'Kadaluarsa';
    }
    return status;
  }
}
