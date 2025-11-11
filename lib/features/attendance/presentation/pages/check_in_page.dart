import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../../../core/di/injection.dart';
import '../../../../shared/widgets/Buttons/ui_button.dart';
import '../../../../shared/widgets/TextInput/input_primary.dart';
import '../../../../shared/widgets/photo_picker_field.dart';
import '../../domain/entities/attendance_request.dart';
import '../bloc/attendance_bloc.dart';
import '../bloc/attendance_event.dart';
import '../bloc/attendance_state.dart';
import '../../../shift/data/datasources/shift_remote_data_source.dart';
import '../../../shift/data/models/shift_current_location_response.dart';
import '../../../../core/services/location_service.dart';

class CheckInPage extends StatefulWidget {
  final String userId;
  final String namaPersonil;
  final String? prefillFullname;
  final String? prefillLocation;
  final String? prefillCurrentLocation;
  final String? prefillRouteName;

  const CheckInPage({
    Key? key,
    required this.userId,
    required this.namaPersonil,
    this.prefillFullname,
    this.prefillLocation,
    this.prefillCurrentLocation,
    this.prefillRouteName,
  }) : super(key: key);

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  int currentStep = 0;
  late AttendanceBloc _attendanceBloc; // Add bloc reference

  // Controllers
  final _namaPersonilController = TextEditingController();
  final _lokasiPenugasanController = TextEditingController();
  final _lokasiTerkiniController = TextEditingController();
  final _rutePatroliController = TextEditingController();
  final _laporanPengamananController = TextEditingController();

  // Form data
  String _pakaianPersonil = '';
  List<String> _fotoPengamanan = [];
  List<String> _tugasLanjutan = [];
  String? _fotoWajah;
  double? _currentLat;
  double? _currentLng;

  @override
  void initState() {
    super.initState();
    _attendanceBloc = getIt<AttendanceBloc>();
    _namaPersonilController.text =
        widget.prefillFullname ?? widget.namaPersonil;
    if (widget.prefillLocation != null) {
      _lokasiPenugasanController.text = widget.prefillLocation!;
    }
    final prefillCurrentLocation = widget.prefillCurrentLocation;
    if (prefillCurrentLocation != null && prefillCurrentLocation.isNotEmpty) {
      _lokasiTerkiniController.text = prefillCurrentLocation;
    } else {
      _lokasiTerkiniController.text = '-';
      _getCurrentLocation();
    }
    final prefillRouteName = widget.prefillRouteName;
    if (prefillRouteName != null && prefillRouteName.isNotEmpty) {
      _rutePatroliController.text = prefillRouteName;
    } else {
      _rutePatroliController.text = '-';
      if (prefillCurrentLocation != null && prefillCurrentLocation.isNotEmpty) {
        _getCurrentLocation();
      }
    }
  }

  void _getCurrentLocation() {
    final locationService = getIt<LocationService>();
    locationService.getCurrentLatLng().then((pos) {
      if (pos == null) return;
      _currentLat = pos.lat;
      _currentLng = pos.lng;
      _prefillFromShiftApi(pos.lat, pos.lng);
    });
  }

  Future<void> _prefillFromShiftApi(double lat, double lng) async {
    try {
      final shiftDs = getIt<ShiftRemoteDataSource>();
      final ShiftCurrentLocationResponse res =
          await shiftDs.getCurrentLocation(latitude: lat, longitude: lng);
      final data = res.data;
      if (!mounted) return;
      setState(() {
        if (data?.fullname != null) {
          _namaPersonilController.text = data!.fullname!;
        }
        if (data?.location != null) {
          _lokasiPenugasanController.text = data!.location!;
        }
        _lokasiTerkiniController.text =
            (data?.currentLocation != null && data!.currentLocation!.isNotEmpty)
                ? data.currentLocation!
                : '-';
        final routeName =
            (data?.routeName != null && data!.routeName!.isNotEmpty)
                ? data.routeName!
                : '-';
        _rutePatroliController.text = routeName;
      });
    } catch (e) {
      // Fallback UI values unchanged on failure
    }
  }

