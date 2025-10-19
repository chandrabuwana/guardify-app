import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/design/colors.dart';
import '../bloc/patrol_bloc.dart';

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
  String? _selectedLocation;
  String _currentLocationText = 'xxxx';
  double? _latitude;
  double? _longitude;
  bool _isLocationVerified = false;
  bool _isLoading = false;

  // Dummy locations for dropdown (API belum jadi)
  final List<String> _availableLocations = [
    'Pos Gajah',
    'Pos Macan',
    'Pos Harimau',
    'Pos Singa',
    'Lobby Utama',
    'Parkiran Basement',
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Simulate getting current location
      await Future.delayed(const Duration(seconds: 1));

      // Mock location (Jakarta area)
      setState(() {
        _latitude = -6.2088 + (0.001 * (DateTime.now().second % 10));
        _longitude = 106.8456 + (0.001 * (DateTime.now().millisecond % 10));
        _currentLocationText =
            '${_latitude!.toStringAsFixed(6)}, ${_longitude!.toStringAsFixed(6)}';
        _isLocationVerified = true;
      });
    } catch (e) {
      setState(() {
        _currentLocationText = 'Gagal mendapatkan lokasi';
      });
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
                      DropdownButtonFormField<String>(
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
                          hintText: 'xxxx',
                        ),
                        items: _availableLocations
                            .where((loc) =>
                                !widget.existingLocations.contains(loc))
                            .map((location) {
                          return DropdownMenuItem(
                            value: location,
                            child: Text(location),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedLocation = value;
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
                              child: Text(
                                _currentLocationText,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            if (_isLocationVerified)
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 20,
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
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  hintText: 'Lokasi Kejadian ---',
                                ),
                                onChanged: (value) {
                                  // Store proof note
                                },
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // TODO: Open camera
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Fitur kamera akan segera hadir'),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Colors.grey,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // TODO: Attach file
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Fitur lampiran akan segera hadir'),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.attach_file,
                                color: Colors.grey,
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
