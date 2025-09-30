import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guardify_app/core/design/colors.dart';

class PanicButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const PanicButtonWidget({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Row(
        children: [
          // Tombol Text
          Expanded(
            child: Text(
              'TOMBOL',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: primaryColor,
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // SOS Button
          GestureDetector(
            onTap: onPressed,
            child: Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                gradient: Gradients.primary(),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_rounded,
                    color: Colors.white,
                    size: 32.sp,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'SOS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Darurat Text
          Expanded(
            child: Text(
              'DARURAT',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: primaryColor,
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