  Future<void> _captureSelfie() async {
    if (!mounted) return;

    final permissionStatus = await Permission.camera.request();
    if (!permissionStatus.isGranted) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Izin kamera diperlukan untuk mengambil foto.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    List<CameraDescription> cameras;
    try {
      cameras = await availableCameras();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengakses kamera: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (cameras.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kamera tidak tersedia.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    final image = await Navigator.of(context).push<XFile?>(
      MaterialPageRoute(
        builder: (_) => _SelfieCameraPage(camera: frontCamera),
      ),
    );

    if (image != null && mounted) {
      setState(() {
        _fotoWajah = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _attendanceBloc..add(const CheckInStartedEvent()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          title: const Text('Mulai Bekerja'),
          centerTitle: true,
          elevation: 0,
        ),
        body: BlocConsumer<AttendanceBloc, AttendanceState>(
          listener: (context, state) {
            if (state is AttendanceCheckedIn) {
              // Show success dialog when check-in is successful
              _showSuccessDialog();
            } else if (state is AttendanceFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AttendanceLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                // Progress Indicator
                Container(
                  padding: REdgeInsets.all(20),
                  color: primaryColor,
                  child: Row(
                    children: [
                      for (int i = 0; i < 3; i++) ...[
                        Expanded(
                          child: Container(
                            height: 4.h,
                            decoration: BoxDecoration(
                              color: i <= currentStep
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                        ),
                        if (i < 2) 8.horizontalSpace,
                      ],
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: REdgeInsets.all(20),
                    child: _buildStepContent(),
                  ),
                ),

                // Bottom Navigation
                Container(
                  padding: REdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: _buildBottomButtons(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      default:
        return _buildStep1();
    }
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Face Scan Section
        InkWell(
          onTap: _captureSelfie,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: double.infinity,
            height: 280.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.blue.shade300,
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: Stack(
              children: [
                // Corner brackets
                Positioned(
                  top: 20,
                  left: 20,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.blue.shade700, width: 4),
                        left: BorderSide(color: Colors.blue.shade700, width: 4),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.blue.shade700, width: 4),
                        right:
                            BorderSide(color: Colors.blue.shade700, width: 4),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(color: Colors.blue.shade700, width: 4),
                        left: BorderSide(color: Colors.blue.shade700, width: 4),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(color: Colors.blue.shade700, width: 4),
                        right:
                            BorderSide(color: Colors.blue.shade700, width: 4),
                      ),
                    ),
                  ),
                ),
                // Center content
                Center(
                  child: _fotoWajah == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 48.sp,
                              color: Colors.grey.shade600,
                            ),
                            12.verticalSpace,
                            Text(
                              'Ketuk untuk mengambil foto wajah',
                              style: TS.bodyMedium.copyWith(
                                color: Colors.grey.shade600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.file(
                            File(_fotoWajah!),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),

        24.verticalSpace,

        // Form Fields
        InputPrimary(
          label: 'Nama Personil',
          controller: _namaPersonilController,
          readOnly: true,
          margin: REdgeInsets.only(bottom: 16),
        ),

        InputPrimary(
          label: 'Lokasi Penjagaan',
          controller: _lokasiPenugasanController,
          readOnly: true,
          margin: REdgeInsets.only(bottom: 16),
        ),

        InputPrimary(
          label: 'Lokasi Terkini',
          controller: _lokasiTerkiniController,
          readOnly: true,
          margin: REdgeInsets.only(bottom: 16),
          suffixIcon: IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
          ),
        ),

        InputPrimary(
          label: 'Rute Patroli',
          controller: _rutePatroliController,
          enable: false,
          margin: REdgeInsets.only(bottom: 16),
        ),

        // Location validation warning
        if (_lokasiTerkiniController.text != _lokasiPenugasanController.text)
          Container(
            width: double.infinity,
            padding: REdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 20.sp,
                ),
                8.horizontalSpace,
                Expanded(
                  child: Text(
                    'Di luar area penjagaan, harap dekat lokasi.',
                    style: TS.bodySmall.copyWith(
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PhotoPickerField(
          label: 'Pakaian Personil',
          photos: _pakaianPersonil.isEmpty ? [] : [_pakaianPersonil],
          onPhotosChanged: (photos) {
            setState(() {
              _pakaianPersonil = photos.isNotEmpty ? photos.first : '';
            });
          },
          isRequired: true,
          maxPhotos: 1,
          margin: REdgeInsets.only(bottom: 16),
        ),

        InputPrimary(
          label: 'Laporan Pengamanan',
          controller: _laporanPengamananController,
          hint: 'Keterangan Pengamanan',
          maxLines: 4,
          margin: REdgeInsets.only(bottom: 16),
          isRequired: true,
        ),

        PhotoPickerField(
          label: 'Foto Pengamanan',
          photos: _fotoPengamanan,
          onPhotosChanged: (photos) {
            setState(() {
              _fotoPengamanan = photos;
            });
          },
          isRequired: true,
          margin: REdgeInsets.only(bottom: 16),
        ),

        Text(
          'Tugas Lanjutan',
          style: TS.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        8.verticalSpace,

        Container(
          width: double.infinity,
          padding: REdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            '${_tugasLanjutan.length} Tugas Lanjutan',
            style: TS.bodyMedium.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ),

        12.verticalSpace,

        // Task Checkboxes
        ...[
          'Patroli Perimeter Gedung',
          'Pengecekan CCTV Area',
          'Laporan Kejadian Khusus',
          'Koordinasi Tim Keamanan',
          'Inspeksi Peralatan',
          'Monitoring Akses Keluar Masuk'
        ]
            .map(
              (task) => Container(
                margin: REdgeInsets.only(bottom: 8),
                child: CheckboxListTile(
                  title: Text(
                    task,
                    style: TS.bodyMedium,
                  ),
                  value: _tugasLanjutan.contains(task),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _tugasLanjutan.add(task);
                      } else {
                        _tugasLanjutan.remove(task);
                      }
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: primaryColor,
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: REdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 48.sp,
                color: Colors.green,
              ),
              12.verticalSpace,
              Text(
                'Konfirmasi Data',
                style: TS.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              8.verticalSpace,
              Text(
                'Pastikan semua data yang Anda masukkan sudah benar',
                style: TS.bodyMedium.copyWith(
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        24.verticalSpace,

        // Summary
        _buildSummaryItem('Nama Personil', _namaPersonilController.text),
        _buildSummaryItem('Lokasi Penugasan', _lokasiPenugasanController.text),
        _buildSummaryItem('Lokasi Terkini', _lokasiTerkiniController.text),
        _buildSummaryItem('Foto Wajah', _fotoWajah != null ? 'Tersimpan' : '-'),
        _buildSummaryItem('Rute Patroli', _rutePatroliController.text),
        _buildSummaryItem('Pakaian Personil', _pakaianPersonil),
        _buildSummaryItem(
            'Laporan Pengamanan', _laporanPengamananController.text),
        _buildSummaryItem('Foto Pengamanan', '${_fotoPengamanan.length} foto'),
        _buildSummaryItem('Tugas Lanjutan', '${_tugasLanjutan.length} tugas'),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: REdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              label,
              style: TS.bodyMedium.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Text(': ', style: TS.bodyMedium),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: TS.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    if (currentStep == 0) {
      return Row(
        children: [
          Expanded(
            child: UIButton(
              text: 'KEMBALI',
              buttonType: UIButtonType.outline,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          16.horizontalSpace,
          Expanded(
            child: UIButton(
              text: 'LANJUT',
              onPressed: _canProceedFromStep1()
                  ? () {
                      setState(() {
                        currentStep = 1;
                      });
                    }
                  : null,
            ),
          ),
        ],
      );
    } else if (currentStep == 1) {
      return Row(
        children: [
          Expanded(
            child: UIButton(
              text: 'KEMBALI',
              buttonType: UIButtonType.outline,
              onPressed: () {
                setState(() {
                  currentStep = 0;
                });
              },
            ),
          ),
          16.horizontalSpace,
          Expanded(
            child: UIButton(
              text: 'LANJUT',
              onPressed: _canProceedFromStep2()
                  ? () {
                      setState(() {
                        currentStep = 2;
                      });
                    }
                  : null,
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: UIButton(
              text: 'KEMBALI',
              buttonType: UIButtonType.outline,
              onPressed: () {
                setState(() {
                  currentStep = 1;
                });
              },
            ),
          ),
          16.horizontalSpace,
          Expanded(
            child: UIButton(
              text: 'MULAI BEKERJA',
              onPressed: _submitCheckIn,
            ),
          ),
        ],
      );
    }
  }

  bool _canProceedFromStep1() {
    final routeName = _rutePatroliController.text.trim();
    return routeName.isNotEmpty && routeName != '-' && _fotoWajah != null;
  }

  bool _canProceedFromStep2() {
    return _pakaianPersonil.isNotEmpty &&
        _laporanPengamananController.text.isNotEmpty &&
        _fotoPengamanan.isNotEmpty &&
        _tugasLanjutan.isNotEmpty;
  }

  void _submitCheckIn() async {
    // Show confirmation dialog first
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60.w,
              height: 60.h,
              decoration: const BoxDecoration(
                color: Color(0xFFB71C1C),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.help_outline,
                color: Colors.white,
                size: 30,
              ),
            ),
            20.verticalSpace,
            Text(
              'Apakah Anda yakin\nmengirim laporan bekerja?',
              textAlign: TextAlign.center,
              style: TS.titleMedium.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        actions: [
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB71C1C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: REdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  child: Text(
                    'Ya',
                    style: TS.labelLarge.copyWith(fontSize: 16.sp),
                  ),
                ),
              ),
              10.verticalSpace,
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFB71C1C),
                    side: const BorderSide(color: Color(0xFFB71C1C)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: REdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Tidak',
                    style: TS.labelLarge.copyWith(fontSize: 16.sp),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // Submit to bloc - success dialog will be shown by listener
      final request = CheckInRequest(
        userId: widget.userId,
        shift: 'Pagi',
        lokasiPenugasan: _lokasiPenugasanController.text,
        lokasiTerkini: _lokasiTerkiniController.text,
        latitude: _currentLat,
        longitude: _currentLng,
        ratePatrol: _rutePatroliController.text,
        pakaianPersonil: _pakaianPersonil,
        laporanPengamanan: _laporanPengamananController.text,
        fotoPengamanan: _fotoPengamanan,
        tugasLanjutan: _tugasLanjutan,
        fotoWajah: _fotoWajah,
      );

      _attendanceBloc.add(CheckInSubmittedEvent(request));
    }
  }

  void _showSuccessDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60.w,
              height: 60.h,
              decoration: const BoxDecoration(
                color: Color(0xFFB71C1C),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.thumb_up,
                color: Colors.white,
                size: 30,
              ),
            ),
            20.verticalSpace,
            Text(
              'Check In Berhasil',
              style: TS.titleLarge.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            8.verticalSpace,
            Text(
              'Selamat Bekerja!',
              style: TS.bodyMedium.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                // Safely navigate back to home by popping until home route
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB71C1C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: REdgeInsets.symmetric(vertical: 12),
                elevation: 0,
              ),
              child: Text(
                'OK',
                style: TS.labelLarge.copyWith(fontSize: 16.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _attendanceBloc.close();
    _namaPersonilController.dispose();
    _lokasiPenugasanController.dispose();
    _lokasiTerkiniController.dispose();
    _rutePatroliController.dispose();
    _laporanPengamananController.dispose();
    super.dispose();
  }
}

class _SelfieCameraPage extends StatefulWidget {
  const _SelfieCameraPage({required this.camera});

  final CameraDescription camera;

  @override
  State<_SelfieCameraPage> createState() => _SelfieCameraPageState();
}

class _SelfieCameraPageState extends State<_SelfieCameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambil Foto Wajah'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(
                  child:
                      widget.camera.lensDirection == CameraLensDirection.front
                          ? Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()..rotateY(math.pi),
                              child: CameraPreview(_controller),
                            )
                          : CameraPreview(_controller),
                ),
                Container(
                  width: double.infinity,
                  padding: REdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  color: Colors.black,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Posisikan wajah dalam frame lalu tekan tombol kamera.',
                        style: TS.bodyMedium.copyWith(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                      16.verticalSpace,
                      SizedBox(
                        width: 72.r,
                        height: 72.r,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: Colors.white,
                            elevation: 6,
                          ),
                          onPressed: () async {
                            try {
                              await _initializeControllerFuture;
                              final image = await _controller.takePicture();
                              if (!mounted) return;
                              Navigator.of(context).pop(image);
                            } catch (e) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Gagal mengambil foto: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          child: Icon(
                            Icons.camera_alt,
                            color: primaryColor,
                            size: 32.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
