import 'package:flutter/material.dart';
import '../../../../shared/widgets/quick_action_button.dart';

class QuickActionsSection extends StatelessWidget {
  final VoidCallback? onRecapTap;
  final VoidCallback? onSubmissionTap;
  final VoidCallback? onRegulationTap;
  final VoidCallback? onBMITap;
  final VoidCallback? onTestResultTap;

  const QuickActionsSection({
    super.key,
    this.onRecapTap,
    this.onSubmissionTap,
    this.onRegulationTap,
    this.onBMITap,
    this.onTestResultTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          QuickActionButton(
            icon: Icons.summarize,
            label: 'Rekapitulasi\nKehadiran',
            onTap: onRecapTap,
          ),
          QuickActionButton(
            icon: Icons.assignment,
            label: 'Pengajuan\nCuti',
            onTap: onSubmissionTap,
          ),
          QuickActionButton(
            icon: Icons.rule,
            label: 'Peraturan\nPerusahaan',
            onTap: onRegulationTap,
          ),
          QuickActionButton(
            icon: Icons.fitness_center,
            label: 'BMI',
            onTap: onBMITap,
          ),
          QuickActionButton(
            icon: Icons.assessment,
            label: 'Hasil\nUjian',
            onTap: onTestResultTap,
          ),
        ],
      ),
    );
  }
}
