import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';

class FilterCutiBottomSheet extends StatefulWidget {
  final String? initialStatus;
  final String? initialTipeCuti;
  final DateTime? initialTanggalMulai;
  final DateTime? initialTanggalSelesai;
  final String? initialSort;

  const FilterCutiBottomSheet({
    Key? key,
    this.initialStatus,
    this.initialTipeCuti,
    this.initialTanggalMulai,
    this.initialTanggalSelesai,
    this.initialSort,
  }) : super(key: key);

  @override
  State<FilterCutiBottomSheet> createState() => _FilterCutiBottomSheetState();
}

class _FilterCutiBottomSheetState extends State<FilterCutiBottomSheet> {
  String? _selectedStatus;
  String? _selectedTipeCuti;
  DateTime? _tanggalMulai;
  DateTime? _tanggalSelesai;
  String? _selectedSort;

  final List<Map<String, String?>> _statusOptions = [
    {'value': null, 'label': 'Semua'},
    {'value': 'pending', 'label': 'Pending'},
    {'value': 'approved', 'label': 'Diterima'},
    {'value': 'rejected', 'label': 'Ditolak'},
  ];

  final List<Map<String, String?>> _tipeCutiOptions = [
    {'value': null, 'label': 'Semua'},
    {'value': 'tahunan', 'label': 'Cuti Tahunan'},
    {'value': 'sakit', 'label': 'Cuti Sakit'},
    {'value': 'menikah', 'label': 'Cuti Menikah'},
    {'value': 'melahirkan', 'label': 'Cuti Melahirkan'},
    {'value': 'keluargaMeninggal', 'label': 'Cuti Keluarga Meninggal'},
    {'value': 'lainnya', 'label': 'Lainnya'},
  ];

  final List<Map<String, String>> _sortOptions = [
    {'value': 'terbaru', 'label': 'Terbaru'},
    {'value': 'terlama', 'label': 'Terlama'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.initialStatus;
    _selectedTipeCuti = widget.initialTipeCuti;
    _tanggalMulai = widget.initialTanggalMulai;
    _tanggalSelesai = widget.initialTanggalSelesai;
    _selectedSort = widget.initialSort ?? 'terbaru';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: REdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Filter',
                  style: TS.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.grey.shade600,
                    size: 24.w,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: REdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Section
                  _buildSectionTitle('Status'),
                  12.verticalSpace,
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: _statusOptions.map((option) {
                      final isSelected = _selectedStatus == option['value'];
                      return _buildFilterChip(
                        label: option['label']!,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            _selectedStatus = option['value'];
                          });
                        },
                      );
                    }).toList(),
                  ),

                  24.verticalSpace,

                  // Tipe Cuti Section
                  _buildSectionTitle('Tipe Cuti'),
                  12.verticalSpace,
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: _tipeCutiOptions.map((option) {
                      final isSelected = _selectedTipeCuti == option['value'];
                      return _buildFilterChip(
                        label: option['label']!,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            _selectedTipeCuti = option['value'];
                          });
                        },
                      );
                    }).toList(),
                  ),

                  24.verticalSpace,

                  // Urutkan Section
                  _buildSectionTitle('Urutkan'),
                  12.verticalSpace,
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: _sortOptions.map((option) {
                      final isSelected = _selectedSort == option['value'];
                      return _buildFilterChip(
                        label: option['label']!,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            _selectedSort = option['value'];
                          });
                        },
                      );
                    }).toList(),
                  ),

                  24.verticalSpace,

                  // Periode Section
                  _buildSectionTitle('Periode'),
                  12.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateField(
                          label: 'Tanggal Mulai',
                          selectedDate: _tanggalMulai,
                          onDateSelected: (date) {
                            setState(() {
                              _tanggalMulai = date;
                            });
                          },
                        ),
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: _buildDateField(
                          label: 'Tanggal Selesai',
                          selectedDate: _tanggalSelesai,
                          onDateSelected: (date) {
                            setState(() {
                              _tanggalSelesai = date;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  // Bottom padding for button
                  32.verticalSpace,
                ],
              ),
            ),
          ),

          // Apply Button
          Container(
            padding: REdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'status': _selectedStatus,
                    'tipeCuti': _selectedTipeCuti,
                    'tanggalMulai': _tanggalMulai,
                    'tanggalSelesai': _tanggalSelesai,
                    'sort': _selectedSort,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: REdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Terapkan',
                  style: TS.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TS.titleSmall.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: REdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              Icon(
                Icons.check,
                color: primaryColor,
                size: 16.w,
              ),
            if (isSelected) 4.horizontalSpace,
            Text(
              label,
              style: TS.bodyMedium.copyWith(
                color: isSelected ? primaryColor : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? selectedDate,
    required Function(DateTime?) onDateSelected,
  }) {
    final formatter = DateFormat('dd/MM/yyyy');
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          onDateSelected(date);
        }
      },
      child: Container(
        padding: REdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: Colors.grey.shade600,
              size: 20.w,
            ),
            12.horizontalSpace,
            Expanded(
              child: Text(
                selectedDate != null
                    ? formatter.format(selectedDate)
                    : 'dd/mm/yyyy',
                style: TS.bodyMedium.copyWith(
                  color: selectedDate != null
                      ? Colors.black87
                      : Colors.grey.shade500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

