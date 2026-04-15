import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/styles.dart';
import '../../domain/entities/attendance.dart';

class AttendanceHeaderWidget extends StatelessWidget {
  final String userName;
  final AttendanceType attendanceType;

  const AttendanceHeaderWidget({
    super.key,
    required this.userName,
    required this.attendanceType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(20),
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
        children: [
          // Scanner frame similar to the design
          Container(
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: const Color(0xFF3F51B5),
                width: 3,
              ),
            ),
            child: Stack(
              children: [
                // Corner frames (like a scanner viewfinder)
                Positioned(
                  top: 20,
                  left: 20,
                  child: _buildCornerFrame(true, true),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: _buildCornerFrame(true, false),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: _buildCornerFrame(false, true),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: _buildCornerFrame(false, false),
                ),

                // Center content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 40.r,
                        color: Colors.grey[400],
                      ),
                      8.verticalSpace,
                      Text(
                        'Posisikan wajah pada\narea yang tersedia',
                        textAlign: TextAlign.center,
                        style: TS.bodyMedium.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          20.verticalSpace,

          // User info
          Row(
            children: [
              Text(
                'Nama Personil',
                style: TS.bodyMedium.copyWith(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          8.verticalSpace,

          Container(
            width: double.infinity,
            padding: REdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              userName,
              style: TS.bodyLarge.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCornerFrame(bool isTop, bool isLeft) {
    return Container(
      width: 30.w,
      height: 30.h,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? const BorderSide(color: Color(0xFF3F51B5), width: 4)
              : BorderSide.none,
          bottom: !isTop
              ? const BorderSide(color: Color(0xFF3F51B5), width: 4)
              : BorderSide.none,
          left: isLeft
              ? const BorderSide(color: Color(0xFF3F51B5), width: 4)
              : BorderSide.none,
          right: !isLeft
              ? const BorderSide(color: Color(0xFF3F51B5), width: 4)
              : BorderSide.none,
        ),
      ),
    );
  }
}
