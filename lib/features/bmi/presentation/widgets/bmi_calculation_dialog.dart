import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../../../core/constants/enums.dart';
import '../../../../shared/widgets/Buttons/ui_button.dart';
import '../../../../shared/widgets/TextInput/input_primary.dart';
import '../bloc/bmi_bloc.dart';

/// Dialog untuk kalkulasi BMI
class BMICalculationDialog extends StatefulWidget {
  final String userId;
  final String userName;
  final double? initialWeight;
  final double? initialHeight;
  final String? recordedBy;
  final VoidCallback? onCalculated;

  const BMICalculationDialog({
    Key? key,
    required this.userId,
    required this.userName,
    this.initialWeight,
    this.initialHeight,
    this.recordedBy,
    this.onCalculated,
  }) : super(key: key);

  @override
  State<BMICalculationDialog> createState() => _BMICalculationDialogState();
}

class _BMICalculationDialogState extends State<BMICalculationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _notesController = TextEditingController();

  BMIBloc get _bmiBloc => context.read<BMIBloc>();

  @override
  void initState() {
    super.initState();

    // Set initial values if provided
    if (widget.initialWeight != null) {
      _weightController.text = widget.initialWeight!.toStringAsFixed(1);
    }
    if (widget.initialHeight != null) {
      _heightController.text = widget.initialHeight!.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _calculateBMI() {
    if (_formKey.currentState?.validate() ?? false) {
      final weight = double.tryParse(_weightController.text);
      final height = double.tryParse(_heightController.text);

      if (weight != null && height != null) {
        _bmiBloc.add(BMICalculate(
          userId: widget.userId,
          weight: weight,
          height: height,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          recordedBy: widget.recordedBy,
        ));
      }
    }
  }

  String? _validateWeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Berat badan harus diisi';
    }

    final weight = double.tryParse(value);
    if (weight == null) {
      return 'Format berat badan tidak valid';
    }

    if (weight <= 0 || weight > 1000) {
      return 'Berat badan harus antara 1-1000 kg';
    }

    return null;
  }

  String? _validateHeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Tinggi badan harus diisi';
    }

    final height = double.tryParse(value);
    if (height == null) {
      return 'Format tinggi badan tidak valid';
    }

    if (height <= 0 || height > 300) {
      return 'Tinggi badan harus antara 1-300 cm';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BMIBloc, BMIState>(
      listener: (context, state) {
        if (state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: errorColor,
            ),
          );
        } else if (state.hasLatestBMI) {
          // Show success and close dialog
          Navigator.of(context).pop();
          widget.onCalculated?.call();

          // Show result dialog
          _showBMIResultDialog(context, state.latestBMIRecord!);
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: REdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hitung Body Mass Index',
                            style: TS.titleLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          4.verticalSpace,
                          Text(
                            widget.userName,
                            style: TS.bodyMedium.copyWith(
                              color: neutral70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      style: IconButton.styleFrom(
                        backgroundColor: neutral10,
                        foregroundColor: neutral70,
                      ),
                    ),
                  ],
                ),

                24.verticalSpace,

                // Weight Input
                InputPrimary(
                  label: 'Berat Badan',
                  hint: 'Masukkan berat badan (kg)',
                  controller: _weightController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  validation: _validateWeight,
                  suffixIcon: Padding(
                    padding: REdgeInsets.only(right: 12),
                    child: Text(
                      'KG',
                      style: TS.bodyMedium.copyWith(
                        color: neutral50,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  margin: REdgeInsets.only(bottom: 16),
                ),

                // Height Input
                InputPrimary(
                  label: 'Tinggi Badan',
                  hint: 'Masukkan tinggi badan (cm)',
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validation: _validateHeight,
                  suffixIcon: Padding(
                    padding: REdgeInsets.only(right: 12),
                    child: Text(
                      'CM',
                      style: TS.bodyMedium.copyWith(
                        color: neutral50,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  margin: REdgeInsets.only(bottom: 16),
                ),

                // Notes Input (Optional)
                InputPrimary(
                  label: 'Catatan (Opsional)',
                  hint: 'Tambahkan catatan...',
                  controller: _notesController,
                  maxLines: 3,
                  margin: REdgeInsets.only(bottom: 24),
                ),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: UIButton(
                        text: 'Batal',
                        buttonType: UIButtonType.outline,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    16.horizontalSpace,
                    Expanded(
                      child: BlocBuilder<BMIBloc, BMIState>(
                        builder: (context, state) {
                          return UIButton(
                            text: 'Hitung Body Mass Index',
                            isLoading: state.isCalculating,
                            onPressed:
                                state.isCalculating ? null : _calculateBMI,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBMIResultDialog(BuildContext context, dynamic bmiRecord) {
    showDialog(
      context: context,
      builder: (context) => BMIResultDialog(
        bmiRecord: bmiRecord,
        userName: widget.userName,
      ),
    );
  }
}

/// Dialog untuk menampilkan hasil BMI
class BMIResultDialog extends StatelessWidget {
  final dynamic bmiRecord;
  final String userName;

  const BMIResultDialog({
    Key? key,
    required this.bmiRecord,
    required this.userName,
  }) : super(key: key);

  Color _getStatusColor(BMIStatus status) {
    switch (status) {
      case BMIStatus.underweight:
        return const Color(0xFF2196F3);
      case BMIStatus.normal:
        return successColor;
      case BMIStatus.overweight:
        return const Color(0xFFFF9800);
      case BMIStatus.obese:
        return errorColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = bmiRecord.status as BMIStatus;
    final statusColor = _getStatusColor(status);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        padding: REdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Status Badge
            Container(
              padding: REdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: statusColor.withOpacity(0.3)),
              ),
              child: Text(
                status.label.toUpperCase(),
                style: TS.labelLarge.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            20.verticalSpace,

            // BMI Value
            Text(
              'Body Mass Index ${bmiRecord.bmi.toStringAsFixed(1)} Kg/M2',
              style: TS.headlineMedium.copyWith(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),

            8.verticalSpace,

            Text(
              userName,
              style: TS.titleMedium.copyWith(
                color: neutral70,
              ),
            ),

            20.verticalSpace,

            // Details
            Container(
              padding: REdgeInsets.all(16),
              decoration: BoxDecoration(
                color: neutral10,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Berat',
                        style: TS.bodyMedium.copyWith(color: neutral70),
                      ),
                      Text(
                        '${bmiRecord.weight.toStringAsFixed(1)} KG',
                        style: TS.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: neutral90,
                        ),
                      ),
                    ],
                  ),
                  12.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tinggi',
                        style: TS.bodyMedium.copyWith(color: neutral70),
                      ),
                      Text(
                        '${bmiRecord.height.toStringAsFixed(0)} CM',
                        style: TS.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: neutral90,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            16.verticalSpace,

            // Description
            Container(
              padding: REdgeInsets.all(16),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: statusColor.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Text(
                    status.description,
                    style: TS.bodyMedium.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (bmiRecord.notes != null) ...[
                    12.verticalSpace,
                    Text(
                      bmiRecord.notes!,
                      style: TS.bodySmall.copyWith(
                        color: neutral70,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),

            24.verticalSpace,

            // Close Button
            UIButton(
              text: 'Tutup',
              fullWidth: true,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
