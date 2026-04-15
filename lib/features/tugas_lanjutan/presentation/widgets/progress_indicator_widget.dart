import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final Map<String, dynamic> summary;

  const ProgressIndicatorWidget({
    Key? key,
    required this.summary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final total = summary['total'] as int? ?? 0;
    final selesai = summary['selesai'] as int? ?? 0;
    final progress = summary['progress'] as double? ?? 0.0;

    return Container(
      padding: REdgeInsets.all(24),
      color: Colors.white,
      child: Column(
        children: [
          // Circular Progress
          SizedBox(
            width: 120.w,
            height: 120.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120.w,
                  height: 120.h,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12.w,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$selesai/$total',
                      style: TS.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    Text(
                      'Tugas Selesai',
                      style: TS.labelSmall.copyWith(
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

