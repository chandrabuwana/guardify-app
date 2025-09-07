import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/widgets/red_card_widget.dart';

class ReportSection extends StatelessWidget {
  final VoidCallback? onActivityReportTap;
  final VoidCallback? onIncidentReportTap;
  final VoidCallback? onStartWorkTap;

  const ReportSection({
    super.key,
    this.onActivityReportTap,
    this.onIncidentReportTap,
    this.onStartWorkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: RedCardWidget(
                  title: 'Laporan\nKegiatan',
                  onTap: onActivityReportTap,
                  height: 80.h,
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: RedCardWidget(
                  title: 'Laporan\nKejadian',
                  onTap: onIncidentReportTap,
                  height: 80.h,
                ),
              ),
            ],
          ),
          12.verticalSpace,
          RedCardWidget(
            title: 'Mulai Bekerja',
            isFullWidth: true,
            height: 60.h,
            onTap: onStartWorkTap,
          ),
        ],
      ),
    );
  }
}
