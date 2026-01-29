import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';
import '../../core/design/colors.dart';
import '../../features/panic_button/data/models/panic_button_notification_model.dart';
import '../../features/panic_button/data/models/panic_button_mobile_response_model.dart';

class PanicButtonPopup extends StatefulWidget {
  final PanicButtonNotificationModel? panicButtonData; // Legacy model (for backward compatibility)
  final PanicButtonMobileResponseModel? mobileResponseData; // New simplified model
  final Map<String, dynamic>? rawData;
  final int durationSeconds;

  const PanicButtonPopup({
    super.key,
    this.panicButtonData,
    this.mobileResponseData,
    this.rawData,
    this.durationSeconds = 45, // Default 45 seconds (between 30-60)
  });

  @override
  State<PanicButtonPopup> createState() => _PanicButtonPopupState();
}

class _PanicButtonPopupState extends State<PanicButtonPopup> {
  Timer? _vibrationTimer;
  Timer? _durationTimer;
  bool _isVibrating = false;

  @override
  void initState() {
    super.initState();
    print('🚨 [PanicButtonPopup] Initializing panic button popup');
    print('🚨 [PanicButtonPopup] Duration: ${widget.durationSeconds} seconds');
    print('🚨 [PanicButtonPopup] mobileResponseData: ${widget.mobileResponseData != null ? "NOT NULL" : "NULL"}');
    if (widget.mobileResponseData != null) {
      print('🚨 [PanicButtonPopup] Reporter: ${widget.mobileResponseData!.reporter ?? "null"}');
      print('🚨 [PanicButtonPopup] AreasName: ${widget.mobileResponseData!.areasName ?? "null"}');
      print('🚨 [PanicButtonPopup] IncidentName: ${widget.mobileResponseData!.incidentName ?? "null"}');
      print('🚨 [PanicButtonPopup] Description: ${widget.mobileResponseData!.description ?? "null"}');
      print('🚨 [PanicButtonPopup] Status: ${widget.mobileResponseData!.status ?? "null"}');
      print('🚨 [PanicButtonPopup] ReporterDate: ${widget.mobileResponseData!.reporterDate ?? "null"}');
    }
    print('🚨 [PanicButtonPopup] panicButtonData (legacy): ${widget.panicButtonData != null ? "NOT NULL" : "NULL"}');
    print('🚨 [PanicButtonPopup] rawData: ${widget.rawData != null ? "NOT NULL (${widget.rawData!.length} keys)" : "NULL"}');
    if (widget.rawData != null) {
      print('🚨 [PanicButtonPopup] rawData keys: ${widget.rawData!.keys.toList()}');
    }
    _startVibration();
    _startDurationTimer();
    print('✅ [PanicButtonPopup] Panic button popup initialized');
  }

  void _startVibration() async {
    print('🔔 [PanicButtonPopup] Starting vibration...');
    _isVibrating = true;
    
    // Check if device supports vibration
    final hasVibrator = await Vibration.hasVibrator();
    if (!hasVibrator) {
      print('⚠️ [PanicButtonPopup] Device does not support vibration');
      // Fallback to HapticFeedback
      _vibrateContinuously();
      return;
    }
    
    // Check if device supports amplitude control (Android 8.0+)
    final hasAmplitudeControl = await Vibration.hasAmplitudeControl();
    
    if (hasAmplitudeControl) {
      // Use pattern vibration with amplitude control for stronger vibration
      // Pattern: vibrate 500ms, pause 200ms, repeat
      // Amplitude: 255 (maximum)
      await Vibration.vibrate(
        pattern: [0, 500, 200],
        repeat: 0, // Repeat indefinitely until stopped
        amplitude: 255, // Maximum amplitude
      );
      print('✅ [PanicButtonPopup] Using vibration package with amplitude control');
    } else {
      // Use simple vibration pattern
      await Vibration.vibrate(
        pattern: [0, 500, 200],
        repeat: 0,
      );
      print('✅ [PanicButtonPopup] Using vibration package without amplitude control');
    }
  }

