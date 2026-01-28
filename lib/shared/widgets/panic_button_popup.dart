import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../core/design/colors.dart';
import '../../features/panic_button/data/models/panic_button_notification_model.dart';

class PanicButtonPopup extends StatefulWidget {
  final PanicButtonNotificationModel? panicButtonData;
  final Map<String, dynamic>? rawData;
  final int durationSeconds;

  const PanicButtonPopup({
    super.key,
    this.panicButtonData,
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
    _startVibration();
    _startDurationTimer();
  }

  void _startVibration() {
    _isVibrating = true;
    _vibrateContinuously();
  }

  void _vibrateContinuously() {
    if (!_isVibrating) return;

    // Vibrate pattern: vibrate for 500ms, pause for 200ms
    HapticFeedback.heavyImpact();
    
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

  void _stopVibration() {
    setState(() {
      _isVibrating = false;
    });
    _vibrationTimer?.cancel();
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

              // Display panic button information
              if (widget.panicButtonData != null) ...[
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
