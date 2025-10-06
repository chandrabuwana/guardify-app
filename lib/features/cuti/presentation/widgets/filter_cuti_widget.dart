import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../../../shared/widgets/custom_dropdown.dart';

class FilterCutiWidget extends StatefulWidget {
  final Function(String?, String?, DateTime?, DateTime?) onFilterApplied;

  const FilterCutiWidget({
    Key? key,
    required this.onFilterApplied,
  }) : super(key: key);

  @override
  State<FilterCutiWidget> createState() => _FilterCutiWidgetState();
}

class _FilterCutiWidgetState extends State<FilterCutiWidget> {
  String? _selectedStatus;
  String? _selectedTipeCuti;
  DateTime? _tanggalMulai;
  DateTime? _tanggalSelesai;
  bool _isExpanded = false;

  final List<Map<String, String>> _statusOptions = [
    {'value': 'pending', 'label': 'Menunggu'},
    {'value': 'approved', 'label': 'Disetujui'},
    {'value': 'rejected', 'label': 'Ditolak'},
    {'value': 'cancelled', 'label': 'Dibatalkan'},
  ];

  final List<Map<String, String>> _tipeCutiOptions = [
    {'value': 'tahunan', 'label': 'Cuti Tahunan'},
    {'value': 'sakit', 'label': 'Cuti Sakit'},
    {'value': 'melahirkan', 'label': 'Cuti Melahirkan'},
    {'value': 'menikah', 'label': 'Cuti Menikah'},
    {'value': 'keluargaMeninggal', 'label': 'Cuti Keluarga Meninggal'},
    {'value': 'lainnya', 'label': 'Lainnya'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: REdgeInsets.all(16),
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
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(12.r),
              bottom: _isExpanded ? Radius.zero : Radius.circular(12.r),
            ),
            child: Container(
              padding: REdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list,
                    color: primaryColor,
                    size: 20.sp,
                  ),
                  12.horizontalSpace,
                  Text(
                    'Filter Cuti',
                    style: TS.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey.shade600,
                    size: 24.sp,
                  ),
                ],
              ),
            ),
          ),

          // Filter Content
          if (_isExpanded) ...[
            Container(
              padding: REdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  // Status Filter
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Status',
                              style: TS.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            8.verticalSpace,
                            CustomDropdown<String>(
                              label: '',
                              hint: 'Pilih Status',
                              value: _selectedStatus,
                              items: _statusOptions.map((option) {
                                return DropdownItem<String>(
                                  value: option['value']!,
                                  text: option['label']!,
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedStatus = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tipe Cuti',
                              style: TS.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            8.verticalSpace,
                            CustomDropdown<String>(
                              label: '',
                              hint: 'Pilih Tipe',
                              value: _selectedTipeCuti,
                              items: _tipeCutiOptions.map((option) {
                                return DropdownItem<String>(
                                  value: option['value']!,
                                  text: option['label']!,
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedTipeCuti = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  16.verticalSpace,

                  // Date Range Filter
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tanggal Mulai',
                              style: TS.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            8.verticalSpace,
                            _buildDateField(
                              hint: 'Pilih tanggal',
                              selectedDate: _tanggalMulai,
                              onDateSelected: (date) {
                                setState(() {
                                  _tanggalMulai = date;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tanggal Selesai',
                              style: TS.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            8.verticalSpace,
                            _buildDateField(
                              hint: 'Pilih tanggal',
                              selectedDate: _tanggalSelesai,
                              onDateSelected: (date) {
                                setState(() {
                                  _tanggalSelesai = date;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  20.verticalSpace,

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _clearFilter,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey.shade600,
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'Reset',
                            style: TS.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _applyFilter,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'Terapkan',
                            style: TS.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String hint,
    required DateTime? selectedDate,
    required Function(DateTime?) onDateSelected,
  }) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        onDateSelected(date);
      },
      child: Container(
        padding: REdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedDate != null
                    ? '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}'
                    : hint,
                style: TS.bodyMedium.copyWith(
                  color: selectedDate != null
                      ? Colors.black87
                      : Colors.grey.shade500,
                ),
              ),
            ),
            Icon(
              Icons.calendar_today,
              color: Colors.grey.shade600,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _applyFilter() {
    widget.onFilterApplied(
      _selectedStatus,
      _selectedTipeCuti,
      _tanggalMulai,
      _tanggalSelesai,
    );
    setState(() {
      _isExpanded = false;
    });
  }

  void _clearFilter() {
    setState(() {
      _selectedStatus = null;
      _selectedTipeCuti = null;
      _tanggalMulai = null;
      _tanggalSelesai = null;
    });
    widget.onFilterApplied(null, null, null, null);
  }
}
