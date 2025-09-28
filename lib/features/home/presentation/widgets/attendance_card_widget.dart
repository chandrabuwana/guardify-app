import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendanceCardWidget extends StatelessWidget {
  final bool isCheckedIn;
  final String shift;
  final String position;
  final String currentTime;
  final VoidCallback? onTap;

  const AttendanceCardWidget({
    super.key,
    required this.isCheckedIn,
    required this.shift,
    required this.position,
    required this.currentTime,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
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
        child: Padding(
          padding: REdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Senin, 22 September 2025',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  if (isCheckedIn)
                    Container(
                      padding:
                          REdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        'Hadir',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              8.verticalSpace,
              Text(
                shift,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
              4.verticalSpace,
              Row(
                children: [
                  Text(
                    'Jam Absen Pagi',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  if (isCheckedIn)
                    Row(
                      children: [
                        Icon(
                          Icons.group,
                          size: 16.r,
                          color: const Color(0xFFB71C1C),
                        ),
                        4.horizontalSpace,
                        Text(
                          'Tim Jaga',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFFB71C1C),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        8.horizontalSpace,
                        Container(
                          width: 24.w,
                          height: 24.h,
                          decoration: const BoxDecoration(
                            color: Color(0xFFB71C1C),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '+3',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          alignment: Alignment.center,
                        ),
                      ],
                    ),
                ],
              ),
              if (isCheckedIn) ...[
                4.verticalSpace,
                Row(
                  children: [
                    Text(
                      'Jam Absen Pagi',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      currentTime,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ] else ...[
                4.verticalSpace,
                Text(
                  '-',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
              16.verticalSpace,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCheckedIn
                        ? Colors.grey[400]
                        : const Color(0xFFB71C1C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: REdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  child: Text(
                    isCheckedIn ? 'Akhiri Bekerja' : 'Mulai Bekerja',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
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
