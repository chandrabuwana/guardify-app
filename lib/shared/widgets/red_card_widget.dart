import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RedCardWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final bool isFullWidth;

  const RedCardWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.onTap,
    this.width,
    this.height,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isFullWidth ? double.infinity : width,
        height: height ?? 100.h, // Increased from 80.h to 100.h
        decoration: BoxDecoration(
          color: const Color(0xFFE74C3C),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.2),
              blurRadius: 8.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(12.w), // Reduced from 16.w to 12.w
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: Colors.white,
                  size: 20.w, // Reduced from 24.w to 20.w
                ),
                6.verticalSpace, // Better than SizedBox(height: 6.h)
              ],
              Flexible(
                // Added Flexible to prevent overflow
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2, // Limit to 2 lines
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (subtitle != null) ...[
                3.verticalSpace, // Better than SizedBox(height: 3.h)
                Flexible(
                  // Added Flexible to prevent overflow
                  child: Text(
                    subtitle!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                    ),
                    maxLines: 1, // Limit to 1 line
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
