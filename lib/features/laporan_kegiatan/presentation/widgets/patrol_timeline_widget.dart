import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/styles.dart';
import '../../../../core/design/colors.dart';
import '../../domain/entities/laporan_kegiatan_entity.dart';
import 'package:intl/intl.dart';

class PatrolTimelineWidget extends StatelessWidget {
  final String routeName;
  final List<PatrolCheckpoint> checkpoints;
  final bool isDiperiksa;

  const PatrolTimelineWidget({
    Key? key,
    required this.routeName,
    required this.checkpoints,
    this.isDiperiksa = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy - HH.mm', 'id_ID');
    final timeFormat = DateFormat('HH.mm', 'id_ID');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Route Header
        Row(
          children: [
            Text(
              routeName,
              style: TS.titleSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            if (!isDiperiksa) ...[
              8.horizontalSpace,
              Container(
                padding: REdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'Belum Selesai Diperiksa',
                  style: TS.labelSmall.copyWith(
                    color: errorColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        16.verticalSpace,

        // Timeline
        if (checkpoints.isEmpty)
          Padding(
            padding: REdgeInsets.only(left: 20),
            child: Text(
              'Belum ada checkpoint',
              style: TS.bodySmall.copyWith(color: Colors.grey[600]),
            ),
          )
        else
          ...checkpoints.asMap().entries.map((entry) {
            final index = entry.key;
            final checkpoint = entry.value;
            final isLast = index == checkpoints.length - 1;

            return _buildTimelineItem(
              checkpoint: checkpoint,
              dateFormat: dateFormat,
              timeFormat: timeFormat,
              isLast: isLast,
            );
          }).toList(),
      ],
    );
  }

  Widget _buildTimelineItem({
    required PatrolCheckpoint checkpoint,
    required DateFormat dateFormat,
    required DateFormat timeFormat,
    required bool isLast,
  }) {
    final isCompleted = checkpoint.status == 'Selesai' && checkpoint.buktiUrl != null;
    final isTambahan = checkpoint.status == 'Tambahan';
    final dotColor = isCompleted
        ? const Color(0xFF1E88E5)
        : checkpoint.buktiUrl == null
            ? errorColor
            : Colors.grey;
    final lineColor = isCompleted
        ? const Color(0xFF1E88E5)
        : Colors.grey[300]!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 16.w,
              height: 16.w,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2.w,
                height: 60.h,
                color: lineColor,
                margin: REdgeInsets.symmetric(vertical: 4),
              ),
          ],
        ),
        12.horizontalSpace,

        // Checkpoint content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkpoint name
              Text(
                checkpoint.name,
                style: TS.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              4.verticalSpace,

              // Timestamp
              if (checkpoint.timestamp != null)
                Text(
                  dateFormat.format(checkpoint.timestamp!),
                  style: TS.bodySmall.copyWith(
                    color: Colors.grey[600],
                  ),
                )
              else
                Text(
                  '-',
                  style: TS.bodySmall.copyWith(
                    color: Colors.grey[400],
                  ),
                ),

              // Proof file
              if (checkpoint.buktiUrl != null) ...[
                4.verticalSpace,
                GestureDetector(
                  onTap: () {
                    // Open image preview
                  },
                  child: Text(
                    checkpoint.buktiUrl!,
                    style: TS.bodySmall.copyWith(
                      color: const Color(0xFF1E88E5),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ] else if (checkpoint.status != 'Tambahan') ...[
                4.verticalSpace,
                Text(
                  '-',
                  style: TS.bodySmall.copyWith(
                    color: Colors.grey[400],
                  ),
                ),
              ],

              // Tambahan label
              if (isTambahan) ...[
                4.verticalSpace,
                Container(
                  padding: REdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'Tambahan',
                    style: TS.labelSmall.copyWith(
                      color: Colors.orange[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}



