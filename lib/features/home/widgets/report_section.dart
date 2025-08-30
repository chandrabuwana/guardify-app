import 'package:flutter/material.dart';
import '../../../shared/widgets/red_card_widget.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: RedCardWidget(
                  title: 'Laporan\nKegiatan',
                  onTap: onActivityReportTap,
                  height: 80,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RedCardWidget(
                  title: 'Laporan\nKejadian',
                  onTap: onIncidentReportTap,
                  height: 80,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          RedCardWidget(
            title: 'Mulai Bekerja',
            isFullWidth: true,
            height: 60,
            onTap: onStartWorkTap,
          ),
        ],
      ),
    );
  }
}
