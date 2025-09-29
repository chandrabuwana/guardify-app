import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/styles.dart';

class LocationDetectionWidget extends StatefulWidget {
  final String targetLocation;
  final Function(double lat, double lng, String locationName)
      onLocationDetected;

  const LocationDetectionWidget({
    super.key,
    required this.targetLocation,
    required this.onLocationDetected,
  });

  @override
  State<LocationDetectionWidget> createState() =>
      _LocationDetectionWidgetState();
}

class _LocationDetectionWidgetState extends State<LocationDetectionWidget> {
  bool _isDetected = false;
  String _currentLocation = '';

  @override
  void initState() {
    super.initState();
    _simulateLocationDetection();
  }

  void _simulateLocationDetection() {
    // Simulate location detection after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isDetected = true;
          _currentLocation = widget.targetLocation; // For demo purposes
        });

        // Notify parent with mock coordinates
        widget.onLocationDetected(
          -6.200000, // Jakarta coordinates for demo
          106.816666,
          widget.targetLocation,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: _isDetected ? Colors.green : Colors.grey,
                size: 20.r,
              ),
              8.horizontalSpace,
              Text(
                'Lokasi Terkini',
                style: TS.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          12.verticalSpace,
          if (!_isDetected) ...[
            Row(
              children: [
                SizedBox(
                  width: 16.w,
                  height: 16.h,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
                12.horizontalSpace,
                Text(
                  'Mendeteksi lokasi...',
                  style: TS.bodyMedium.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ] else ...[
            Container(
              width: double.infinity,
              padding: REdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      _currentLocation,
                      style: TS.bodyMedium.copyWith(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
