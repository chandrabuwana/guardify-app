import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/security/security_manager.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/patrol_location.dart';
import '../../domain/repositories/patrol_repository.dart';
import '../../domain/usecases/verify_location.dart';

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
  bool _isVerifyingLocation = false;
  List<PatrolLocation> _availableAreas = [];
  String? _errorMessage;
  String? _verificationMessage;
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
    setState(() {
      _isLoadingLocation = true;
      _currentLocationText = 'Mengambil lokasi GPS...';
      _isLocationVerified = false;
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
          _isLoadingLocation = false;
        });
        
        // Verify location with selected area if area is selected
        if (_selectedLocation != null) {
          await _verifyLocationWithArea();
        }
      } else {
        // GPS tidak tersedia, minta user untuk mengaktifkan GPS
        if (mounted) {
        setState(() {
          _isLoadingLocation = false;
          _isLocationVerified = false;
          _verificationMessage = 'GPS tidak tersedia';
          _currentLocationText = 'GPS tidak tersedia. Silakan aktifkan GPS dan coba lagi.';
        });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('GPS tidak tersedia. Silakan aktifkan GPS dan coba lagi.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      // Error mendapatkan GPS
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
          _isLocationVerified = false;
          _verificationMessage = 'Error mengambil lokasi GPS';
          _currentLocationText = 'Error mengambil lokasi GPS: $e';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error mengambil lokasi GPS: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _verifyLocationWithArea() async {
    if (_selectedLocation == null || _latitude == null || _longitude == null) {
      setState(() {
        _isLocationVerified = false;
        _verificationMessage = null;
      });
      return;
    }

    setState(() {
      _isVerifyingLocation = true;
      _verificationMessage = 'Memverifikasi lokasi...';
    });

    try {
      // Get selected area details
      final selectedArea = _availableAreas.firstWhere(
        (area) => area.name == _selectedLocation!,
        orElse: () => _availableAreas.first,
      );

      // Use VerifyLocation usecase
      final verifyLocation = getIt<VerifyLocation>();
      final result = await verifyLocation.call(
        VerifyLocationParams(
          currentLatitude: _latitude!,
          currentLongitude: _longitude!,
          targetLatitude: selectedArea.latitude,
          targetLongitude: selectedArea.longitude,
        ),
      );

      result.fold(
        (failure) {
          setState(() {
            _isLocationVerified = false;
            _verificationMessage = 'Verifikasi gagal: ${failure.message}';
            _isVerifyingLocation = false;
          });
        },
        (isVerified) {
          setState(() {
            _isLocationVerified = isVerified;
            _verificationMessage = isVerified
                ? 'Verifikasi lokasi berhasil (dalam radius area)'
                : 'Lokasi tidak berada dalam radius area yang dipilih (maksimal 100 meter)';
            _isVerifyingLocation = false;
          });

          if (!isVerified && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Lokasi saat ini tidak berada dalam radius area "${_selectedLocation}". '
                  'Pastikan Anda berada di lokasi yang benar.',
                ),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        },
      );
    } catch (e) {
      setState(() {
        _isLocationVerified = false;
        _verificationMessage = 'Error verifikasi lokasi: $e';
        _isVerifyingLocation = false;
      });
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

  Future<void> _submitForm() async {
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

    // Verify location is within radius of selected area
    if (!_isLocationVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _verificationMessage ?? 
            'Lokasi tidak berada dalam radius area yang dipilih. Pastikan Anda berada di lokasi yang benar.',
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get shift id from storage (saved from home when get_current is called)
      // No need to hit API again, just read from storage
      final idShiftDetail = await SecurityManager.readSecurely(
        AppConstants.shiftDetailIdKey,
      );
      
      if (idShiftDetail == null || idShiftDetail.isEmpty) {
        print('⚠️ Shift id tidak ditemukan di storage');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Shift id tidak ditemukan. Silakan kembali ke home untuk memuat data shift.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      
      print('✅ Shift id dari storage: $idShiftDetail');

      // Get selected area details
      final selectedArea = _availableAreas.firstWhere(
        (area) => area.name == _selectedLocation!,
      );

      // Get device name
      final deviceName = await _resolveDeviceName();

      // Get actual lat/long from GPS (must be available)
      if (_latitude == null || _longitude == null || !_isLocationVerified) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Lokasi GPS belum tersedia. Silakan tunggu atau refresh lokasi.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      
      final actualLat = _latitude!;
      final actualLng = _longitude!;

      // Call new endpoint /AttendanceDetail/insert
      final repository = getIt<PatrolRepository>();
      final result = await repository.insertAttendanceDetail(
        idShiftDetail: idShiftDetail,
        device: deviceName,
        idAreas: selectedArea.id, // IdAreas from selected location
        latitude: actualLat,
        locationName: selectedArea.name, // LocationName from selected location
        longitude: actualLng,
      );

      result.fold(
        (failure) {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Gagal menambahkan lokasi: ${failure.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        (success) {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Lokasi patroli berhasil ditambahkan'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(true); // Return true to indicate success
            widget.onLocationAdded();
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<String> _resolveDeviceName() async {
    final deviceInfo = DeviceInfoPlugin();
    String deviceName = 'Unknown Device';
    try {
      if (Platform.isAndroid) {
        final info = await deviceInfo.androidInfo;
        deviceName = '${info.manufacturer} ${info.model}';
      } else if (Platform.isIOS) {
        final info = await deviceInfo.iosInfo;
        final machine = info.utsname.machine;
        deviceName = machine.isNotEmpty ? machine : 'iPhone';
      }
    } catch (_) {}
    return deviceName;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                                      isExpanded: true,
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
                                          child: Text(
                                            area.name,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedLocation = value;
                                          _isLocationVerified = false;
                                          _verificationMessage = null;
                                        });
                                        // Verify location with selected area
                                        if (_latitude != null && _longitude != null) {
                                          _verifyLocationWithArea();
                                        } else {
                                          // Get GPS location first, then verify
                                          _getCurrentLocation();
                                        }
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
                      if (_selectedLocation != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _isLocationVerified
                                ? Colors.green[50]
                                : (_isVerifyingLocation
                                    ? Colors.blue[50]
                                    : Colors.orange[50]),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _isLocationVerified
                                  ? Colors.green[300]!
                                  : (_isVerifyingLocation
                                      ? Colors.blue[300]!
                                      : Colors.orange[300]!),
                            ),
                          ),
                          child: Row(
                            children: [
                              if (_isVerifyingLocation)
                                const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              else
                                Icon(
                                  _isLocationVerified
                                      ? Icons.check_circle
                                      : Icons.error_outline,
                                  color: _isLocationVerified
                                      ? Colors.green[700]
                                      : Colors.orange[800],
                                  size: 20,
                                ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _isVerifyingLocation
                                      ? 'Memverifikasi lokasi...'
                                      : (_verificationMessage ??
                                          (_isLocationVerified
                                              ? 'Verifikasi lokasi berhasil (dalam radius area)'
                                              : 'Menunggu verifikasi lokasi...')),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: _isLocationVerified
                                        ? Colors.green[700]
                                        : (_isVerifyingLocation
                                            ? Colors.blue[700]
                                            : Colors.orange[800]),
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
    );
  }
}
