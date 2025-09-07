import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/widgets/app_scaffold.dart';

class PanicDisasterSelectionPage extends StatefulWidget {
  const PanicDisasterSelectionPage({super.key});

  @override
  State<PanicDisasterSelectionPage> createState() =>
      _PanicDisasterSelectionPageState();
}

class _PanicDisasterSelectionPageState
    extends State<PanicDisasterSelectionPage> {
  String? selectedDisaster;

  final List<Map<String, dynamic>> disasters = [
    {
      'id': 'keamanan_kecelakaan_kerja',
      'title': 'Keamanan dan Kecelakaan Kerja',
      'icon': Icons.security,
      'color': Color(0xFFE74C3C),
    },
    {
      'id': 'bencana_alam',
      'title': 'Bencana Alam',
      'icon': Icons.nature_outlined,
      'color': Color(0xFFE67E22),
    },
    {
      'id': 'kebakaran',
      'title': 'Kebakaran',
      'icon': Icons.local_fire_department,
      'color': Color(0xFFFF5722),
    },
    {
      'id': 'medis',
      'title': 'Medis',
      'icon': Icons.medical_services,
      'color': Color(0xFF2ECC71),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text(
          'Panic Button',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: Padding(
        padding: REdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jenis keadaan darurat yang sesuai',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            24.verticalSpace,

            // Disaster options
            ...disasters.map((disaster) => _buildDisasterOption(disaster)),

            50.verticalSpace,

            // Continue button
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: selectedDisaster != null
                    ? () {
                        Navigator.pushNamed(
                          context,
                          '/panic-incident-form',
                          arguments: selectedDisaster,
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedDisaster != null
                      ? const Color(0xFFE74C3C)
                      : Colors.grey[300],
                  foregroundColor: selectedDisaster != null
                      ? Colors.white
                      : Colors.grey[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'AKTIFKAN',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisasterOption(Map<String, dynamic> disaster) {
    final isSelected = selectedDisaster == disaster['id'];
    return Container(
      margin: REdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedDisaster = disaster['id'];
          });
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: REdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? disaster['color'].withOpacity(0.1)
                : Colors.grey[50],
            border: Border.all(
              color: isSelected ? disaster['color'] : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: isSelected ? disaster['color'] : Colors.grey[400],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  disaster['icon'],
                  color: Colors.white,
                  size: 24.r,
                ),
              ),
              16.horizontalSpace,
              Expanded(
                child: Text(
                  disaster['title'],
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? disaster['color'] : Colors.black87,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: disaster['color'],
                  size: 24.r,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
