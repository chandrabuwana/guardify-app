import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/styles.dart';
import '../../../../shared/widgets/TextInput/input_primary.dart';

class AttendanceFormWidget extends StatefulWidget {
  final Function(String fieldName, String value) onFormChanged;
  final Function(String photoPath) onPhotoCaptured;
  final VoidCallback onPhotoRemoved;

  const AttendanceFormWidget({
    super.key,
    required this.onFormChanged,
    required this.onPhotoCaptured,
    required this.onPhotoRemoved,
  });

  @override
  State<AttendanceFormWidget> createState() => _AttendanceFormWidgetState();
}

class _AttendanceFormWidgetState extends State<AttendanceFormWidget> {
  final _personalClothingController = TextEditingController();
  final _securityReportController = TextEditingController();
  final _photoController = TextEditingController();
  final _patrolRouteController = TextEditingController();

  String? _capturedPhotoPath;

  @override
  void dispose() {
    _personalClothingController.dispose();
    _securityReportController.dispose();
    _photoController.dispose();
    _patrolRouteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Personal Clothing Field
        InputPrimary(
          label: 'Pakaian Personil',
          controller: _personalClothingController,
          hint: 'Pakaian Personil ---',
          maxLines: 1,
          onChanged: (value) {
            widget.onFormChanged('personalClothing', value);
          },
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.camera_alt, color: Colors.grey[600]),
                onPressed: _capturePhoto,
              ),
              IconButton(
                icon: Icon(Icons.attach_file, color: Colors.grey[600]),
                onPressed: _attachFile,
              ),
            ],
          ),
        ),

        20.verticalSpace,

        // Security Report Field
        InputPrimary(
          label: 'Laporan Pengamanan',
          controller: _securityReportController,
          hint: 'Keterangan Pengamanan',
          maxLines: 4,
          minLines: 4,
          onChanged: (value) {
            widget.onFormChanged('securityReport', value);
          },
        ),

        20.verticalSpace,

        // Photo Field
        InputPrimary(
          label: 'Foto Pengamanan',
          controller: _photoController,
          hint: 'Foto Pengamanan',
          readOnly: true,
          onTap: _capturePhoto,
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.camera_alt, color: Colors.grey[600]),
                onPressed: _capturePhoto,
              ),
              IconButton(
                icon: Icon(Icons.attach_file, color: Colors.grey[600]),
                onPressed: _attachFile,
              ),
            ],
          ),
        ),

        if (_capturedPhotoPath != null) ...[
          10.verticalSpace,
          Container(
            width: double.infinity,
            padding: REdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green[600],
                  size: 20.r,
                ),
                12.horizontalSpace,
                Expanded(
                  child: Text(
                    'Foto berhasil diambil',
                    style: TS.bodyMedium.copyWith(
                      color: Colors.green[700],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.red[600],
                    size: 20.r,
                  ),
                  onPressed: () {
                    setState(() {
                      _capturedPhotoPath = null;
                      _photoController.clear();
                    });
                    widget.onPhotoRemoved();
                  },
                ),
              ],
            ),
          ),
        ],

        20.verticalSpace,

        // Patrol Route Field
        InputPrimary(
          label: 'Tugas Lanjutan',
          controller: _patrolRouteController,
          hint: '3 Tugas Lanjutan',
          readOnly: true,
          onTap: _selectPatrolRoute,
          suffixIcon: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _capturePhoto() {
    // Simulate photo capture
    setState(() {
      _capturedPhotoPath =
          '/mock/path/to/photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
      _photoController.text = 'Foto diambil';
    });
    widget.onPhotoCaptured(_capturedPhotoPath!);
  }

  void _attachFile() {
    // Simulate file attachment
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('File Attachment'),
        content: const Text('File attachment feature will be implemented.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _selectPatrolRoute() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Pilih Tugas Lanjutan',
          style: TS.titleMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRouteOption('3 Tugas Lanjutan'),
            _buildRouteOption('Patroli Rute A'),
            _buildRouteOption('Patroli Rute B'),
            _buildRouteOption('Pengamanan Khusus'),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteOption(String route) {
    return ListTile(
      title: Text(route),
      onTap: () {
        setState(() {
          _patrolRouteController.text = route;
        });
        widget.onFormChanged('patrolRoute', route);
        Navigator.of(context).pop();
      },
    );
  }
}
