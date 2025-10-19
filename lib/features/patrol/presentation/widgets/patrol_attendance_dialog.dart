import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
import '../../../../core/design/colors.dart';
import '../bloc/patrol_bloc.dart';
import '../../domain/entities/patrol_location.dart';

class PatrolAttendanceDialog extends StatefulWidget {
  final String routeId;
  final List<PatrolLocation> locations;
  final PatrolLocation currentLocation;

  const PatrolAttendanceDialog({
    super.key,
    required this.routeId,
    required this.locations,
    required this.currentLocation,
  });

  @override
  State<PatrolAttendanceDialog> createState() => _PatrolAttendanceDialogState();
}

class _PatrolAttendanceDialogState extends State<PatrolAttendanceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _proofController = TextEditingController();
  // File? _imageFile;
  // File? _attachmentFile;
  bool _isLoading = false;
  bool _isLocationVerified = false;
  double? _currentLatitude;
  double? _currentLongitude;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _proofController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    // TODO: Implement actual GPS location
    // For now, use mock location near Jakarta
    setState(() {
      _currentLatitude = -6.2088 + (DateTime.now().millisecond % 100) * 0.0001;
      _currentLongitude =
          106.8456 + (DateTime.now().millisecond % 100) * 0.0001;
      _isLocationVerified = true;
    });
  }

  Future<void> _pickImage() async {
    // TODO: Implement camera picker
    // Requires image_picker package: flutter pub add image_picker
    // final picker = ImagePicker();
    // final pickedFile = await picker.pickImage(source: ImageSource.camera);
    // if (pickedFile != null) {
    //   setState(() {
    //     _imageFile = File(pickedFile.path);
    //   });
    // }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Camera picker belum diimplementasi')),
    );
  }

  Future<void> _pickAttachment() async {
    // TODO: Implement file picker for attachments
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('File picker belum diimplementasi')),
    );
  }

  void _submitAttendance() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_isLocationVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verifikasi lokasi terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_currentLatitude == null || _currentLongitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lokasi belum terdeteksi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Add patrol location with current GPS coordinates
    context.read<PatrolBloc>().add(
          AddPatrolLocationEvent(
            routeId: widget.routeId,
            locationName: widget.currentLocation.name,
            latitude: _currentLatitude!,
            longitude: _currentLongitude!,
            radius: 100, // Default radius
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PatrolBloc, PatrolState>(
      listener: (context, state) {
        if (state is PatrolLocationAdded) {
          setState(() {
            _isLoading = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Lokasi berhasil ditambahkan'),
              backgroundColor: Colors.green,
            ),
          );
        }

        if (state is PatrolLoaded) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop(true);

          // Show success dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFF8B0000),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.thumb_up,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Absen Patroli Berhasil',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Terima Kasih',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B0000),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is PatrolError) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Absensi Patroli',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed:
                          _isLoading ? null : () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Lokasi Patroli (Read-only)
                        const Text(
                          'Lokasi Patroli',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.currentLocation.name,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Lokasi Saat Ini (Read-only with GPS)
                        const Text(
                          'Lokasi Saat Ini',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _currentLatitude != null &&
                                    _currentLongitude != null
                                ? 'Lat: ${_currentLatitude!.toStringAsFixed(6)}, Long: ${_currentLongitude!.toStringAsFixed(6)}'
                                : 'Mendeteksi lokasi...',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Bukti Patroli (Proof input with camera)
                        const Text(
                          'Bukti Patroli',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '*',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _proofController,
                          decoration: InputDecoration(
                            hintText: 'Lokasi Kejadian ---',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey[600],
                                  ),
                                  onPressed: _isLoading ? null : _pickImage,
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.attach_file,
                                    color: Colors.grey[600],
                                  ),
                                  onPressed:
                                      _isLoading ? null : _pickAttachment,
                                ),
                              ],
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bukti patroli harus diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Verifikasi Lokasi Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLocationVerified
                                ? null
                                : _getCurrentLocation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isLocationVerified
                                  ? Colors.green[50]
                                  : Colors.blue[50],
                              foregroundColor: _isLocationVerified
                                  ? Colors.green[700]
                                  : Colors.blue[700],
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: _isLocationVerified
                                      ? Colors.green[700]!
                                      : Colors.blue[700]!,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_isLocationVerified)
                                  const Icon(Icons.check_circle, size: 20),
                                if (_isLocationVerified)
                                  const SizedBox(width: 8),
                                Text(
                                  _isLocationVerified
                                      ? 'Verifikasi lokasi berhasil'
                                      : 'Verifikasi lokasi',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _isLoading
                                    ? null
                                    : () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  side: const BorderSide(
                                      color: Color(0xFF8B0000)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Batal',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF8B0000),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed:
                                    _isLoading ? null : _submitAttendance,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8B0000),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Simpan',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