  void _vibrateContinuously() {
    if (!_isVibrating || !mounted) {
      print('🔕 [PanicButtonPopup] Vibration stopped or widget unmounted');
      return;
    }

    // Vibrate pattern: vibrate for 500ms, pause for 200ms
    // Use HapticFeedback for vibration - use heavyImpact for stronger vibration
    try {
      HapticFeedback.heavyImpact();
      // Log every 10th vibration to avoid spam
      if (DateTime.now().millisecond % 10 == 0) {
        print('📳 [PanicButtonPopup] Vibrating... (heavy impact)');
      }
    } catch (e) {
      print('⚠️ [PanicButtonPopup] Error with HapticFeedback.heavyImpact: $e');
      // Fallback to medium impact if heavy impact fails
      try {
        HapticFeedback.mediumImpact();
        print('📳 [PanicButtonPopup] Using medium impact as fallback');
      } catch (e2) {
        print('⚠️ [PanicButtonPopup] Error with HapticFeedback.mediumImpact: $e2');
        // Last resort: try light impact
        try {
          HapticFeedback.lightImpact();
          print('📳 [PanicButtonPopup] Using light impact as last resort');
        } catch (e3) {
          print('❌ [PanicButtonPopup] All haptic feedback methods failed: $e3');
        }
      }
    }
    
    // Schedule next vibration
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_isVibrating && mounted) {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (_isVibrating && mounted) {
            _vibrateContinuously();
          }
        });
      }
    });
  }

  void _startDurationTimer() {
    _durationTimer = Timer(Duration(seconds: widget.durationSeconds), () {
      _stopVibration();
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    });
  }

  void _stopVibration() async {
    setState(() {
      _isVibrating = false;
    });
    _vibrationTimer?.cancel();
    
    // Stop vibration if using vibration package
    try {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator) {
        await Vibration.cancel();
        print('✅ [PanicButtonPopup] Vibration stopped');
      }
    } catch (e) {
      print('⚠️ [PanicButtonPopup] Could not cancel vibration: $e');
    }
  }

  @override
  void dispose() {
    _stopVibration();
    _durationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent back button from closing dialog
        return false;
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Warning Icon
              Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  color: errorColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 50.sp,
                  color: errorColor,
                ),
              ),
              24.verticalSpace,

              // Title
              Text(
                'PANIC BUTTON AKTIF',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: errorColor,
                ),
                textAlign: TextAlign.center,
              ),
              16.verticalSpace,

              // Message
              Text(
                'Ada situasi darurat yang memerlukan perhatian segera!',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: neutral70,
                ),
                textAlign: TextAlign.center,
              ),
              8.verticalSpace,

              // Display panic button information (prioritize new mobile response model)
              if (widget.mobileResponseData != null) ...[
                16.verticalSpace,
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: neutral10,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informasi Kejadian:',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: neutral90,
                        ),
                      ),
                      12.verticalSpace,
                      
                      // Reporter Info
                      if (widget.mobileResponseData!.reporter != null && 
                          widget.mobileResponseData!.reporter!.isNotEmpty) ...[
                        _buildInfoRow(
                          'Pelapor',
                          widget.mobileResponseData!.reporter!,
                        ),
                      ],
                      
                      // Area Info
                      if (widget.mobileResponseData!.areasName != null && 
                          widget.mobileResponseData!.areasName!.isNotEmpty) ...[
                        _buildInfoRow(
                          'Area',
                          widget.mobileResponseData!.areasName!,
                        ),
                      ],
                      
                      // Incident Type
                      if (widget.mobileResponseData!.incidentName != null && 
                          widget.mobileResponseData!.incidentName!.isNotEmpty) ...[
                        _buildInfoRow(
                          'Jenis Kejadian',
                          widget.mobileResponseData!.incidentName!,
                        ),
                      ],
                      
                      // Description
                      if (widget.mobileResponseData!.description != null && 
                          widget.mobileResponseData!.description!.isNotEmpty) ...[
                        _buildInfoRow(
                          'Deskripsi',
                          widget.mobileResponseData!.description!,
                        ),
                      ],
                      
                      // Reporter Date
                      if (widget.mobileResponseData!.reporterDate != null && 
                          widget.mobileResponseData!.reporterDate!.isNotEmpty) ...[
                        _buildInfoRow(
                          'Waktu Laporan',
                          _formatDateTime(widget.mobileResponseData!.reporterDate!),
                        ),
                      ],
                      
                      // Status
                      if (widget.mobileResponseData!.status != null && 
                          widget.mobileResponseData!.status!.isNotEmpty) ...[
                        _buildInfoRow(
                          'Status',
                          widget.mobileResponseData!.status!,
                        ),
                      ],
                      
                      // Show message if no data available
                      if ((widget.mobileResponseData!.reporter == null || widget.mobileResponseData!.reporter!.isEmpty) &&
                          (widget.mobileResponseData!.areasName == null || widget.mobileResponseData!.areasName!.isEmpty) &&
                          (widget.mobileResponseData!.incidentName == null || widget.mobileResponseData!.incidentName!.isEmpty) &&
                          (widget.mobileResponseData!.description == null || widget.mobileResponseData!.description!.isEmpty) &&
                          (widget.mobileResponseData!.reporterDate == null || widget.mobileResponseData!.reporterDate!.isEmpty) &&
                          (widget.mobileResponseData!.status == null || widget.mobileResponseData!.status!.isEmpty)) ...[
                        _buildInfoRow(
                          'Status',
                          'Data kejadian sedang dimuat...',
                        ),
                      ],
                    ],
                  ),
                ),
              ] else if (widget.panicButtonData != null) ...[
                // Legacy model support (backward compatibility)
                16.verticalSpace,
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: neutral10,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informasi Kejadian:',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: neutral90,
                        ),
                      ),
                      12.verticalSpace,
                      
                      // Reporter Info
                      if (widget.panicButtonData!.reporter != null) ...[
                        _buildInfoRow(
                          'Pelapor',
                          widget.panicButtonData!.reporter!.fullname ?? 
                          widget.panicButtonData!.reporter!.username ?? 
                          'Tidak diketahui',
                        ),
                      ],
                      
                      // Area Info
                      if (widget.panicButtonData!.areas != null) ...[
                        _buildInfoRow(
                          'Area',
                          widget.panicButtonData!.areas!.name,
                        ),
                      ],
                      
                      // Incident Type
                      if (widget.panicButtonData!.incidentType != null) ...[
                        _buildInfoRow(
                          'Jenis Kejadian',
                          widget.panicButtonData!.incidentType!.name,
                        ),
                      ],
                      
                      // Description
                      if (widget.panicButtonData!.description != null && 
                          widget.panicButtonData!.description!.isNotEmpty) ...[
                        _buildInfoRow(
                          'Deskripsi',
                          widget.panicButtonData!.description!,
                        ),
                      ],
                      
                      // Reporter Date
                      if (widget.panicButtonData!.reporterDate != null) ...[
                        _buildInfoRow(
                          'Waktu Laporan',
                          _formatDateTime(widget.panicButtonData!.reporterDate!),
                        ),
                      ],
                      
                      // Status
                      if (widget.panicButtonData!.status != null) ...[
                        _buildInfoRow(
                          'Status',
                          widget.panicButtonData!.status!,
                        ),
                      ],
                    ],
                  ),
                ),
              ] else if (widget.rawData != null && widget.rawData!.isNotEmpty) ...[
                // Fallback to raw data display if parsing failed
                16.verticalSpace,
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: neutral10,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informasi:',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: neutral90,
                        ),
                      ),
                      8.verticalSpace,
                      ...widget.rawData!.entries.map((entry) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 4.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${entry.key}: ',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: neutral70,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  entry.value.toString(),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: neutral70,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],

              24.verticalSpace,

              // Countdown or status
              Text(
                'Popup ini akan tertutup otomatis dalam beberapa saat',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: neutral50,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: neutral70,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12.sp,
                color: neutral70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String dateTimeString) {
    try {
      // Try parsing ISO format or common date formats
      DateTime? dateTime;
      
      // Try ISO format first
      try {
        dateTime = DateTime.parse(dateTimeString);
      } catch (e) {
        // Try other formats if needed
        // For now, just return the original string if parsing fails
        return dateTimeString;
      }
      
      // Format to Indonesian locale
      final formatter = DateFormat('dd MMMM yyyy, HH:mm', 'id_ID');
      return formatter.format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }
}
