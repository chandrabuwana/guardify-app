import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../core/design/colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/location_service.dart';
import '../bloc/patrol_bloc.dart';
import '../../domain/entities/patrol_location.dart';
import '../../domain/repositories/patrol_repository.dart';

class AddPatrolLocationDialog extends StatefulWidget {
  final String routeId;
  final List<String> existingLocations; // Locations already in the route
  final VoidCallback onLocationAdded;

  const AddPatrolLocationDialog({
    super.key,
    required this.routeId,
    required this.existingLocations,
    required this.onLocationAdded,
  });

  @override
  State<AddPatrolLocationDialog> createState() =>
      _AddPatrolLocationDialogState();
}

class _AddPatrolLocationDialogState extends State<AddPatrolLocationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _proofController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  String? _selectedLocation;
  String _currentLocationText = 'Menunggu...';
  double? _latitude;
  double? _longitude;
  bool _isLocationVerified = false;
  bool _isLoading = false;
  bool _isLoadingAreas = true;
  bool _isLoadingLocation = false;
  List<PatrolLocation> _availableAreas = [];
  String? _errorMessage;
  File? _proofImage;

  @override
  void initState() {
    super.initState();
    _loadAreas();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _proofController.dispose();
    super.dispose();
  }

  Future<void> _loadAreas() async {
    setState(() {
      _isLoadingAreas = true;
      _errorMessage = null;
    });

    try {
      final repository = getIt<PatrolRepository>();
      final result = await repository.getAllAreas();

      result.fold(
        (failure) {
          setState(() {
            _isLoadingAreas = false;
            _errorMessage = 'Gagal memuat daftar area: ${failure.message}';
            _availableAreas = [];
          });
        },
        (areas) {
          // Filter out existing locations
          final filteredAreas = areas
              .where((area) => !widget.existingLocations.contains(area.name))
              .toList();

          setState(() {
            _isLoadingAreas = false;
            _availableAreas = filteredAreas;
          });
        },
      );
    } catch (e) {
      setState(() {
        _isLoadingAreas = false;
        _errorMessage = 'Terjadi kesalahan: $e';
        _availableAreas = [];
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    // Only get current location if no area is selected yet
    if (_selectedLocation == null) {
      setState(() {
        _isLoadingLocation = true;
        _currentLocationText = 'Mengambil lokasi...';
      });

      try {
        final locationService = getIt<LocationService>();
        final position = await locationService.getCurrentLatLng();

        if (position != null) {
          setState(() {
            _latitude = position.lat;
            _longitude = position.lng;
            _currentLocationText =
                '${_latitude!.toStringAsFixed(6)}, ${_longitude!.toStringAsFixed(6)}';
            _isLocationVerified = true;
            _isLoadingLocation = false;
          });
        } else {
          setState(() {
            _currentLocationText = 'Gagal mendapatkan lokasi. Pastikan GPS aktif.';
            _isLocationVerified = false;
            _isLoadingLocation = false;
          });
        }
      } catch (e) {
        setState(() {
          _currentLocationText = 'Error: $e';
          _isLocationVerified = false;
          _isLoadingLocation = false;
        });
      }
    }
  }

  Future<void> _showImagePickerDialog() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Sumber Foto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text('Kamera'),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.green),
                title: const Text('Galeri'),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (source == null) return;

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        setState(() {
          _proofImage = File(image.path);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto berhasil dipilih'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error mengambil foto: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih lokasi patroli'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_latitude == null || _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lokasi belum tersedia, mohon tunggu...'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Call API via BLoC
    context.read<PatrolBloc>().add(
          AddPatrolLocationEvent(
            routeId: widget.routeId,
            locationName: _selectedLocation!,
            latitude: _latitude!,
            longitude: _longitude!,
            radius: 100, // Default radius 100 meters
          ),
        );

    // Wait for BLoC response via BlocListener
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PatrolBloc, PatrolState>(
      listener: (context, state) {
        if (state is PatrolLocationAdded) {
          // Success - location added, data will be reloaded automatically
          if (mounted && _isLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Lokasi patroli berhasil ditambahkan'),
                backgroundColor: Colors.green,
              ),
            );
            // Keep loading, wait for data to reload
          }
        } else if (state is PatrolLoaded && _isLoading) {
          // Data reloaded successfully after adding location
          if (mounted) {
            setState(() {
              _isLoading = false;
            });

            // Close dialog - data already refreshed by BLoC
            Navigator.of(context).pop();
          }
        } else if (state is PatrolError) {
          // Error
          if (mounted && _isLoading) {
            setState(() {
              _isLoading = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Gagal menambahkan lokasi: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      const Center(
                        child: Text(
                          'Absensi Patroli',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Lokasi Patroli Dropdown
                      const Text(
                        'Lokasi Patroli*',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _isLoadingAreas
                          ? Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Memuat daftar area...',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : _errorMessage != null
                              ? Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.red[50],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.red[200]!),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _errorMessage!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.red[700],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextButton(
                                        onPressed: _loadAreas,
                                        child: const Text('Coba Lagi'),
                                      ),
                                    ],
                                  ),
                                )
                              : _availableAreas.isEmpty
                                  ? Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'Tidak ada lokasi patroli yang tersedia',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    )
                                  : DropdownButtonFormField<String>(
                                      value: _selectedLocation,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[100],
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        hintText: 'Pilih lokasi patroli',
                                      ),
                                      items: _availableAreas.map((area) {
                                        return DropdownMenuItem(
                                          value: area.name,
                                          child: Text(area.name),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedLocation = value;
                                          
                                          // Get latitude and longitude from selected Area
                                          if (value != null) {
                                            final selectedArea = _availableAreas
                                                .firstWhere(
                                                  (area) => area.name == value,
                                                );
                                            
                                            // Use coordinates from Area
                                            _latitude = selectedArea.latitude;
                                            _longitude = selectedArea.longitude;
                                            _currentLocationText =
                                                '${_latitude!.toStringAsFixed(6)}, ${_longitude!.toStringAsFixed(6)}';
                                            _isLocationVerified = true;
                                          }
                                        });
                                      },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lokasi patroli harus dipilih';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Lokasi Saat Ini
                      const Text(
                        'Lokasi Saat Ini',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _isLoadingLocation
                                  ? const Row(
                                      children: [
                                        SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          'Mengambil lokasi...',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      _currentLocationText,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: _isLocationVerified
                                            ? Colors.black87
                                            : Colors.red,
                                      ),
                                    ),
                            ),
                            if (_isLocationVerified)
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 20,
                              ),
                            if (!_isLocationVerified && !_isLoadingLocation)
                              IconButton(
                                icon: const Icon(Icons.refresh),
                                iconSize: 20,
                                color: primaryColor,
                                onPressed: _getCurrentLocation,
                                tooltip: 'Refresh Lokasi',
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Bukti Patroli
                      const Text(
                        'Bukti Patroli*',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _proofController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      hintText: 'Lokasi Kejadian ---',
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: _showImagePickerDialog,
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: primaryColor,
                                  ),
                                  tooltip: 'Ambil Foto',
                                ),
                                IconButton(
                                  onPressed: _showImagePickerDialog,
                                  icon: const Icon(
                                    Icons.photo_library,
                                    color: primaryColor,
                                  ),
                                  tooltip: 'Pilih dari Galeri',
                                ),
                              ],
                            ),
                            // Display selected image
                            if (_proofImage != null)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        _proofImage!,
                                        height: 100,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        style: IconButton.styleFrom(
                                          backgroundColor: Colors.black54,
                                          padding: const EdgeInsets.all(4),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _proofImage = null;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Verifikasi Lokasi Berhasil
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8EAF6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isLocationVerified
                                  ? Icons.check_circle
                                  : Icons.info_outline,
                              color: _isLocationVerified
                                  ? const Color(0xFF5C6BC0)
                                  : Colors.orange,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _isLocationVerified
                                    ? 'Verifikasi lokasi berhasil'
                                    : 'Menunggu verifikasi lokasi...',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: _isLocationVerified
                                      ? const Color(0xFF5C6BC0)
                                      : Colors.orange[800],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color:
                                      _isLoading ? Colors.grey : primaryColor,
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Batal',
                                style: TextStyle(
                                  color:
                                      _isLoading ? Colors.grey : primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Simpan',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
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

              // Close button (X)
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Text(
                    'X',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
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
